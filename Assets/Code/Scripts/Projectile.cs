using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class Projectile : MonoBehaviour
{
    [SerializeField] private float speed = 5;
    [SerializeField] private float destroyTimer = 2;
    [SerializeField] private Character owner;
    [SerializeField] private Faction target;
    public UnityEvent hitEvent;


    private List<Collider> hitlist;
    private bool stopped = false;

    void Awake()
    {
        hitlist = new List<Collider>();
    }

    void Update()
    {
        if (!stopped)
        {
            transform.position += transform.forward * Time.deltaTime * speed;
        }
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
                        hitEvent.Invoke();
                    }
                    break;
                case 0:
                    if (other.gameObject.tag != "Player" && !hitlist.Contains(other))
                    {
                        hitlist.Add(other);
                        hitchar.RegisterHit();
                        hitEvent.Invoke();
                    }
                    break;
            }
        else
        {
            hitEvent.Invoke();
            stopped = true;
            StartCoroutine(KillAfterTimer());
        }
    }

    private IEnumerator KillAfterTimer()
    {
        yield return new WaitForSeconds(destroyTimer);
        Destroy(gameObject);
    }
}
