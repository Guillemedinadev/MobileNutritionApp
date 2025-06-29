import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nutrition_app/models/usuario.dart';

class UsuarioGestion {
  final CollectionReference _usuarios = FirebaseFirestore.instance.collection('usuarios');

  Future<void> crearUsuario(Usuario usuario) async {
    await _usuarios.doc(usuario.id).set(usuario.toJson());
  }

  Future<void> actualizarUsuario(String? id, String campo, dynamic valor) async {
    if (id != null) {
      await _usuarios.doc(id).update({campo: valor});
    }
  }

  Future<void> eliminarUsuario(String? id) async {
    if (id != null) {
      await _usuarios.doc(id).delete();
    }
  }

  Future<Usuario?> getUsuarioPorId(String? id) async {
    if (id == null) return null;
    final doc = await _usuarios.doc(id).get();
    if (!doc.exists) return null;
    return Usuario.fromJson(doc.data() as Map<String, dynamic>, id: doc.id);
  }
}
