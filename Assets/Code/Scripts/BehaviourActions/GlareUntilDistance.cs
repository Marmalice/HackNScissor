using UnityEngine;

public class GlareUntilDistance : BehaviourAction
{
    public NewAction nextState;
    public float distance = 10;

    public override void EndAction()
    {
    }

    public override void StartAction(ActionContext context)
    {

    }

    public override void UpdateAction()
    {
        character.RotateToTarget();

        if (character.wishDir.magnitude < distance)
        {
            character.ChangeAction(nextState);
        }
    }
    
    protected override void InitializeAction()
    {
    }
}
