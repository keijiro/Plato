using UnityEngine;
using UnityEditor;

namespace Plato
{
    public class PlatoMaterialEditor : ShaderGUI
    {
        static GUIContent _textAlbedoMap = new GUIContent("Albedo Map");
        static GUIContent _textNormalMap = new GUIContent("Normal Map");
        static GUIContent _textDetailNormal = new GUIContent("Detail Normal");
        static GUIContent _textOcclusionMap = new GUIContent("Occlusion Map");

        public override void OnGUI(MaterialEditor editor, MaterialProperty[] props)
        {
            GUILayout.Label("Front Face Attributes", EditorStyles.boldLabel);

            // Albedso
            var texture = FindProperty("_AlbedoMap", props);
            var option = FindProperty("_AlbedoColor", props);
            editor.TexturePropertySingleLine(_textAlbedoMap, texture, option);

            EditorGUILayout.Space();

            // Metallic/Smoothness
            editor.RangeProperty(FindProperty("_Metallic", props), "Metallic");
            editor.RangeProperty(FindProperty("_Smoothness", props), "Smoothness");

            EditorGUILayout.Space();

            // Normal
            texture = FindProperty("_NormalMap", props);
            option = FindProperty("_NormalMapScale", props);
            editor.TexturePropertySingleLine(
                _textNormalMap, texture,
                texture.textureValue != null ? option : null
            );

            texture = FindProperty("_DetailNormalMap", props);
            option = FindProperty("_DetailNormalMapScale", props);
            editor.TexturePropertySingleLine(
                _textDetailNormal, texture,
                texture.textureValue != null ? option : null
            );

            EditorGUILayout.Space();

            // Occlusion
            texture = FindProperty("_OcclusionMap", props);
            option = FindProperty("_OcclusionStrength", props);
            editor.TexturePropertySingleLine(
                _textOcclusionMap, texture,
                texture.textureValue != null ? option : null
            );

            EditorGUILayout.Space();

            // Scale/Tiling
            editor.TextureScaleOffsetProperty(FindProperty("_AlbedoMap", props));

            // Non-common parameters
            var i = 0;
            for (; i < props.Length; i++)
                if (props[i].name == "_OcclusionStrength") break;

            for (i++; i < props.Length; i++)
            {
                var p = props[i];
                editor.ShaderProperty(p, p.displayName);
            }
        }
    }
}
