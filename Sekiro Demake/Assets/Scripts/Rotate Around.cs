using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RotateAround : MonoBehaviour
{
    public Transform pivot = null;
    [Range(0.001f, 100.0f)]
    public float rotationSpeed = 10;

    private void OnEnable()
    {
        if (pivot == null) 
            pivot = transform;
    }

    private void FixedUpdate()
    {
        float angle = Time.deltaTime * rotationSpeed;

        if (pivot != null)
        {
            transform.RotateAround(pivot.position, Vector3.right, angle);
            transform.RotateAround(pivot.position, Vector3.up, angle * 2);
            transform.RotateAround(pivot.position, Vector3.forward, -angle * 3);
        }
    }

}
