using UnityEngine;

[CreateAssetMenu(fileName = "Chase", menuName = "Behaviour/Chase")]
public class Chase : BehaviourAction
{
    public override void EndAction(BehaviourCharacter character, ActionContext context)
    {
        character.animator.SetBool("Walk", false);
    }

    public override void StartAction(BehaviourCharacter character, ActionContext context)
    {
        character.animator.SetBool("Walk", true);
    }

    public override void UpdateAction(BehaviourCharacter character, ActionContext context)
    {
        character.RotateToTarget();
    }
    
    public override ActionContext ActionContext()
    {
        return CreateInstance<EmptyContext>();
    }
}
