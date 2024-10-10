Shader "Custom/Grass"
{
    Properties
    {
        _Color ("Grass Color", Color) = (0.0, 1.0, 0.0, 1.0)
        _WindStrength ("Wind Strength", float) = 1.0
        _WindSpeed ("Wind Speed", float) = 1.0
        _NoiseScale ("Noise Scale", float) = 1.0
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 200

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 color : COLOR;
            };

            // Uniforms
            float4 _Color;
            float _WindStrength;
            float _WindSpeed;
            float _NoiseScale;

            // Vertex shader
            v2f vert(appdata v)
            {
                v2f o;

                // Use Unity's built-in _Time variable (_Time.y is the time in seconds)
                float noise = sin(v.vertex.x * _NoiseScale + _Time.y * _WindSpeed) * cos(v.vertex.z * _NoiseScale + _Time.y * _WindSpeed);
                float sway = noise * _WindStrength;

                // Offset the vertex position by the sway
                v.vertex.x += sway * v.normal.x;
                v.vertex.z += sway * v.normal.z;

                o.pos = UnityObjectToClipPos(v.vertex);
                o.color = _Color.rgb;

                return o;
            }

            // Fragment shader
            fixed4 frag(v2f i) : SV_Target
            {
                return fixed4(i.color, 1.0);
            }
            ENDCG
        }
    }
}
