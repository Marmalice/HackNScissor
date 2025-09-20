using System;
using UnityEngine;

[Serializable]
public class AttackVars : ActionContext
{
    [HideInInspector] public bool interrupted;
    public int attackIndex;
}