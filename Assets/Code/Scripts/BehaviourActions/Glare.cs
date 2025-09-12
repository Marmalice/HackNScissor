using UnityEngine;

[CreateAssetMenu(fileName = "Glare", menuName = "Behaviour/Glare")]

public class Glare : BehaviourAction
{


    public override void EndAction(BehaviourCharacter character, ActionContext context)
    {
    }

    public override void StartAction(BehaviourCharacter character, ActionContext context)
    {
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
