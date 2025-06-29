import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/plato_planificado.dart';

class PlanificacionGestion {
  final String userId;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  PlanificacionGestion(this.userId);

  String _formatearFecha(DateTime fecha) {
    return "${fecha.year.toString().padLeft(4, '0')}-"
           "${fecha.month.toString().padLeft(2, '0')}-"
           "${fecha.day.toString().padLeft(2, '0')}";
  }

  Future<PlatoPlanificado> agregarPlato(PlatoPlanificado plato) async {
    final fechaId = _formatearFecha(plato.fecha);
    final platosRef = _db
        .collection('usuarios')
        .doc(userId)
        .collection('planificacion')
        .doc(fechaId)
        .collection('platos');

    final doc = await platosRef.add(plato.toJson());
    plato.id = doc.id;
    return plato;
  }

  Future<List<PlatoPlanificado>> obtenerPlatosDeFecha(DateTime fecha) async {
    final fechaId = _formatearFecha(fecha);
    final snapshot = await _db
        .collection('usuarios')
        .doc(userId)
        .collection('planificacion')
        .doc(fechaId)
        .collection('platos')
        .get();

    return snapshot.docs.map((doc) {
      return PlatoPlanificado.fromJson(doc.data(), doc.id);
    }).toList();
  }

  Future<void> actualizarPlato(PlatoPlanificado plato) async {
    final fechaId = _formatearFecha(plato.fecha);
    final docRef = _db
        .collection('usuarios')
        .doc(userId)
        .collection('planificacion')
        .doc(fechaId)
        .collection('platos')
        .doc(plato.id);

    await docRef.set(plato.toJson());
  }

  Future<void> eliminarPlato(PlatoPlanificado plato) async {
    final fechaId = _formatearFecha(plato.fecha);
    final docRef = _db
        .collection('usuarios')
        .doc(userId)
        .collection('planificacion')
        .doc(fechaId)
        .collection('platos')
        .doc(plato.id);

    await docRef.delete();
  }

  Future<void> copiarPlatosADias(List<DateTime> fechasDestino, List<PlatoPlanificado> platosOriginales) async {
    for (DateTime fecha in fechasDestino) {
      final fechaId = _formatearFecha(fecha);
      final platosRef = _db
          .collection('usuarios')
          .doc(userId)
          .collection('planificacion')
          .doc(fechaId)
          .collection('platos');

      for (PlatoPlanificado original in platosOriginales) {
        final nuevoPlato = PlatoPlanificado(
          id: null,
          nombre: original.nombre,
          fecha: fecha,
          tipoComida: original.tipoComida,
          alimentos: original.alimentos.map((a) => a.copiaConFecha(fecha)).toList(),
        );
        await platosRef.add(nuevoPlato.toJson());
      }
    }
  }
}
