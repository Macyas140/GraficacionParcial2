Shader "ACG/BumpShader"{
    Properties{
        _myTex("Difuse Texture", 2D) = "white" {}
        _myBump("Bump Texture", 2D) = "bump" {}
        _RangeBump("Bump scale", Range(0,10)) = 1
        _RangeTex("Texture scale", Range(0,10)) = 1
        _myCube("Example Cube", CUBE) = "" {}

    }

    SubShader{
        CGPROGRAM
            #pragma surface surf Lambert
            
            sampler2D _myTex;
            sampler2D _myBump;
            float _RangeBump;
            float _RangeTex;
            samplerCUBE _myCube;

            struct Input{
                float2 uv_myTex;
                float2 uv_myBump;
                float3 worldRefl; INTERNAL_DATA
            };

            void surf(Input IN, inout SurfaceOutput o){
                o.Albedo = tex2D(_myTex, IN.uv_myTex*_RangeTex).rgb;
                o.Normal = UnpackNormal(tex2D(_myBump, IN.uv_myBump*_RangeTex));
                o.Normal.rg *= _RangeBump;
                o.Emission = texCUBE(_myCube, WorldReflectionVector(IN,o.Normal)).rgb;
                
            }

        ENDCG

    }
    FallBack "Difuse"
}