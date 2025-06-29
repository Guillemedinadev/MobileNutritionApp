import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nutrition_app/models/alimento.dart';

class AlimentoGestion {
  final String userId;
  final CollectionReference alimentosRef;

  AlimentoGestion({required this.userId})
      : alimentosRef = FirebaseFirestore.instance
            .collection('usuarios')
            .doc(userId)
            .collection('alimentos');
//crear alimento firebase
Future<Alimento> crearAlimento(Alimento alimento) async {
  DocumentReference docRef = await alimentosRef.add(alimento.toJson());
  alimento.id = docRef.id;
  return alimento;

}

//update alimento firebase
Future<void> actualizarAlimento(String? id, String campo, dynamic valor) async {
  await alimentosRef.doc(id).update({campo: valor});
}

//leer alimento firebase
  Future<Alimento?> getAlimento(String id) async {
    final doc = await alimentosRef.doc(id).get();

    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return Alimento.fromJson(data);
    } else {
      return null;
    }
  }
//leer todos los alimentos firebase
  Future<List<Alimento>> getTodosLosAlimentos() async {
    final snapshot = await alimentosRef.get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return Alimento.fromJson(data);
    }).toList();
  }
//eliminiar alimento firebase
  Future<void> eliminarAlimento(String id) async {
    await alimentosRef.doc(id).delete();
  }
}
