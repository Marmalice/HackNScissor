using System;
using UnityEngine;

public abstract class BehaviourAction : ScriptableObject
{
    public abstract void StartAction(BehaviourCharacter character, ActionContext context);
    public abstract void UpdateAction(BehaviourCharacter character, ActionContext context);
    public abstract void EndAction(BehaviourCharacter character, ActionContext context);
    public abstract ActionContext ActionContext();
}

[Serializable]
public abstract class ActionContext : ScriptableObject
{}

public class EmptyContext : ActionContext
{ }

[Serializable]
public struct Action
{
    public BehaviourAction action;
    public ActionContext context;
}