using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode, ImageEffectAllowedInSceneView]
public class Quantization : MonoBehaviour
{
    public Shader quantizationShader;

    [Range(2, 64)]
    public int redColorCount = 2;
    [Range(2, 64)]
    public int greenColorCount = 2;
    [Range(2, 64)]
    public int blueColorCount = 2;

    private Material quantizationMat;

    void OnDisable()
    {
        if (quantizationMat != null)
        {
            DestroyImmediate(quantizationMat);
            quantizationMat = null;
        }
    }
    void OnRenderImage(RenderTexture _source, RenderTexture _destination)
    {
        if(quantizationMat == null)
        {
            quantizationMat = new Material(quantizationShader);
            quantizationMat.hideFlags = HideFlags.HideAndDontSave;
        }

        quantizationMat.SetInt("_RedColorCount", redColorCount);
        quantizationMat.SetInt("_GreenColorCount", greenColorCount);
        quantizationMat.SetInt("_BlueColorCount", blueColorCount);

        Graphics.Blit(_source, _destination, quantizationMat);
    }
}
