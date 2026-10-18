Shader "ACG/HologramShader"{
     Properties{
        _rimColor("Rim color", Color) = (0,0,0,0)
        _rimPower("Rim Power", Range(0,10)) = 0.5
    }
    subShader{
        Tags{
            "Queu"="Transparent"
        }

        Pass{
            ZWrite On
            ColorMask 0
        }

        CGPROGRAM
        #pragma surface surf Lambert alpha:fade

        float4 _rimColor;
        float _rimPower;
        struct Input{
            float3 viewDir;
        };

        void surf(Input IN, inout SurfaceOutput o){
            //half rim = 1 - dot(normalize(IN.viewDir), o.Normal) * _rimPower;
            //o.Emission = _rimColor.rgb * rim ;
            half rim = 1.0 - saturate(dot(IN.viewDir, o.Normal));
            o.Emission = _rimColor * pow(rim, _rimPower);
            o.Alpha = pow(rim, _rimPower);
        }
        ENDCG
    }
    Fallback "Diffuse"
}