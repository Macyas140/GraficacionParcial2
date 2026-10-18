Shader "ACG/SnowShader"{
    Properties{
        _MainTex("Texture", 2D) = "white" {}
        _Snow("Snow Level", Range(-1,1)) = 0.5
        _SnowColor("Snow Color", Color) = (1,1,1,1)
        _SnowDirection("SnowDirection", Vector) = (0,1,0)
        _SnowDepth("Snow Depth", Range(0,0.5)) = 0

    }
    SubShader{
        CGPROGRAM
            #pragma surface surf Lambert vertex:vert
            struct Input{
                float2 uv_MainTex;
                float3 worldNormal;
                INTERNAL_DATA
            };

            sampler2D _MainTex;
            float _Snow;
            float4 _SnowColor;
            float3 _SnowDirection;
            float _SnowDepth;

            void vert(inout appdata_full v){
                float3 snowDir = normalize(_SnowDirection.xyz);
                if(dot(snowDir, v.normal) >= _Snow){
                    v.vertex.xyz += v.normal * _SnowDepth;
                }
            }

            void surf(Input IN, inout SurfaceOutput o){
                float4 c = tex2D(_MainTex, IN.uv_MainTex);
                float3 wNormal = WorldNormalVector(IN, o.Normal);
                //if(la normal de la superficie eta apuntando en a direccion de _SnowDirection)
                    //Pintamos la superficie del color de la nieve
                //si no
                    //Pintamos el pixel del color de la textura
                if(dot(_SnowDirection.xyz, wNormal) >= _Snow){
                    o.Albedo = _SnowColor.rgb;
                }else{
                    o.Albedo = c.rgb;
                }
            }
            
        ENDCG
    }
}