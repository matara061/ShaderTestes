Shader "Unlit/Flag"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Speed ("Wave Speed", Float) = 3.0
        _Amplitude ("Wave Amplitude", Float) = 0.5
        _Frequency ("Wave Frequency", Float) = 2.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            // Propriedades para o movimento da bandeira
            float _Speed;
            float _Amplitude;
            float _Frequency;

            v2f vert (appdata v)
            {
                v2f o;
                
                // Aplica um movimento ondulante nos vértices
                float wave = sin(_Time.y * _Speed + v.vertex.x * _Frequency) * _Amplitude;
                v.vertex.y += wave;  // Move os vértices na direção Y
                
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // Aqui criamos as três cores da bandeira da Alemanha
                fixed4 col;
                if (i.uv.y > 0.66)
                {
                    // Cor preta (topo)
                    col = fixed4(0, 0, 0, 1);
                }
                else if (i.uv.y > 0.33)
                {
                    // Cor vermelha (meio)
                    col = fixed4(1, 0, 0, 1);
                }
                else
                {
                    // Cor amarela (base)
                    col = fixed4(1, 0.8, 0, 1);
                }

                // Aplica fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
