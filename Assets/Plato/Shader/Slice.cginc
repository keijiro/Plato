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

float _Cutoff;
float _Width;
float _Scroll;

float _RotationAmp;
float _RotationFreq;
float _RotationSpeed;

float _ScaleAmp;
float _ScaleFreq;
float _ScaleSpeed;

struct Input
{
    float2 uv_AlbedoMap;
    float3 rawPosition;
};

float PosToParam(float3 v)
{
    return v.y / _Width + _Time.y * _Scroll;
}

float3 Rotate(float3 v, float r)
{
    float s, c;
    sincos(r, s, c);

    return float3(
        dot(float2(c, -s), v.xz),
        v.y,
        dot(float2(s, c), v.xz)
    );
}

float3 ApplyModifier(float3 v)
{
    float time = _Time.y;
    float slice = floor(PosToParam(v));

    float np_r = slice * _RotationFreq + _RotationSpeed * time;
    float np_s = slice * _ScaleFreq    + _ScaleSpeed    * time;

    float n_r = snoise(float2(np_r, 0.5));
    float n_s = snoise(float2(np_s, 0.2));

    v = Rotate(v, n_r * _RotationAmp);
    v.xz *= 1 + n_s * _ScaleAmp;

    return v;
}

void Cutout(float3 v)
{
    clip(frac(PosToParam(v) + _Cutoff / 2) - _Cutoff);
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
    v.normal = normalize(lerp(v.normal, n, saturate(_RotationAmp)));

#ifdef BACKFACE
    v.normal *= -1;
#endif
}

void Surface(Input IN, inout SurfaceOutputStandard o)
{
    Cutout(IN.rawPosition);

#ifndef BACKFACE

    float2 uv = IN.uv_AlbedoMap;
    half4 a_map = tex2D(_AlbedoMap, uv);
    o.Albedo = saturate(_AlbedoColor.rgb * a_map);

    o.Metallic = _Metallic;
    o.Smoothness = _Smoothness;

    half4 n1_map = tex2D(_NormalMap, uv);
    half4 n2_map = tex2D(_DetailNormalMap, uv);
    half3 n1 = UnpackScaleNormal(n1_map, _NormalMapScale);
    half3 n2 = UnpackScaleNormal(n2_map, _DetailNormalMapScale);
    o.Normal = BlendNormals(n1, n2);

    half o_map = tex2D(_OcclusionMap, uv).g;
    o.Occlusion = LerpOneTo(o_map, _OcclusionStrength);

#else

    o.Albedo = _BackColor;
    o.Metallic = _BackMetallic;
    o.Smoothness = _BackSmoothness;

#endif
}
