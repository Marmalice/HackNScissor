using System.Collections.Generic;
using System.Linq;
using UnityEditor;
using UnityEditor.Experimental.GraphView;
using UnityEngine;
using UnityEngine.UIElements;

public class GraphSaveUtils
{
    private BehaviourGraphView _targetGraphView;
    private GraphData _containerCache;

    private List<Edge> Edges => _targetGraphView.edges.ToList();
    private List<BehaviourNode> Nodes => _targetGraphView.nodes.ToList().Cast<BehaviourNode>().ToList();

    public static GraphSaveUtils GetInstance(BehaviourGraphView targetGraphView)
    {
        return new GraphSaveUtils
        {
            _targetGraphView = targetGraphView
        };
    }

    public static ScriptableObject GetContext(string graphName, string GUID, ActionContext context)
    {
        if (context is EmptyContext)
        {
            return null;
        }
        if (graphName == "New Behaviour")
            {
                EditorUtility.DisplayDialog("Graph name undefined.", "Please set the name of the graph before accessing its parameters.", "My apolocheese");
                return null;
            }

        if (!AssetDatabase.IsValidFolder($"Assets/Resources/{graphName}Values"))
            {
                AssetDatabase.CreateFolder("Assets/Resources", $"{graphName}Values");
            }

        if (!AssetDatabase.AssetPathExists($"Assets/Resources/{graphName}Values/{GUID}.asset"))
        {
            AssetDatabase.CreateAsset(context, $"Assets/Resources/{graphName}Values/{GUID}.asset");
            AssetDatabase.SaveAssets();
        }

        return Resources.Load<ActionContext>($"{graphName}Values/{GUID}");
    }

    public static void DeleteContext(string graphName, string GUID)
    {
        AssetDatabase.DeleteAsset($"Assets/Resources/{graphName}Values/{GUID}.asset");
    }

    public void SaveGraph(string filename)
    {
        if (!Edges.Any()) return;

        var behaviourContainer = ScriptableObject.CreateInstance<GraphData>();

        var connectedPorts = Edges.Where(x => x.input.node != null).ToArray();
        for (int i = 0; i < connectedPorts.Length; i++)
        {
            var outputNode = connectedPorts[i].output.node as BehaviourNode;
            var inputNode = connectedPorts[i].input.node as BehaviourNode;

            behaviourContainer.NodeLinks.Add(new NodeLinkData
            {
                BaseNodeGUID = outputNode.GUID,
                PortName = connectedPorts[i].output.portName,
                TargetNodeGUID = inputNode.GUID
            });
        }

        foreach (var behaviourNode in Nodes.Where(node => !node.EntryPoint))
        {
            behaviourContainer.BehaviourNodes.Add(new BehaviourNodeData
            {
                NodeGUID = behaviourNode.GUID,
                position = behaviourNode.GetPosition().position,
                action = behaviourNode.action,
            });
        }

        if (!AssetDatabase.IsValidFolder("Assets/Resources"))
        {
            AssetDatabase.CreateFolder("Assets", "Resources");
        }

        AssetDatabase.CreateAsset(behaviourContainer, $"Assets/Resources/{filename}.asset");
        AssetDatabase.SaveAssets();
    }

    public void LoadGraph(string filename)
    {
        _containerCache = Resources.Load<GraphData>(filename);

        if (_containerCache == null)
        {
            EditorUtility.DisplayDialog("File Not Found", "Target behaviour graph doesn't exist.", "My apolocheese");
            return;
        }

        ClearGraph();
        CreateNodes();
        ConnectNodes();
    }

    private void ClearGraph()
    {
        Nodes.Find(x => x.EntryPoint).GUID = _containerCache.NodeLinks[0].BaseNodeGUID;

        foreach (var node in Nodes)
        {
            if (node.EntryPoint) continue;
            Edges.Where(x => x.input.node == node).ToList().ForEach(edge => _targetGraphView.RemoveElement(edge));

            _targetGraphView.RemoveElement(node);
        }
    }

    private void CreateNodes()
    {
        foreach (var nodeData in _containerCache.BehaviourNodes)
        {
            string name = nodeData.action == null ? "Behaviour Node" : nodeData.action.ToString();
            var tempNode = _targetGraphView.CreateBehaviourNode(name, Vector2.zero, nodeData.action);
            tempNode.GUID = nodeData.NodeGUID;
            tempNode.action = nodeData.action;
            _targetGraphView.AddElement(tempNode);

            var nodePorts = _containerCache.NodeLinks.Where(x => x.BaseNodeGUID == nodeData.NodeGUID).ToList();
            nodePorts.ForEach(x => _targetGraphView.AddStatePort(tempNode, x.PortName));
        }
    }

    private void ConnectNodes()
    {
        for (int i = 0; i < Nodes.Count; i++)
        {
            var connections = _containerCache.NodeLinks.Where(x => x.BaseNodeGUID == Nodes[i].GUID).ToList();
            for (int j = 0; j < connections.Count; j++)
            {
                var targetNodeGUID = connections[j].TargetNodeGUID;
                var targetNode = Nodes.First(x => x.GUID == targetNodeGUID);
                LinkNodes(Nodes[i].outputContainer[j].Q<Port>(), (Port)targetNode.inputContainer[0]);

                targetNode.SetPosition(new Rect(
                    _containerCache.BehaviourNodes.First(x => x.NodeGUID == targetNodeGUID).position,
                    _targetGraphView.defaultSize
                ));
            }
        }
    }

    private void LinkNodes(Port output, Port input)
    {
        var tempEdge = new Edge
        {
            output = output,
            input = input
        };

        tempEdge.input.Connect(tempEdge);
        tempEdge.output.Connect(tempEdge);
        _targetGraphView.Add(tempEdge);
    }
}
