using System;
using UnityEngine;

public class PickOnDistance : BehaviourAction
{
    public DistanceAction[] actions;
    public NewAction fallbackAction;
    public override void EndAction()
    {
    }

    public override void StartAction(ActionContext context)
    {
        foreach (DistanceAction action in actions)
        {
            if (action.CheckCon(character.wishDir.magnitude))
            {
                character.ChangeAction(action.action);
                return;
            }
        }
        character.ChangeAction(fallbackAction);
    }

    public override void UpdateAction()
    {
    }

    protected override void InitializeAction()
    {
    }
}

[Serializable]
public enum condition
{
    LessThan,
    GreaterThan
}

[Serializable]
public struct DistanceAction
{
    public condition condition;
    public float distance;
    public NewAction action;

    public bool CheckCon(float inputDist)
    {
        switch (condition.GetHashCode())
        {
            default:
                if (inputDist <= distance)
                    return true;
                else
                    return false;
            case 1:
                if (inputDist > distance)
                    return true;
                else
                    return false;
        }
    }
}