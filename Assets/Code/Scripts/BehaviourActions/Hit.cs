using UnityEngine;
using UnityEngine.Events;

public class Hit : BehaviourAction
{
    [SerializeField] private NewAction action;

    public override void EndAction()
    {
    }

    public override void StartAction(ActionContext context)
    {
        character.animator.SetTrigger("Hit");
    }

    private void HitComplete()
    {
        //Debug.Log("Hit Complete");
        character.ChangeAction(action);
    }

    public override void UpdateAction()
    {
    }

    protected override void InitializeAction()
    {
        character.HitEnd.AddListener(HitComplete);
    }
}
