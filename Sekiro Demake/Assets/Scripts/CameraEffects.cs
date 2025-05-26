using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode, ImageEffectAllowedInSceneView]
public class CameraEffects : MonoBehaviour
{
    [Range(192, 1920)]
    public int outputWidth = 320;
    [Range(108, 1080)]
    public int outputHeight = 240;

    void OnRenderImage(RenderTexture _source, RenderTexture _destination)
    {
        RenderTextureFormat format = _source.format;
        RenderTexture output = RenderTexture.GetTemporary(outputWidth, outputHeight, 0, format);
        output.filterMode = FilterMode.Point;

        Graphics.Blit(_source, output);
        Graphics.Blit(output, _destination);
        RenderTexture.ReleaseTemporary(output);
    }
}
