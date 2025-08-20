using UnityEngine;

public class FleeUntilDistance : BehaviourAction
{
    public float distance = 5;
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
        character.RotateToTarget(-1);

        if (character.wishDir.magnitude > distance)
        {
            character.ChangeAction(nextAction);
        }
    }

    protected override void InitializeAction()
    {
    }
}
