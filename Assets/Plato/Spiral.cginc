#include "UnityCG.cginc"
#include "SimplexNoise2D.cginc"

sampler2D _AlbedoMap;
half3 _AlbedoColor;

half _Metallic;
half _Smoothness;

sampler2D _NormalMap;
half _NormalMapScale;

sampler2D _DetailNormalMap;
half _DetailNormalMapScale;

sampler2D _OcclusionMap;
half _OcclusionStrength;

half3 _BackColor;
half _BackMetallic;
half _BackSmoothness;

struct Input
{
    float2 uv_AlbedoMap;
    float3 rawPosition;
};

float UVRandom(float2 uv)
{
    return frac(sin(dot(uv, float2(12.9898, 78.233))) * 43758.5453);
}

float3 ApplyModifier(float3 v)
{
    float phi = atan2(v.z, v.x) / UNITY_PI;
    float2 np = float2(phi, v.y * 6 + phi * 2) + _Time.y * 1.2;

    float n = snoise(np);
    n *= 1 + (UVRandom(v.xy + v.yz + floor(_Time.y)) > 0.995);
    v.xz *= 1 + n * n * n * 0.6;

    return v;
}

void Cutout(float3 v)
{
    float time = _Time.y;
    float phi = atan2(v.x, v.z) / UNITY_PI;
    float wave = sin((v.y * 4 + phi * 2) * UNITY_PI - time * 8);
    float p = frac(v.y * 30 + phi * 3 + time * 3);
    clip(p + 0.35 * wave - 0.5);
}

void ModifyVertex(inout appdata_full v, out Input o)
{
    UNITY_INITIALIZE_OUTPUT(Input, o);

    o.rawPosition = v.vertex.xyz;

    float3 v1 = ApplyModifier(v.vertex.xyz);
    float3 v2 = ApplyModifier(v.texcoord1.xyz);
    float3 v3 = ApplyModifier(v.texcoord2.xyz);
    float3 n = normalize(cross(v2 - v1, v3 - v1));

    v.vertex.xyz = v1;
    v.normal = normalize((v.normal + n) * 0.5);

#ifdef BACKFACE
    v.normal *= -1;
#endif
}

void Surface(Input IN, inout SurfaceOutputStandard o)
{
    Cutout(IN.rawPosition);

#ifndef BACKFACE

    half4 a_map = tex2D(_AlbedoMap, IN.uv_AlbedoMap);
    o.Albedo = saturate(_AlbedoColor.rgb * a_map);

    o.Metallic = _Metallic;
    o.Smoothness = _Smoothness;

    half4 n1_map = tex2D(_NormalMap, IN.uv_AlbedoMap);
    half4 n2_map = tex2D(_DetailNormalMap, IN.uv_AlbedoMap);
    half3 n1 = UnpackScaleNormal(n1_map, _NormalMapScale);
    half3 n2 = UnpackScaleNormal(n2_map, _DetailNormalMapScale);
    o.Normal = BlendNormals(n1, n2);

    half o_map = tex2D(_OcclusionMap, IN.uv_AlbedoMap).g;
    o.Occlusion = LerpOneTo(o_map, _OcclusionStrength);

#else

    o.Albedo = _BackColor;
    o.Metallic = _BackMetallic;
    o.Smoothness = _BackSmoothness;

#endif
}
