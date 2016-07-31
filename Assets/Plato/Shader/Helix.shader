Shader "Plato/Helix"
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

        [Header(Helix Parameters)]
        _NoiseAmp("Noise Amplitude", Float) = 0.6
        _NoiseSpeed("Noise Speed", Float) = 1.2
        _NoiseFreq("Noise Frequency", Float) = 1
        [Space]
        _SpikeProb("Spike Probability", Float) = 0.005
        _SpikeAmp("Spike Amplitude", Float) = 1
        [Space]
        _HelixFreq("Helix Frequency", Float) = 30
        _HelixSlope("Helix Slope", Float) = 3
        _HelixSpeed("Helix Speed", Float) = 3
        [Space]
        _Cutoff("Cutoff", Range(0, 1)) = 0.5
        _WaveFreq("Wave Frequency", Float) = 2
        _WaveAmp("Wave Amplitude", Range(0, 1)) = 0.35
        _WaveSpeed("Wave Speed", Float) = 8
        [Space]
        _RandomSeed("Random Seed", Float) = 0
    }

    SubShader
    {
        Tags { "RenderType"="Opaque"}

        Cull back

        CGPROGRAM
        #pragma surface Surface Standard vertex:ModifyVertex addshadow
        #pragma target 3.0
        #include "Helix.cginc"
        ENDCG

        Cull front

        CGPROGRAM
        #pragma surface Surface Standard vertex:ModifyVertex addshadow
        #pragma target 3.0
        #define BACKFACE
        #include "Helix.cginc"
        ENDCG
    }
    CustomEditor "Plato.PlatoMaterialEditor"
}
