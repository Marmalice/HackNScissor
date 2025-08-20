using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

public class UpdateReflectionCam : MonoBehaviour
{
    public Transform mirrorPlane;
    public float renderResolution = 1;

    Camera mainCamera;

    private void OnEnable()
    {
        RenderTexture renderTexture =
        GetComponent<Camera>().targetTexture;
        mainCamera = Camera.main;
        renderTexture.Release();
        renderTexture.width = (int)(Screen.width * renderResolution);
        renderTexture.height = (int)(Screen.height * renderResolution);
    }

    void Update()
    {
        Vector3 camF = mainCamera.transform.forward;
        Vector3 camU = mainCamera.transform.up;
        Vector3 camP = mainCamera.transform.position - new Vector3(0, mirrorPlane.position.y,0);

        camF = mirrorPlane.transform.InverseTransformDirection(camF);
        camU = mirrorPlane.transform.InverseTransformDirection(camU);
        camP = mirrorPlane.transform.InverseTransformDirection(camP);

        camF.y *= -1f;
        camU.y *= -1f;
        camP.y *= -1f;

        camF = mirrorPlane.transform.TransformDirection(camF);
        camU = mirrorPlane.transform.TransformDirection(camU);
        camP = mirrorPlane.transform.TransformDirection(camP);

        transform.position = camP;
        transform.position += new Vector3(0,mirrorPlane.transform.position.y,0);
        transform.rotation = Quaternion.LookRotation(camF,camU);
    }
}
