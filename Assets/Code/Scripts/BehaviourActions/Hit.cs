using UnityEngine;
using UnityEngine.Events;

[CreateAssetMenu(fileName = "Hit", menuName = "Behaviour/Hit")]
public class Hit : BehaviourAction
{
    public override void EndAction(BehaviourCharacter character, ActionContext context)
    {
    }

    public override void StartAction(BehaviourCharacter character, ActionContext context)
    {
        character.animator.SetTrigger("Hit");
    }

    private void HitComplete(BehaviourCharacter character, EmptyContext context)
    {
        //Debug.Log("Hit Complete");
        //character.ChangeAction();
    }

    public override void UpdateAction(BehaviourCharacter character, ActionContext context)
    {
    }

    public override ActionContext ActionContext()
    {
        return new EmptyContext();
    }
}
