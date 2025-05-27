Shader "_MyShaders/PS1 Shader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Tint ("Tint", Color) = (1,1,1,1)
        _SplashTex ("SplashTexture", 2D) = "black" {}
        _SplashTint ("SplashTint", Color) = (1,1,1,1)
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
                noperspective float2 uv2 : TEXCOORD1;

                float gouraud : TEXCOORD2;

            };

            sampler2D _MainTex, _SplashTex;
            float4 _MainTex_ST, _SplashTex_ST;
            float4 _Tint, _SplashTint;

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
                o.uv2 = TRANSFORM_TEX(v.uv, _SplashTex);

                o.gouraud = DotClamped(UnityObjectToWorldNormal(v.normal), _WorldSpaceLightPos0);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                fixed4 splash = tex2D(_SplashTex, i.uv2);

                fixed4 output = lerp(col * _Tint, col * _SplashTint, splash);

                return output;
            }
            ENDCG
        }
    }
}
