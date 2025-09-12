using System;
using UnityEngine;

[CreateAssetMenu]
public class BehaviourTree : ScriptableObject
{
    public ActionPath action;
    public ActionPath hit;
    public ActionPath die;
}

[Serializable]
public class ActionPath
{
    public Action action;
    public ActionPath[] path;
}
