using UnityEngine;
using UnityEngine.Events;

public class Attack : BehaviourAction
{
    public NewAction nextAction;
    private bool interrupted = false;

    protected override void InitializeAction()
    {
        character.AttackEnd.AddListener(AttackComplete);
    }

    public override void EndAction()
    {
        interrupted = true;
    }

    public override void StartAction(ActionContext context)
    {
        interrupted = false;

        if (context.value != 0)
            character.animator.SetInteger("AttackChoice", context.value);

        character.animator.SetTrigger("Attack");
    }

    private void AttackComplete()
    {
        if (!interrupted)
        {
            //Debug.Log("Atk Complete");
            character.ChangeAction(nextAction);
        }
    }
    public override void UpdateAction()
    {
        if (character.canTurn)
        {
            character.RotateToTarget();
        }
    }
}
