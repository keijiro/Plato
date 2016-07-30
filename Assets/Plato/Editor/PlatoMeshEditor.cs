using UnityEngine;
using UnityEditor;
using System.IO;
using System.Collections.Generic;

namespace Plato
{
    public static class PlatoMeshEditor
    {
        static Object[] SelectedMeshes {
            get {
                return Selection.GetFiltered(typeof(Mesh), SelectionMode.Deep);
            }
        }

        static string NewFileName(Mesh mesh)
        {
            var path = AssetDatabase.GetAssetPath(mesh);

            if (string.IsNullOrEmpty(path))
                path = "Assets";
            else if (Path.GetExtension(path) != "")
                path = path.Replace(Path.GetFileName(path), "");

            return AssetDatabase.GenerateUniqueAssetPath(
                path + "/Plato Converted.asset"
            );
        }

        [MenuItem("Assets/Plato/Convert Mesh", true)]
        static bool ValidateConvertMesh()
        {
            return SelectedMeshes.Length > 0;
        }

        [MenuItem("Assets/Plato/Convert Mesh")]
        static void ConvertMesh()
        {
            foreach (Mesh mesh in SelectedMeshes)
                AssetDatabase.CreateAsset(
                    ConvertMesh(mesh), NewFileName(mesh)
                );
        }

        static Mesh ConvertMesh(Mesh source)
        {
            var src_indices   = source.GetIndices(0);
            var src_vertices  = source.vertices;
            var src_normals   = source.normals;
            var src_tangents  = source.tangents;
            var src_texcoords = source.uv;

            var vcount = src_indices.Length;
            var indices   = new int[vcount];
            var vertices  = new List<Vector3>(vcount);
            var normals   = new List<Vector3>(vcount);
            var tangents  = new List<Vector4>(vcount);
            var texcoords = new List<Vector2>(vcount);
            var vrefs1    = new List<Vector3>(vcount);
            var vrefs2    = new List<Vector3>(vcount);

            for (var i = 0; i < vcount; i++)
                indices[i] = i;

            for (var i = 0; i < vcount; i++)
            {
                var vi = src_indices[i];
                vertices. Add(src_vertices [vi]);
                normals.  Add(src_normals  [vi]);
                tangents. Add(src_tangents [vi]);
                texcoords.Add(src_texcoords[vi]);
            }

            for (var i = 0; i < vcount; i += 3)
            {
                var v1 = src_vertices[src_indices[i]];
                var v2 = src_vertices[src_indices[i + 1]];
                var v3 = src_vertices[src_indices[i + 2]];

                vrefs1.Add(v2);
                vrefs2.Add(v3);

                vrefs1.Add(v3);
                vrefs2.Add(v1);

                vrefs1.Add(v1);
                vrefs2.Add(v2);
            }

            var mesh = new Mesh();
            mesh.name = "Plato Converted";
            mesh.SetVertices(vertices);
            mesh.SetNormals(normals);
            mesh.SetTangents(tangents);
            mesh.SetUVs(0, texcoords);
            mesh.SetUVs(1, vrefs1);
            mesh.SetUVs(2, vrefs2);
            mesh.SetIndices(indices, MeshTopology.Triangles, 0);
            mesh.RecalculateBounds();
            return mesh;
        }
    }
}
