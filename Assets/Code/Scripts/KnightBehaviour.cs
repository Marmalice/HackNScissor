using System.Collections;
using Unity.VisualScripting;
using UnityEngine;

public class KnightBehaviour : Character
{
    private int HP = 3;
    private float AttackCool = 0f;
    private float GlareTimer = 3;
    public KnightState state;

    [SerializeField] private float aggroRadius = 5;

    void Awake()
    {
        controller = GetComponent<CharacterController>();
        animator = GetComponent<Animator>();
    }

    void Start()
    {
        state = KnightState.Idling;
        SetupCharacter();
    }

    public override void RegisterHit()
    {
        if (state == KnightState.Blocking)
        {
            if (Vector3.Dot(wishDir, transform.forward) > .5f)
            {
                animator.SetTrigger("Hit");
                Debug.Log("Hit the shield of " + name);
                return;
            }

            else
            {
                SwapState(KnightState.Glaring);
            }
        }

        HP--;

        if (HP > 0)
        {
            animator.SetTrigger("Hit");
        }
        else if (state != KnightState.Dead)
        {
            state = KnightState.Dead;
            animator.SetTrigger("Die");
            Die();
        }
        //StartCoroutine(KnockBack());
    }



    void Update()
    {
        controller.Move(Vector3.down * Time.deltaTime * 9.81f);

        wishDir = player.transform.position - transform.position;

        switch (state.GetHashCode())
        {
            //Idling
            case 0:
                if (wishDir.magnitude < aggroRadius)
                {
                    SwapState(KnightState.Glaring);
                }
                break;
            //Glaring
            case 1:
                GlareTimer -= Time.deltaTime;

                RotateToPlayer();

                if (GlareTimer > 0)
                {
                    if (wishDir.magnitude < 6)
                    {
                        SwapState(KnightState.Blocking);
                    }
                }
                else
                {
                    SwapState(KnightState.Chasing);
                }
                break;
            //Chasing
            case 2:
                RotateToPlayer();

                if (wishDir.magnitude < 2)
                {
                    SwapState(KnightState.Attacking);
                }

                if (wishDir.magnitude > 10)
                {
                    SwapState(KnightState.Glaring);
                }
                break;
            //Attacking
            case 3:
                if (AttackCool > 0)
                {
                    AttackCool -= Time.deltaTime;
                    return;
                }

                if (wishDir.magnitude > 6)
                {
                    SwapState(KnightState.Glaring);
                }
                else
                {
                    SwapState(KnightState.Chasing);
                }
                break;
            //Blocking
            case 4:
                GlareTimer -= Time.deltaTime;

                RotateToPlayer();

                if (GlareTimer < 1f && wishDir.magnitude < 2)
                {
                    SwapState(KnightState.Attacking);
                }

                if (GlareTimer < 0)
                {
                    SwapState(KnightState.Chasing);
                }
                break;
            //Dead
            case -1:
                break;
        }

        // wishDir = player.transform.position - transform.position;

        // if (wishDir.magnitude < 5 && canTurn)
        // {
        //     transform.rotation = Quaternion.RotateTowards(transform.rotation, Quaternion.LookRotation(wishDir), Time.deltaTime * 600);
        // }
        // if (wishDir.magnitude < 2)
        // {
        //     animator.SetTrigger("Attack");
        // }
    }

    public void RotateToPlayer()
    {
        if (wishDir.magnitude > .1f)
        {
            transform.rotation = Quaternion.RotateTowards(transform.rotation, Quaternion.LookRotation(wishDir), Time.deltaTime * 600);
        }
    }

    void OnAnimatorMove()
    {
        Vector3 velocity = animator.deltaPosition;

        controller.Move(velocity);
    }

    IEnumerator KnockBack()
    {
        Vector3 knockAngle = transform.position - player.transform.position;
        knockAngle.Normalize();
        knockAngle.y += 1;

        for (float i = 1; i > 0; i -= Time.deltaTime)
        {
            controller.Move(knockAngle * i * Time.deltaTime * 3);
            yield return null;
        }
    }

    public override void OnEnterAnimState()
    {

    }

    private void SwapState(KnightState newState)
    {
        switch (newState.GetHashCode())
        {
            //Idling
            case 0:
                break;

            //Glaring
            case 1:
                animator.SetBool("Walk", false);
                animator.SetBool("Blocking", false);
                GlareTimer = 3;
                break;

            //Chasing
            case 2:
                animator.SetBool("Walk", true);
                animator.SetBool("Blocking", false);
                break;
            //Attacking
            case 3:
                animator.SetTrigger("Attack");
                AttackCool = 2;
                animator.SetBool("Walk", false);
                break;

            //Blocking
            case 4:
                animator.SetBool("Blocking", true);
                GlareTimer = 3;
                break;
        }
        state = newState;
    }

    public override void OnExitAnimState(string behaviour)
    {
    }
}

public enum KnightState
{
    Idling = 0,
    Glaring = 1,
    Chasing = 2,
    Attacking = 3,
    Blocking = 4,
    Dead = -1
}