Shader "ACG/WithShadowShader"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
    }
    SubShader
    {

        Pass
        {
            Tags{"LightMode"="ForwardBase"}
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdbase nolightmap nodirlightmap nodynlightmap novertexlight
            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc"
            #include "Lighting.cginc"
            #include "AutoLight.cginc"



            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 pos : SV_POSITION;
                float diff : COLOR0;
                SHADOW_COORDS(1)
            };

            float4 _MainTex_ST;

            sampler2D _MainTex;

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                //o.uv = v.uv;
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                half3 worldNormal = UnityObjectToWorldNormal(v.normal);
                half dotP = max(0,dot(worldNormal, _WorldSpaceLightPos0.xyz));
                o.diff = dotP * _LightColor0;
                TRANSFER_SHADOW(o)

               
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                //col *= i.diff;
                fixed shadow = SHADOW_ATTENUATION(i);
                // shadow = 0 -> it means it is fully shadowed
                // shadow = 1 -> It means it is not shadowed
                col.rgb *= i.diff * shadow;
                
                return col;
            }
            ENDCG
        }
        Pass{
            Tags{"LightMode"="ShadowCaster"}
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_shadowcaster
            #include "UnityCG.cginc"

            struct appdata{
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };
            struct v2f{
                V2F_SHADOW_CASTER;
            };
            v2f vert(appdata v){
                v2f o;
                TRANSFER_SHADOW_CASTER_NORMALOFFSET(o);
                return o;
            }
            fixed4 frag(v2f i) : SV_Target{
                SHADOW_CASTER_FRAGMENT(i);
            }
            ENDCG
        }
    }
}
