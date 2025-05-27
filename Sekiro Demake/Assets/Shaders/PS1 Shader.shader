Shader "_MyShaders/PS1 Shader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Tint ("Tint", Color) = (1,1,1,1)
        _VertexSnapping ("Vertex Snapping", Range(1, 100)) = 10
    }
    SubShader
    {

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityPBSLighting.cginc"
            #include "AutoLight.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                noperspective float2 uv : TEXCOORD0;

                float gouraud : TEXCOORD1;

            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Tint;

            float _VertexSnapping;

            float4 ApplyVertexSnapping(float4 _vertex)
            {
                float4 roundedVertex = _vertex;

                roundedVertex.xy = roundedVertex.xy / _vertex.w;
                float2 snappingResolution = _ScreenParams.xy / _VertexSnapping;
                roundedVertex.xy = round(roundedVertex.xy * snappingResolution) / snappingResolution;
                roundedVertex.xy *= _vertex.w;

                return roundedVertex;
            }
            v2f vert (appdata v)
            {
                v2f o;

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.vertex = ApplyVertexSnapping(o.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                o.gouraud = DotClamped(UnityObjectToWorldNormal(v.normal), _WorldSpaceLightPos0);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv) * _Tint;

                return col * i.gouraud;
            }
            ENDCG
        }
    }
}
