using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class BehaviourCharacter : Character
{
    public BehaviourAction currentAction { get; protected set; }
    private BehaviourAction[] actions = new BehaviourAction[0];
    [SerializeField] private bool debugStates = false;
    int tempHP = 3;

    [HideInInspector] public UnityEvent AttackEnd;
    [HideInInspector] public UnityEvent HitEnd;
    [HideInInspector] public UnityEvent AnimEnd;

    [SerializeField] private GraphData behaviourTree;
    [HideInInspector] public ActionContext[] actionContexts;
    private List<Action> actionStack = new List<Action>();

    

    void Awake()
    {
        foreach (BehaviourAction action in actions)
        {
            //action.SetupAction(this);
        }
        
        MakeInteractable();

        //currentAction = startAction;
        //currentAction.StartAction(startContext);
    }

    void MakeInteractable()
    {
        
    }

    void Start()
    {
        SetupCharacter();
    }

    void Update()
    {
        controller.Move(Vector3.down * (Time.deltaTime * 9.81f));

        if (faction == Faction.Enemy)
        {
            wishDir = player.transform.position - transform.position;
        }
        else
        {
            GetClosestTarget();
        }

        //currentAction.UpdateAction();
    }

    void GetClosestTarget()
    {
        //TURN THIS INTO AN ACTUAL FUNCTION
        wishDir = AggroManager.aggroManager.targetables[0].transform.position - transform.position;
    }

    void OnAnimatorMove()
    {
        Vector3 velocity = animator.deltaPosition;

        controller.Move(velocity);
    }

    public void RotateToTarget(int direction = 1)
    {
        if (wishDir.magnitude > .1f)
        {
            transform.rotation = Quaternion.RotateTowards(transform.rotation, Quaternion.LookRotation(wishDir * direction), Time.deltaTime * 600);
        }
    }

    public void ChangeAction(Action nextAction)
    {
        if(debugStates)
        Debug.Log("Changing Action from " + currentAction.GetType());
        
        //currentAction.EndAction();
        //currentAction = nextAction.action;
        //currentAction.StartAction(nextAction.context);
        
        if(debugStates)
        Debug.Log("Changed Action to " + nextAction.action.GetType());
    }

    public override void RegisterHit()
    {
        tempHP--;

        if (tempHP > 0)
        {
            //ChangeAction(hitAction);
        }
        else
        {
            //ChangeAction(dieAction);
            Die();
        }
    }

    public override void OnEnterAnimState()
    {
    }

    public override void OnExitAnimState(string behaviour)
    {
        switch (behaviour)
        {
            case "Attack":
                AttackEnd.Invoke();
                break;
            case "Hit":
                HitEnd.Invoke();
                break;
            default:
                AnimEnd.Invoke();
                break;
        }
    }
}

