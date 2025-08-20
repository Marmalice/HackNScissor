using Unity.VisualScripting;
using UnityEngine;

public class ProjectileHandler : MonoBehaviour
{
    [SerializeField] private Transform spawn;
    [SerializeField] private GameObject[] projectiles;

    private GameObject player;
    private Character character;

    void Awake()
    {
        character = GetComponent<Character>();
        character.SetupComplete.AddListener(GetTarget);
    }

    void GetTarget()
    {
        player = GetComponent<Character>().player;
    }
    public void CastProjectile(int pick = 0)
    {
        GetTarget();
        Instantiate(projectiles[pick], spawn.position, Quaternion.LookRotation(player.transform.position + transform.up - spawn.position));
    }
}
