using UnityEngine;
using UnityEditor.Experimental.GraphView;

public class BehaviourNode : Node
{
    public string GUID;
    public BehaviourAction action;
    public BehaviourGraph graph;
    public bool EntryPoint = false;
    public NodeType nodeType = NodeType.Behaviour;
    public string targetGUID;

    public override void OnSelected()
    {
        if (action != null)
        {
            var context = GraphSaveUtils.GetContext(graph._fileName, GUID, action.ActionContext());

            if (context != null)
            {
                UnityEditor.Selection.activeObject = context;
            }
            else
            {
                UnityEditor.Selection.activeObject = null;
            }
        }
        else
        {
            UnityEditor.Selection.activeObject = null;
        }
    }
}

public enum NodeType
{
    Behaviour,
    Exit,
    Entry
}
