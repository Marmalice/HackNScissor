using UnityEngine;
using UnityEngine.InputSystem;

public class PlayerInputPasser : MonoBehaviour
{
    private PlayerRM[] characters;

    public void OnEnable()
    {
        IndexCharacters();
    }

    private void IndexCharacters()
    {
        characters = GetComponentsInChildren<PlayerRM>(true);
    }

    private void BroadcastInput(string eventname, InputValue value)
    {
        foreach (PlayerRM player in characters)
        {
            if (player.isActiveAndEnabled)
            player.SendMessage(eventname, value);
        }
    }

    public void OnDodge(InputValue value)
    {
        BroadcastInput("OnDodge", value);
    }

    public void OnMove(InputValue value)
    {
        BroadcastInput("OnMove", value);
    }

    public void OnInteract(InputValue value)
    {
        BroadcastInput("OnInteract", value);
    }

    public void OnLook(InputValue value)
    {
        BroadcastInput("OnLook", value);
    }

    public void OnLock(InputValue value)
    {
        BroadcastInput("OnLock", value);
    }

    public void OnM1(InputValue value)
    {
        BroadcastInput("OnM1", value);
    }

    public void OnM2(InputValue value)
    {
        BroadcastInput("OnM2", value);
    }
}
