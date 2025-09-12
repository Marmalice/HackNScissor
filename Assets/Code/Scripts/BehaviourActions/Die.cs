using UnityEngine;

[CreateAssetMenu(fileName = "Die", menuName = "Behaviour/Die")]
public class Die : BehaviourAction
{
    public override void EndAction(BehaviourCharacter character, ActionContext context)
    {
    }

    public override void StartAction(BehaviourCharacter character, ActionContext context)
    {
        character.animator.SetTrigger("Die");
    }

    public override void UpdateAction(BehaviourCharacter character, ActionContext context)
    {
    }

    public override ActionContext ActionContext()
    {
        return CreateInstance<EmptyContext>();
    }

}
