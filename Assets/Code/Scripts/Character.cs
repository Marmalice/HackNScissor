using System.Collections;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.InputSystem.Composites;

public abstract class Character : MonoBehaviour
{
    public abstract void RegisterHit();
    public abstract void OnEnterAnimState();
    public abstract void OnExitAnimState(string behaviour);

    protected CharacterController controller;
    public GameObject player { get; protected set; }
    public Vector3 wishDir { get; protected set; } = Vector2.zero ;
    public Animator animator { get; protected set; }
    protected bool invulnerable = false;
    protected bool canCancel = true;
    public UnityEvent OnHitTaken;
    [HideInInspector] public UnityEvent SetupComplete;
    [SerializeField] public Faction faction;


    public MeleeWeapon[] weapon;

    [HideInInspector] public bool canTurn = true;

    public void SetupCharacter()
    {
        player = AggroManager.aggroManager.RegisterCharacter(this);
        controller = GetComponent<CharacterController>();
        animator = GetComponent<Animator>();
        foreach (MeleeWeapon currentweapon in weapon)
        {
            currentweapon.SetupWeapon(this);
        }
        SetupComplete.Invoke();
    }

    public void OverridePlayer(GameObject newPlayer)
    {
        player = newPlayer;
    }

    public void ReceiveHit()
    {
        OnHitTaken.Invoke();
        RegisterHit();
    }

    protected void Die()
    {
        AggroManager.aggroManager.MakeUntargetable(this);
    }

    public void UpdateDirection()
    {
        //transform.LookAt(wishDir + transform.position);
        StartCoroutine(QuickTurn());
    }

    IEnumerator QuickTurn()
    {
        Quaternion oldRot = transform.rotation;
        //Quaternion newRot = Quaternion.LookRotation(wishDir);
        for (float i = 0; i < 1; i += Time.deltaTime * 5)
        {
            if (wishDir.magnitude > .1f)
                transform.rotation = Quaternion.Lerp(oldRot, Quaternion.LookRotation(wishDir), i);
            yield return null;
        }
    }

    protected IEnumerator HitStop(float stopTime = .1f)
    {
        animator.speed = 0;
        yield return new WaitForSeconds(stopTime);
        animator.speed = 1;
    }

    public void LandHit()
    {
        StartCoroutine(HitStop());
    }

    public void StartAttack(int choice)
    {
        weapon[choice].StartAttack();
    }

    public void StopAttack(int choice)
    {
        weapon[choice].StopAttack();
    }

    public void StopAllAttacks()
    {
        foreach (MeleeWeapon currentweapon in weapon)
        {
            currentweapon.StopAttack();
        }
    }

    public void StartIFrames()
    {
        invulnerable = true;
    }

    public void StopIFrames()
    {
        invulnerable = false;
    }

    public void CanCancelState(int val)
    {
        canCancel = val != 0;
        animator.SetBool("CanCancel", canCancel);
    }

    

    public void StateSwap()
    {
        StopIFrames();
        StopAllAttacks();
        OnEnterAnimState();
    }
}

public enum Faction
{
    Enemy = 0,
    Ally = 1,
    Player = 2
}