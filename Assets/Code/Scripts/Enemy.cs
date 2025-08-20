using System.Collections;
using UnityEngine;

public class Enemy : Character
{
    private int HP = 3;
    private float AttackCool = 0f;
    public EnemyState state;

    [SerializeField] private float aggroRadius = 7;

    void Awake()
    {
        controller = GetComponent<CharacterController>();
        animator = GetComponent<Animator>();
    }

    void Start()
    {
        state = EnemyState.Idling;
        SetupCharacter();
    }

    public override void RegisterHit()
    {
        HP--;

        if (HP > 0)
            animator.SetTrigger("Hit");
        else
        {
            state = EnemyState.Dead;
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
                if (wishDir.magnitude < 15)
                {
                    state = EnemyState.Glaring;
                }
                break;
            //Glaring
            case 1:
                if (wishDir.magnitude > .1f)
                    transform.rotation = Quaternion.RotateTowards(transform.rotation, Quaternion.LookRotation(wishDir), Time.deltaTime * 600);

                if (wishDir.magnitude < aggroRadius)
                {
                    animator.SetBool("Walk", true);
                    state = EnemyState.Chasing;
                }
                break;
            //Chasing
            case 2:
                if (wishDir.magnitude > .1f)
                    transform.rotation = Quaternion.RotateTowards(transform.rotation, Quaternion.LookRotation(wishDir), Time.deltaTime * 600);

                if (wishDir.magnitude < 3)
                {
                    animator.SetTrigger("Attack");
                    AttackCool = 2;
                    animator.SetBool("Walk", false);
                    state = EnemyState.Attacking;
                }

                if (wishDir.magnitude > 10)
                {
                    animator.SetBool("Walk", false);
                    state = EnemyState.Glaring;
                }
                break;
            //Attacking
            case 3:
                if (AttackCool > 0)
                {
                    AttackCool -= Time.deltaTime;
                    return;
                }

                if (wishDir.magnitude > aggroRadius)
                {
                    state = EnemyState.Glaring;
                }
                else
                {
                    animator.SetBool("Walk", true);
                    state = EnemyState.Chasing;
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

    public override void OnExitAnimState(string behaviour)
    {
    }
}

public enum EnemyState
{
    Idling = 0,
    Glaring = 1,
    Chasing = 2,
    Attacking = 3,
    Dead = -1
}