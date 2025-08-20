using UnityEngine;

public class GlareUntilTimer : BehaviourAction
{
    public float timer = 3;
    public NewAction nextState;
    private float currentCount = 0;

    public override void EndAction()
    {
    }

    public override void StartAction(ActionContext context)
    {
        currentCount = 0;
    }

    public override void UpdateAction()
    {
        currentCount += Time.deltaTime;
        character.RotateToTarget();

        if (currentCount > timer)
        {
            character.ChangeAction(nextState);
        }
    }
    
    protected override void InitializeAction()
    {
    }
}
