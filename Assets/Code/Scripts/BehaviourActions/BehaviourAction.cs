using System;
using UnityEngine;

public abstract class BehaviourAction : MonoBehaviour
{
    [HideInInspector] public BehaviourCharacter character;

    public abstract void StartAction(ActionContext context);
    public abstract void UpdateAction();
    public abstract void EndAction();
    
    protected abstract void InitializeAction();

    public void SetupAction(BehaviourCharacter owner)
    {
        character = owner;
        InitializeAction();
    }
}

[Serializable]
public struct ActionContext
{
    public ActionContext(int val = 0)
    {
        value = val;
        text = "";
    }
    public int value;
    public string text;
}

[Serializable]
public struct NewAction
{
    public NewAction(BehaviourAction newAction)
    {
        action = newAction;

        context = new ActionContext();
    }

    public BehaviourAction action;
    public ActionContext context;
}