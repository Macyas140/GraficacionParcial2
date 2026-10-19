Shader "ACG/S_StandardSpecularPBR"{
    Properties{
        _mainColor ("Color", Color) = (1,1,1,1)
        _metallicTex ("Texture", 2D) = "white" {}
        _SpecColor ("Specular Color", Color) = (0.2, 0.2, 0.2, 1) // Default to dark gray for dielectrics
    }

    SubShader{
        Tags { "RenderType"="Opaque" }
        
        CGPROGRAM
            #pragma surface surf StandardSpecular

            float4 _mainColor;
            sampler2D _metallicTex;

            struct Input{
                float2 uv_metallicTex;
            };

            void surf(Input IN, inout SurfaceOutputStandardSpecular o){
                o.Albedo = _mainColor.rgb;
                o.Smoothness = tex2D(_metallicTex, IN.uv_metallicTex).r;
                o.Specular = _SpecColor.rgb;
            }
        ENDCG
    }
    Fallback "Diffuse"
}