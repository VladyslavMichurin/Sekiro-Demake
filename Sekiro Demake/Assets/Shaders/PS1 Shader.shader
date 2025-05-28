Shader "_MyShaders/PS1 Shader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Tint ("Tint", Color) = (1,1,1,1)
        _SplashTex ("SplashTexture", 2D) = "black" {}
        _SplashTint ("SplashTint", Color) = (1,1,1,1)

        _Ambient ("Ambient Light", Color) = (0.3, 0.35, 0.5, 1)

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

            float4 _Ambient;

            float _VertexSnapping;

            float4 VertexSnappingViewSpace(float4 _vertex)
            {
                float4 viewPos = mul(UNITY_MATRIX_MV, _vertex);

                float2 snappingResolution = _ScreenParams.xy / _VertexSnapping;
                viewPos.xyz = round(viewPos.xyz * _VertexSnapping) / _VertexSnapping;
                float4 clipPos = mul(UNITY_MATRIX_P, viewPos);

                return clipPos;
            }
            float4 VertexSnappingScreenSpace(float4 _vertex)
            {
                float4 roundedVertex = _vertex;

                roundedVertex.xy = roundedVertex.xy / _vertex.w;
                roundedVertex.xy = round(roundedVertex.xy * _ScreenParams.xy) / _ScreenParams.xy;
                roundedVertex.xy *= _vertex.w;

                return roundedVertex;
            }
            v2f vert (appdata v)
            {
                v2f o;

                o.vertex = VertexSnappingViewSpace(v.vertex);
                o.vertex = VertexSnappingScreenSpace(o.vertex);

                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv2 = TRANSFORM_TEX(v.uv, _SplashTex);

                o.gouraud = DotClamped(UnityObjectToWorldNormal(v.normal), normalize(_WorldSpaceLightPos0));

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                fixed4 splash = tex2D(_SplashTex, i.uv2);

                fixed4 output = lerp(col * _Tint, col * _SplashTint, splash);
                float4 light = lerp(_Ambient, 1.0, i.gouraud);

                return output * light;
            }
            ENDCG
        }
    }
}
