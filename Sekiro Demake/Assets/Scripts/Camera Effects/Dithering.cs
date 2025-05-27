using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode, ImageEffectAllowedInSceneView]
public class Dithering : MonoBehaviour
{
    public Shader ditherShader;
    private Material ditherMat;
    void OnDisable()
    {
        if (ditherMat != null)
        {
            DestroyImmediate(ditherMat);
            ditherMat = null;
        }
    }
    void OnRenderImage(RenderTexture _source, RenderTexture _destination)
    {
        if (ditherMat == null)
        {
            ditherMat = new Material(ditherShader);
            ditherMat.hideFlags = HideFlags.HideAndDontSave;
        }

        Graphics.Blit(_source, _destination, ditherMat);
    }
}
