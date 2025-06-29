import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nutrition_app/models/alimento.dart';
import 'package:nutrition_app/models/historial.dart';
import 'package:nutrition_app/models/nutrientes_totales.dart';
import 'package:nutrition_app/models/plato_planificado.dart';

class HistorialGestion {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String userId;

  HistorialGestion(this.userId);
  FirebaseFirestore get firestore => _db;
//Crear historial vacio en firebase.
  Future<void> crearHistorialDia(DateTime fecha) async {
    final String fechaId = _formatoFecha(fecha);
    final DocumentReference ref = _db
        .collection('usuarios')
        .doc(userId)
        .collection('historial')
        .doc(fechaId);

    final Map<String, dynamic> historialInicial = {
    'fecha': fechaId,
    'totales': NutrientesTotales().toJson(),
  };

    await ref.set(historialInicial, SetOptions(merge: true));
  }

//Update historial firebase.
  Future<void> registroAlimento({
    required DateTime fecha,
    Alimento? alimento,
    PlatoPlanificado? plato,
  }) async {
    final String fechaId = _formatoFecha(fecha);

    final DocumentReference diaRef = _db
        .collection('usuarios')
        .doc(userId)
        .collection('historial')
        .doc(fechaId);

    final docSnapshot = await diaRef.get();
    if (!docSnapshot.exists) {
      await crearHistorialDia(fecha);
    } else {
      final data = docSnapshot.data() as Map<String, dynamic>? ?? {};
      if (!data.containsKey('fecha')) {
        await diaRef.set({'fecha': fechaId}, SetOptions(merge: true));
      }
    }

    if (alimento != null) {
      final CollectionReference capturadosRef = diaRef.collection('capturados');
      final docRef = capturadosRef.doc();
      alimento.id = docRef.id;
      await docRef.set(alimento.toJson());
    }

    if (plato != null) {
      final CollectionReference platosRef = diaRef.collection('platosConsumidos');
      final docRef = platosRef.doc(plato.id); 
      await docRef.set(plato.toJson());
    }

    await actualizarTotales(fecha);
  }


  Future<void> eliminarRegistroDeHistorial({
    required DateTime fecha,
    Alimento? alimento,
    PlatoPlanificado? plato,
  }) async {
    final String fechaId = _formatoFecha(fecha);
    final DocumentReference ref = _db
        .collection('usuarios')
        .doc(userId)
        .collection('historial')
        .doc(fechaId);

    final snapshot = await ref.get();

    if (!snapshot.exists) return;

    if (alimento != null) {
      await ref.collection('capturados').doc(alimento.id).delete();
    }

    if (plato != null) {
      await ref.collection('platosConsumidos').doc(plato.id).delete();
    }

    await actualizarTotales(fecha);
  }


  Future<Historial?> getHistorialPorFecha(DateTime fecha) async {
    final String fechaId = _formatoFecha(fecha);
    final DocumentReference ref = _db
        .collection('usuarios')
        .doc(userId)
        .collection('historial')
        .doc(fechaId);

    final snapshot = await ref.get();
    if (!snapshot.exists) return null;

    final data = snapshot.data() as Map<String, dynamic>;

    // Obtener alimentos capturados
    final capturadosSnapshot = await ref.collection('capturados').get();
    final capturados = capturadosSnapshot.docs.map((doc) {
      final alimento = Alimento.fromJson(doc.data());
      alimento.id = doc.id;
      return alimento;
    }).toList();

    // Obtener platos seleccionados
    final platosSnapshot = await ref.collection('platosConsumidos').get();
    final platos = platosSnapshot.docs.map((doc) {
      return PlatoPlanificado.fromJson(doc.data(), doc.id);
    }).toList();

    // Crear historial
    final historial = Historial.fromJson(data);
    historial.capturados = capturados;
    historial.platosConsumidos = platos;

    return historial;
  }


  Future<void> actualizarTotales(DateTime fecha) async {
    final String fechaId = _formatoFecha(fecha);
    final DocumentReference ref = _db
        .collection('usuarios')
        .doc(userId)
        .collection('historial')
        .doc(fechaId);

    final QuerySnapshot capturadosSnapshot = await ref.collection('capturados').get();
    final QuerySnapshot platosSnapshot = await ref.collection('platosConsumidos').get();

    double calorias = 0;
    double proteinas = 0;
    double grasas = 0;
    double grasasSaturadas = 0;
    double hidratosDeCarbono = 0;
    double azucares = 0;
    double fibra = 0;
    double sal = 0;

    for (var doc in capturadosSnapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final alimento = Alimento.fromJson(data);
      calorias += alimento.calorias ?? 0;
      proteinas += alimento.proteinas ?? 0;
      grasas += alimento.grasas ?? 0;
      grasasSaturadas += alimento.grasasSaturadas ?? 0;
      hidratosDeCarbono += alimento.hidratosDeCarbono ?? 0;
      azucares += alimento.azucares ?? 0;
      fibra += alimento.fibra ?? 0;
      sal += alimento.sal ?? 0;
    }

    for (var doc in platosSnapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final plato = PlatoPlanificado.fromJson(data, doc.id);
      calorias += plato.caloriasTotales;
      proteinas += plato.proteinasTotales;
      grasas += plato.grasasTotales;
      grasasSaturadas += plato.grasasSaturadasTotales;
      hidratosDeCarbono += plato.hidratosDeCarbonoTotales;
      azucares += plato.azucaresTotales;
      fibra += plato.fibraTotales;
      sal += plato.salTotales;
    }

    final nuevosTotales = NutrientesTotales(
      calorias: calorias,
      proteinas: proteinas,
      grasas: grasas,
      grasasSaturadas: grasasSaturadas,
      hidratosDeCarbono: hidratosDeCarbono,
      azucares: azucares,
      fibra: fibra,
      sal: sal,
    );

    await ref.update({'totales': nuevosTotales.toJson()});
  }


    String _formatoFecha(DateTime fecha) =>
        "${fecha.year.toString().padLeft(4, '0')}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}";

  Future<List<Historial>> getTodosHistoriales() async {
    final querySnapshot = await _db
      .collection('usuarios')
      .doc(userId)
      .collection('historial')
      .get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      return Historial.fromJson(data);
    }).toList();
  }

}
