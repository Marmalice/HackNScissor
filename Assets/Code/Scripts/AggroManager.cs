using System.Collections.Generic;
using UnityEngine;

public class AggroManager : MonoBehaviour
{
    public static AggroManager aggroManager;
    [HideInInspector] public GameObject player;
    private List<Character> characters = new List<Character>();
    public List<Character> targetables { get; protected set; } = new List<Character>();

    void Awake()
    {
        if (aggroManager != null)
        {
            Destroy(this);
        }
        else
        {
            aggroManager = this;
            player = GameObject.FindWithTag("Player");
        }
    }

    public GameObject RegisterCharacter(Character character)
    {
        characters.Add(character);

        if (character.faction == Faction.Enemy)
        {
            targetables.Add(character);
        }

        return player;
    }

    public void MakeUntargetable(Character character)
    {
        targetables.Remove(character);
    }

    public void ReregisterPlayer(GameObject newplayer)
    {
        foreach (Character character in targetables)
        {
            character.OverridePlayer(newplayer);
        }
    }
}
