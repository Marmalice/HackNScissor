using UnityEngine;

public class ChaseUntilDistance : BehaviourAction
{
    public float distance = 3;
    public NewAction nextAction;

    public override void EndAction()
    {
        character.animator.SetBool("Walk", false);
    }

    public override void StartAction(ActionContext context)
    {
        character.animator.SetBool("Walk", true);
    }

    public override void UpdateAction()
    {
        character.RotateToTarget();

        if (character.wishDir.magnitude < distance)
        {
            character.ChangeAction(nextAction);
        }
    }

    protected override void InitializeAction()
    {
    }
}
