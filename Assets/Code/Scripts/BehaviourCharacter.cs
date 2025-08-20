using UnityEngine;
using UnityEngine.Events;

public class BehaviourCharacter : Character
{
    public BehaviourAction currentAction { get; protected set; }
    private BehaviourAction[] actions = new BehaviourAction[0];
    private NewAction hitAction;
    private NewAction dieAction;
    int tempHP = 3;

    [HideInInspector] public UnityEvent AttackEnd;
    [HideInInspector] public UnityEvent HitEnd;
    [HideInInspector] public UnityEvent AnimEnd;
    [SerializeField] private BehaviourAction startAction;
    [SerializeField] private ActionContext startContext;
    

    void Awake()
    {
        actions = GetComponents<BehaviourAction>();
        foreach (BehaviourAction action in actions)
        {
            action.SetupAction(this);
        }

        MakeInteractable();

        currentAction = startAction;
        currentAction.StartAction(startContext);
    }

    void MakeInteractable()
    {
        Hit hit = GetComponent<Hit>();

        if (hit != null)
            hitAction = new NewAction(hit);

        Die die = GetComponent<Die>();

        if (die != null)
            dieAction = new NewAction(die);
    }

    void Start()
    {
        SetupCharacter();
    }

    void Update()
    {
        controller.Move(Vector3.down * Time.deltaTime * 9.81f);

        wishDir = player.transform.position - transform.position;

        currentAction.UpdateAction();
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

    public void ChangeAction(NewAction nextAction)
    {
        //Debug.Log("Changing Action from " + currentAction.GetType());
        currentAction.EndAction();
        currentAction = nextAction.action;
        currentAction.StartAction(nextAction.context);
        //Debug.Log("Changed Action to " + nextAction.action.GetType());
    }

    public override void RegisterHit()
    {
        tempHP--;

        if (tempHP > 0)
        {
            ChangeAction(hitAction);
        }
        else
        {
            ChangeAction(dieAction);
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

