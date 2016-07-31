Shader "Plato/Modifier"
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

    SubShader
    {
        Tags { "RenderType"="Opaque"}

        Cull back

        CGPROGRAM
        #pragma surface Surface Standard vertex:ModifyVertex addshadow
        #pragma target 3.0
        #include "Modifier.cginc"
        ENDCG

        Cull front

        CGPROGRAM
        #pragma surface Surface Standard vertex:ModifyVertex addshadow
        #pragma target 3.0
        #define SURFACE_FLIP
        #define MATERIAL_BACK
        #include "Modifier.cginc"
        ENDCG
    }
}
