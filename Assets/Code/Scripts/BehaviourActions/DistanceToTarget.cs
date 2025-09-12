using UnityEngine;
using System;

[CreateAssetMenu(fileName = "DistanceToTarget", menuName = "Behaviour/DistanceToTarget")]
public class DistanceToTarget : BehaviourAction
{
    public override void EndAction(BehaviourCharacter character, ActionContext context)
    {
    }

    public override void StartAction(BehaviourCharacter character, ActionContext context)
    {
    }

    public override void UpdateAction(BehaviourCharacter character, ActionContext context)
    {
        if (context is DTTVars vars)
        {
            switch (vars.comparison)
            {
                case Comparison.GreaterThan:
                    if (character.wishDir.magnitude > vars.distance)
                    {
                        //character.ChangeAction();
                    }
                    break;
                case Comparison.LessThan:
                    if (character.wishDir.magnitude < vars.distance)
                    {
                        //character.ChangeAction();
                    }
                    break;
            }
            
        }
    }


    public override ActionContext ActionContext()
    {
        return CreateInstance<DTTVars>();
    }
}

[Serializable]
public class DTTVars : ActionContext
{
    public DTTVars(float val)
    {
        distance = val;
        comparison = Comparison.LessThan;
    }

    public Comparison comparison;
    public float distance;
}

[Serializable]
public enum Comparison
{
    GreaterThan,
    LessThan
}
