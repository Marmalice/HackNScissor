using System;
using System.Collections.Generic;
using System.Linq;
using Mono.Cecil;
using UnityEditor;
using UnityEditor.Experimental.GraphView;
using UnityEngine;
using UnityEngine.UIElements;

public class BehaviourGraphView : GraphView
{
    public readonly Vector2 defaultSize = new Vector2(150, 200);

    private NodeSearchWindow _searchWindow;
    private BehaviourGraph editor;

    public readonly string[] startNodes = {
        "Start",
        "Hit",
        "Die"
    };
    public BehaviourGraphView(EditorWindow editorWindow)
    {
        styleSheets.Add(Resources.Load<StyleSheet>("GraphStyle"));
        SetupZoom(ContentZoomer.DefaultMinScale, ContentZoomer.DefaultMaxScale);

        graphViewChanged = OnGraphViewChange;

        this.AddManipulator(new ContentDragger());
        this.AddManipulator(new SelectionDragger());
        this.AddManipulator(new RectangleSelector());


        var grid = new GridBackground();
        Insert(0, grid);
        grid.StretchToParentSize();

        GenerateStartNodes();
        AddSearchWindow(editorWindow);
    }

    private void AddSearchWindow(EditorWindow editorWindow)
    {
        editor = (BehaviourGraph)editorWindow;
        _searchWindow = ScriptableObject.CreateInstance<NodeSearchWindow>();
        _searchWindow.Init(this, editorWindow);
        nodeCreationRequest = context => SearchWindow.Open(new SearchWindowContext(context.screenMousePosition), _searchWindow);
    }

    private Port GeneratePort(BehaviourNode node, Direction portDirection, Port.Capacity capacity = Port.Capacity.Single)
    {
        return node.InstantiatePort(Orientation.Horizontal, portDirection, capacity, typeof(float));
    }

    public override List<Port> GetCompatiblePorts(Port startPort, NodeAdapter nodeAdapter)
    {
        var compatiblePorts = new List<Port>();

        ports.ForEach((port =>
        {
            if (startPort != port && startPort.node != port.node)
                compatiblePorts.Add(port);
        }));

        return compatiblePorts;
    }

    private void GenerateStartNodes()
    {
        AddElement(GenerateEntryPointNode(startNodes[0], 0, true));
        for (int i = 1; i < startNodes.Count(); i++)
        {
            //AddElement(GenerateEntryPointNode(startNodes[i], i * 100));
        }
    }

    private BehaviourNode GenerateEntryPointNode(string title, int offset, bool entry = false)
    {
        var node = new BehaviourNode
        {
            title = title,
            GUID = Guid.NewGuid().ToString(),
            EntryPoint = entry,
        };

        var generatedPort = GeneratePort(node, Direction.Output);

        generatedPort.portName = "Next";
        node.outputContainer.Add(generatedPort);

        node.capabilities &= ~Capabilities.Deletable;

        node.RefreshExpandedState();
        node.RefreshPorts();

        node.SetPosition(new Rect(100, offset, 100, 150));

        return node;
    }

    public void CreateNode(string nodeName, Vector2 position)
    {
        AddElement(CreateBehaviourNode(nodeName, position));
    }

    public void CreateEntryNode(BehaviourNode node, Vector2 position)
    {
        var behaviourNode = new BehaviourNode
        {
            title = node.title,
            GUID = Guid.NewGuid().ToString(),
            graph = editor
        };

        var outputPort = GeneratePort(behaviourNode, Direction.Output, Port.Capacity.Single);
        outputPort.name = "Entry";
        behaviourNode.outputContainer.Add(outputPort);

        behaviourNode.RefreshExpandedState();
        behaviourNode.RefreshPorts();
        behaviourNode.SetPosition(new Rect(position, defaultSize));

        AddElement(behaviourNode);
    }

    public void CreateExitNode(BehaviourNode node, Vector2 position)
    {
        var behaviourNode = new BehaviourNode
        {
            title = node.title,
            targetGUID = node.targetGUID,
            GUID = Guid.NewGuid().ToString(),
            graph = editor
        };

        var inputPort = GeneratePort(behaviourNode, Direction.Input, Port.Capacity.Multi);
        inputPort.portName = "Exit";
        behaviourNode.inputContainer.Add(inputPort);

        behaviourNode.RefreshExpandedState();
        behaviourNode.RefreshPorts();
        behaviourNode.SetPosition(new Rect(position, defaultSize));
        
        AddElement(behaviourNode);
    }

    public BehaviourNode CreateBehaviourNode(string nodeName, Vector2 position, BehaviourAction action = null)
    {
        var behaviourNode = new BehaviourNode
        {
            title = nodeName,
            GUID = Guid.NewGuid().ToString(),
            graph = editor
        };

        var inputPort = GeneratePort(behaviourNode, Direction.Input, Port.Capacity.Multi);
        inputPort.portName = "Input";
        behaviourNode.inputContainer.Add(inputPort);

        behaviourNode.styleSheets.Add(Resources.Load<StyleSheet>("NodeStyle"));

        var button = new Button(() => AddStatePort(behaviourNode));
        button.text = "Add State";
        behaviourNode.titleContainer.Add(button);

        var stateField = new UnityEditor.UIElements.ObjectField("Action");


        stateField.objectType = typeof(BehaviourAction);
        stateField.allowSceneObjects = false;

        if (action != null)
        {
            stateField.value = action;
        }

        stateField.RegisterValueChangedCallback(evt =>
        {
            if (evt.newValue is BehaviourAction action)
            {
                behaviourNode.action = action;
                behaviourNode.title = action.name;
                behaviourNode.OnSelected();
            }

        });

        behaviourNode.mainContainer.Add(stateField);
        //behaviourNode.mainContainer.Add(contextField);

        behaviourNode.RefreshExpandedState();
        behaviourNode.RefreshPorts();
        behaviourNode.SetPosition(new Rect(position, defaultSize));

        return behaviourNode;
    }

    public void AddStatePort(BehaviourNode behaviourNode, string overriddenPortName = "")
    {
        var generatedPort = GeneratePort(behaviourNode, Direction.Output);

        var outputPortCount = behaviourNode.outputContainer.Query("connector").ToList().Count;
        var statePortName = string.IsNullOrEmpty(overriddenPortName)
        ? $"State {outputPortCount}"
        : overriddenPortName;

        var deleteButton = new Button(() => RemovePort(behaviourNode, generatedPort))
        {
            text = "X"
        };

        generatedPort.contentContainer.Add(deleteButton);
        generatedPort.portName = statePortName;
        behaviourNode.outputContainer.Add(generatedPort);
        behaviourNode.RefreshExpandedState();
        behaviourNode.RefreshPorts();
    }

    private void RemovePort(BehaviourNode behaviourNode, Port generatedPort)
    {
        var targetEdge = edges.ToList().Where(x => x.output.portName == generatedPort.portName && x.output.node == generatedPort.node);

        if (targetEdge.Any())
        {
            var edge = targetEdge.First();
            edge.input.Disconnect(edge);
            RemoveElement(targetEdge.First());
        }

        behaviourNode.outputContainer.Remove(generatedPort);
        behaviourNode.RefreshPorts();
        behaviourNode.RefreshExpandedState();
    }

    private GraphViewChange OnGraphViewChange(GraphViewChange change)
    {
        if (change.elementsToRemove != null)
        {
            foreach (GraphElement element in change.elementsToRemove)
            {
                if (element is BehaviourNode node)
                {
                    GraphSaveUtils.DeleteContext(editor._fileName, node.GUID);
                }
            }
        }
        return change;
    }
}
