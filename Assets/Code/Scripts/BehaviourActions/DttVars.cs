using System;

[Serializable]
public class DttVars : ActionContext
{
    public DttVars(float val)
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