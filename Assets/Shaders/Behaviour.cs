using UnityEngine;

public class GirarModelo : MonoBehaviour
{
    public float velocidad = 45f;       
    public Vector3 eje = Vector3.up;

    Vector3 centroLocal;

    void Start()
    {
        Renderer[] renderers = GetComponentsInChildren<Renderer>();
        if (renderers.Length == 0) return;

        Bounds b = renderers[0].bounds;
        for (int i = 1; i < renderers.Length; i++)
            b.Encapsulate(renderers[i].bounds);

        centroLocal = transform.InverseTransformPoint(b.center);
    }

    void Update()
    {
        Vector3 centroMundo = transform.TransformPoint(centroLocal);
        transform.RotateAround(centroMundo, eje, velocidad * Time.deltaTime);
    }
}