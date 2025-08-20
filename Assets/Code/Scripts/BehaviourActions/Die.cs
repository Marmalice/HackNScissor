using UnityEngine;

public class Die : BehaviourAction
{
    public override void EndAction()
    {
    }

    public override void StartAction(ActionContext context)
    {
        character.animator.SetTrigger("Die");
    }

    public override void UpdateAction()
    {
    }

    protected override void InitializeAction()
    {
    }
}
