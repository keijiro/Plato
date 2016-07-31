Shader "Plato/Stripe"
{
    Properties
    {
		[HDR] _AlbedoColor("Albedo Color", Color) = (1,1,1)

        [Space]

		[Gamma] _Metallic("Metallic", Range(0,1)) = 0
		_Smoothness("Smoothness", Range(0,1)) = 0

        [Space]

		_NormalMap("Normal Map", 2D) = "bump"{}

        [Space]

		_OcclusionMap("Occlusion", 2D) = "white"{}
		_OcclusionStrength("Strength", Range(0,1)) = 1

        [Space]

		_DetailAlbedoMap("Detail Albedo", 2D) = "grey"{}
		_DetailNormalMap("Normal Map", 2D) = "bump"{}
		_DetailNormalMapScale("Scale", Float) = 1
    }

    CGINCLUDE

    #include "UnityCG.cginc"

    half3 _AlbedoColor;

    half _Metallic;
    half _Smoothness;

    sampler2D _NormalMap;

    sampler2D _OcclusionMap;
    half _OcclusionStrength;

    sampler2D _DetailAlbedoMap;
    sampler2D _DetailNormalMap;
    half _DetailNormalMapScale;

    struct Input
    {
        float2 uv_NormalMap;
        float cutParam;
    };

    void ModifyVertex(inout appdata_full v, out Input o)
    {
        UNITY_INITIALIZE_OUTPUT(Input, o);

        o.cutParam = dot(v.vertex, normalize(float3(1, 1, 0.1))) * 8 + _Time.y * 2;
    }

    void SurfaceFront(Input IN, inout SurfaceOutputStandard o)
    {
        clip(frac(IN.cutParam) - 0.5);

        half4 a_map = tex2D(_DetailAlbedoMap, IN.uv_NormalMap);

        o.Albedo = saturate(_AlbedoColor.rgb * a_map);
        o.Metallic = _Metallic;
        o.Smoothness = _Smoothness;

        half4 n1_map = tex2D(_NormalMap, IN.uv_NormalMap);
        half4 n2_map = tex2D(_DetailNormalMap, IN.uv_NormalMap);
        half3 n1 = UnpackNormal(n1_map);
        half3 n2 = UnpackScaleNormal(n2_map, _DetailNormalMapScale);
        o.Normal = BlendNormals(n1, n2);

        half o_map = tex2D(_OcclusionMap, IN.uv_NormalMap).g;
        o.Occlusion = LerpOneTo(o_map, _OcclusionStrength);
    }

    void SurfaceBack(Input IN, inout SurfaceOutputStandard o)
    {
        clip(frac(IN.cutParam) - 0.5);

        o.Albedo = float3(1, 0, 0);
        o.Normal = float3(0, 0, -1);
    }

    ENDCG

    SubShader
    {
        Tags { "RenderType"="Opaque"}

        Cull back

        CGPROGRAM
        #pragma surface SurfaceFront Standard vertex:ModifyVertex  addshadow
        #pragma target 3.0
        ENDCG

        Cull front

        CGPROGRAM
        #pragma surface SurfaceBack Standard vertex:ModifyVertex  addshadow
        #pragma target 3.0
        ENDCG
    }
}
