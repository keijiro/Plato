Shader "Plato/Spiral"
{
    Properties
    {
		_AlbedoMap("Albedo Map", 2D) = "grey"{}
		[HDR] _AlbedoColor("Color", Color) = (0.5, 0.5, 0.5)

        [Space]

		[Gamma] _Metallic("Metallic", Range(0, 1)) = 0
		_Smoothness("Smoothness", Range(0, 1)) = 0

        [Space]

		_NormalMap("Normal Map", 2D) = "bump"{}
		_NormalMapScale("Scale", Range(0, 2)) = 1

		_DetailNormalMap("Detail Normal Map", 2D) = "bump"{}
		_DetailNormalMapScale("Scale", Range(0, 2)) = 1

        [Space]

		_OcclusionMap("Occlusion Map", 2D) = "white"{}
		_OcclusionStrength("Strength", Range(0,1)) = 1

        [Header(Back face)]

        _BackColor("Color", Color) = (1,1,1)
		[Gamma] _BackMetallic("Metallic", Range(0,1)) = 0
		_BackSmoothness("Smoothness", Range(0,1)) = 0
    }

    SubShader
    {
        Tags { "RenderType"="Opaque"}

        Cull back

        CGPROGRAM
        #pragma surface Surface Standard vertex:ModifyVertex addshadow
        #pragma target 3.0
        #include "Spiral.cginc"
        ENDCG

        Cull front

        CGPROGRAM
        #pragma surface Surface Standard vertex:ModifyVertex addshadow
        #pragma target 3.0
        #define BACKFACE
        #include "Spiral.cginc"
        ENDCG
    }
}
