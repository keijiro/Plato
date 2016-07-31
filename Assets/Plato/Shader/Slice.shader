Shader "Plato/Slice"
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
		_OcclusionStrength("", Range(0, 1)) = 1

        [Header(Back Face Attributes)]
        _BackColor("Color", Color) = (1, 1, 1)
		[Gamma] _BackMetallic("Metallic", Range(0, 1)) = 0
		_BackSmoothness("Smoothness", Range(0, 1)) = 0

        [Header(Slice Parameters)]
        _Cutoff("Cutoff", Range(0, 1)) = 0.5
        _Width("Slice Width", Float) = 0.1
        _Scroll("Scroll Speed", Float) = 2
        [Space]
        _RotationAmp("Rotation Amount", Float) = 1.2
        _RotationFreq("Noise Frequency", Float) = 1
        _RotationSpeed("Noise Speed", Float) = 0
        [Space]
        _ScaleAmp("Scale Amount", Float) = 0.3
        _ScaleFreq("Noise Frequency", Float) = 1
        _ScaleSpeed("Noise Speed", Float) = 0
    }

    SubShader
    {
        Tags { "RenderType"="Opaque"}

        Cull back

        CGPROGRAM
        #pragma surface Surface Standard vertex:ModifyVertex addshadow
        #pragma target 3.0
        #include "Slice.cginc"
        ENDCG

        Cull front

        CGPROGRAM
        #pragma surface Surface Standard vertex:ModifyVertex addshadow
        #pragma target 3.0
        #define BACKFACE
        #include "Slice.cginc"
        ENDCG
    }
    CustomEditor "Plato.PlatoMaterialEditor"
}
