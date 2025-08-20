using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class MeleeWeapon : MonoBehaviour
{
    private Faction target;
    private List<Collider> hitlist;
    private Collider wepcollider;
    private Character owner;
    public UnityEvent hitEvent;

    void Awake()
    {
        hitlist = new List<Collider>();
        wepcollider = GetComponent<Collider>();
    }

    void OnTriggerEnter(Collider other)
    {
        Character hitchar = other.GetComponent<Character>();

        if (hitchar != null)
            switch (target.GetHashCode())
            {
                case 1:
                    if (other.gameObject.tag == "Player" && !hitlist.Contains(other))
                    {
                        hitlist.Add(other);
                        hitchar.ReceiveHit();
                        owner.LandHit();
                        hitEvent.Invoke();
                    }
                    break;
                case 0:
                    if (other.gameObject.tag != "Player" && !hitlist.Contains(other))
                    {
                        hitlist.Add(other);
                        hitchar.RegisterHit();
                        owner.LandHit();
                        hitEvent.Invoke();
                    }
                    break;
            }
    }

    public void StartAttack()
    {
        hitlist = new List<Collider>();
        wepcollider.enabled = true;
    }

    public void StopAttack()
    {
        wepcollider.enabled = false;
    }

    public void SetupWeapon(Character character)
    {
        owner = character;
        if (character.faction == Faction.Enemy)
        {
            target = Faction.Ally;
        }
        else
        {
            target = Faction.Enemy;
        }
    }
}