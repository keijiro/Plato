Shader "Plato/Spiral"
{
    Properties
    {
        // Common attributes
		_AlbedoMap("", 2D) = "grey"{}
		[HDR] _AlbedoColor("", Color) = (0.5, 0.5, 0.5)
		[Gamma] _Metallic("", Range(0, 1)) = 0
		_Smoothness("", Range(0, 1)) = 0
		_NormalMap("", 2D) = "bump"{}
		_NormalMapScale("", Range(0, 2)) = 1
		_DetailNormalMap("", 2D) = "bump"{}
		_DetailNormalMapScale("", Range(0, 2)) = 1
		_OcclusionMap("", 2D) = "white"{}
		_OcclusionStrength("", Range(0,1)) = 1

        [Header(Back Face Attributes)]
        _BackColor("Color", Color) = (1,1,1)
		[Gamma] _BackMetallic("Metallic", Range(0,1)) = 0
		_BackSmoothness("Smoothness", Range(0,1)) = 0

        [Header(Spiral Parameters)]
        _SpiralParam1("Param1", Range(0, 1)) = 0
        _SpiralParam2("Param2", Float) = 0
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
    CustomEditor "Plato.PlatoMaterialEditor"
}
