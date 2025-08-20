using UnityEngine;

public class SelectRandomAction : BehaviourAction
{
    public NewAction[] picks;

    public override void EndAction()
    {
    }

    public override void StartAction(ActionContext context)
    {
        character.ChangeAction(picks[Random.Range(0, picks.Length)]);
    }

    public override void UpdateAction()
    {
    }

    protected override void InitializeAction()
    {
    }
}
