using System;
using System.Collections.Generic;
using UnityEngine;

[Serializable]
public class GraphData : ScriptableObject
{
    public List<NodeLinkData> NodeLinks = new List<NodeLinkData>();
    public List<BehaviourNodeData> BehaviourNodes = new List<BehaviourNodeData>();
}
