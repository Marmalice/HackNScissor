using System.Collections.Generic;
using UnityEditor;
using UnityEditor.Experimental.GraphView;
using UnityEditor.PackageManager.UI;
using UnityEngine;
using UnityEngine.UIElements;

public class NodeSearchWindow : ScriptableObject, ISearchWindowProvider
{
    private BehaviourGraphView _graphView;
    private EditorWindow _window;

    public void Init(BehaviourGraphView graphView, EditorWindow window)
    {
        _graphView = graphView;
        _window = window;
    }
    public List<SearchTreeEntry> CreateSearchTree(SearchWindowContext context)
    {
        
        var tree = new List<SearchTreeEntry>
        {
            new SearchTreeGroupEntry(new GUIContent("Create Elements"), 0),
            new SearchTreeGroupEntry(new GUIContent("Behaviour Node"), 1),
            new SearchTreeEntry(new GUIContent("Behaviour Node"))
            {
                userData = new BehaviourNode{
                    nodeType = NodeType.Behaviour,
                }, level = 2,
            },            
        };

        // foreach (GraphElement element in _graphView.graphElements)
        // {
        //     if (element is BehaviourNode node && node.nodeType == NodeType.Entry)
        //     {
        //         tree.Add(new SearchTreeEntry(new GUIContent(node.name))
        //         {
        //             userData = new BehaviourNode
        //             {
        //                 nodeType = NodeType.Exit,
        //                 targetGUID = node.GUID,
        //                 title = node.name,
        //             },
        //             level = 2,
        //         });

        //     }
        // }

        return tree;
    }

    public bool OnSelectEntry(SearchTreeEntry SearchTreeEntry, SearchWindowContext context)
    {
        var worldMousePosition = _window.rootVisualElement.ChangeCoordinatesTo(_window.rootVisualElement.parent, context.screenMousePosition - _window.position.position);
        var localMousePosition = _graphView.contentViewContainer.WorldToLocal(worldMousePosition);
        switch (SearchTreeEntry.userData)
        {
            case BehaviourNode:
                _graphView.CreateNode("Behaviour", localMousePosition);
                return true;
            // case NodeType.Exit:
            //     _graphView.CreateExitNode((BehaviourNode)SearchTreeEntry.userData, localMousePosition);
            //     return false;

            // case NodeType.Entry:
            //     return false;
            default:
                return false;
        }
    }
}
