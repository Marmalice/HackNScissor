using UnityEditor;
using UnityEditor.Experimental.GraphView;
using UnityEditor.UIElements;
using UnityEngine;
using UnityEngine.UIElements;

public class BehaviourGraph : EditorWindow
{
    private BehaviourGraphView _graphView;
    public string _fileName = "New Behaviour";

    [MenuItem("Graph/Behaviour Graph")]
    public static void OpenBehaviourWindow()
    {
        var window = GetWindow<BehaviourGraph>();
        window.titleContent = new GUIContent("Behaviour Graph");
    }

    void OnEnable()
    {
        ConstructGraphView();
        GenerateToolbar();
        GenerateMinimap();
        //GenerateBlackboard();
    }

    void OnDisable()
    {
        rootVisualElement.Remove(_graphView);
    }

    private void ConstructGraphView()
    {
        _graphView = new BehaviourGraphView(this)
        {
            name = "Behaviour Graph"
        };

        _graphView.StretchToParentSize();
        rootVisualElement.Add(_graphView);
    }

    private void GenerateBlackboard()
    {
        var blackboard = new Blackboard(_graphView);
        blackboard.Add(new BlackboardSection
        {
            title = "Exposed Properties"
        });
        _graphView.Add(blackboard);
    }

    private void GenerateMinimap()
    {
        var minimap = new MiniMap { anchored = true };
        minimap.SetPosition(new Rect(10, 30, 200, 140));
        _graphView.Add(minimap);
    }

    private void GenerateToolbar()
    {
        var toolbar = new Toolbar();

        var fileNameTextField = new TextField("File Name:");
        fileNameTextField.SetValueWithoutNotify(_fileName);
        fileNameTextField.MarkDirtyRepaint();
        fileNameTextField.RegisterValueChangedCallback(evt => _fileName = evt.newValue);
        toolbar.Add(fileNameTextField);

        toolbar.Add(new Button(() => RequestDataOperation(true))
        {
            text = "Save Data",
        });
        toolbar.Add(new Button(() => RequestDataOperation(false))
        {
            text = "Load Data",
        });

        rootVisualElement.Add(toolbar);
    }

    private void RequestDataOperation(bool save)
    {
        if (string.IsNullOrEmpty(_fileName))
        {
            EditorUtility.DisplayDialog("Invalid filename.", "Enter a valid name.", "OK");
        }

        var SaveUtility = GraphSaveUtils.GetInstance(_graphView);
        if (save)
        {
            SaveUtility.SaveGraph(_fileName);
        }
        else
        {
            SaveUtility.LoadGraph(_fileName);
        }
    }
}
