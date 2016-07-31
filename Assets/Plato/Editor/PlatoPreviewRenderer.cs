using UnityEngine;
using UnityEditor;

namespace Plato
{
    public class PlatoPreviewRenderer
    {
        #region Public methods

        public PlatoPreviewRenderer()
        {
            _utility = new PreviewRenderUtility();
            _angles = new Vector2(0, 20);

            if (_mesh == null)
                _mesh = (Mesh)EditorGUIUtility.LoadRequired(_meshAssetPath);
        }

        public void Render(Material material, Rect rect, GUIStyle background)
        {
            var rotation = UpdateRotation(rect);

            _utility.m_Camera.transform.position = rotation * Vector3.forward * -3;
            _utility.m_Camera.transform.LookAt(Vector3.zero);

            _utility.m_Light[0].intensity = 1;
            _utility.m_Light[0].transform.rotation = Quaternion.Euler(50, 50, 0);
            _utility.m_Light[1].intensity = 1;

            _utility.BeginPreview(rect, background);
            _utility.DrawMesh(_mesh, Vector3.zero, Quaternion.identity, material, 0);
            _utility.m_Camera.Render();
            _utility.EndAndDrawPreview(rect);
        }

        #endregion

        #region Static members

        const string _meshAssetPath = "Previews/Plato.asset";
        static int _controlHash = "Preview".GetHashCode();
        static Mesh _mesh;

        #endregion

        #region Private members

        PreviewRenderUtility _utility;
        Vector2 _angles;

        Quaternion UpdateRotation(Rect rect)
        {
            var controlID = GUIUtility.GetControlID(_controlHash, FocusType.Passive);
            var current = Event.current;
            var eventType = current.GetTypeForControl(controlID);

            if (eventType == EventType.MouseDown && rect.Contains(current.mousePosition))
            {
                GUIUtility.hotControl = controlID;
                current.Use();
                EditorGUIUtility.SetWantsMouseJumping(1);
            }

            if (GUIUtility.hotControl == controlID)
            {
                if (eventType == EventType.MouseUp)
                {
                    GUIUtility.hotControl = 0;
                    EditorGUIUtility.SetWantsMouseJumping(0);
                }

                if (eventType == EventType.MouseDrag)
                {
                    _angles += current.delta * 140 / Mathf.Min(rect.width, rect.height);
                    _angles.y = Mathf.Clamp(_angles.y, -89.99f, 89.99f);
                    current.Use();
                    GUI.changed = true;
                }
            }

            return Quaternion.Euler(_angles.y, _angles.x, 0);
        }

        #endregion
    }
}
