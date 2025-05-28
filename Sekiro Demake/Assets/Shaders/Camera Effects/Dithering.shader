Shader "_MyShaders/Dithering"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            static const int ps1_dither_matrix[16] = 
            {
	    		-4, 0, -3, 1,
	    		2, -2, 3, -1,
	    		-3, 1, -4, 0,
	    		3, -1, 2, -2
		    };

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 output = tex2D(_MainTex, i.uv);

                int x = (int)(i.uv.x * _ScreenParams.x);
                int y = (int)(i.uv.y * _ScreenParams.y);

                float noise = float(ps1_dither_matrix[(x % 4) + (y % 4) * 4]) / 8;

                output.rgb += noise;

                return saturate(output);
            }
            ENDCG
        }
    }
}
