using UnityEngine;

public class DashAway : BehaviourAction
{
    public override void StartAction(ActionContext context)
    {
        character.UpdateDirection();
        character.animator.SetTrigger("Dash");
    }

    public override void UpdateAction()
    {
    }

    public override void EndAction()
    {
    }

    protected override void InitializeAction()
    {
    }
}
