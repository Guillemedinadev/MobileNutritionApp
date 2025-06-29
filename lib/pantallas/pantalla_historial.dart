import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nutrition_app/models/historial.dart';
import 'package:nutrition_app/widgets/widget_historial.dart';


class PantallaHistorial extends StatefulWidget {
  const PantallaHistorial({super.key});

  @override
  State<PantallaHistorial> createState() => _PantallaHistorialState();
}

class _PantallaHistorialState extends State<PantallaHistorial> {
  final String? userId = FirebaseAuth.instance.currentUser?.uid;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  int? selectedmonthIndex = DateTime.now().month - 1; // mes actual

  final List<String> mesdelano = [
    "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio",
    "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"
  ];


  Future<List<Historial>> getHistoriales() async {
    final year = DateTime.now().year; 
    final mes = (selectedmonthIndex ?? DateTime.now().month - 1) + 1;
    final mesStr = mes.toString().padLeft(2, '0');

    final inicio = '$year-$mesStr-01';
    final fin = '$year-$mesStr-31';

    final querySnapshot = await _db
        .collection('usuarios')
        .doc(userId!)
        .collection('historial')
        .where(FieldPath.documentId, isGreaterThanOrEqualTo: inicio)
        .where(FieldPath.documentId, isLessThanOrEqualTo: fin)
        .get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      return Historial.fromJson(data);
    }).toList();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Colors.white,
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    if (selectedmonthIndex != null) {
                      selectedmonthIndex = (selectedmonthIndex! - 1) < 0 ? 11 : selectedmonthIndex! - 1;
                    }
                  });
                },
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.green.shade300,
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    mesdelano[selectedmonthIndex ?? 3],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    if (selectedmonthIndex != null) {
                      selectedmonthIndex = (selectedmonthIndex! + 1) > 11 ? 0 : selectedmonthIndex! + 1;
                    }
                  });
                },
                icon: Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.green.shade300,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Historial>>(
            future: getHistoriales(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final historiales = snapshot.data!;
               return ListView.builder(
                itemCount: historiales.length,
                itemBuilder: (context, index) {
                  final historial = historiales[index];
                    return ListTile(
                      title: WidgetHistorial(
                      fecha: historial.fecha,
                      calorias: historial.totales.calorias,
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Nutrientes del día ${historial.fecha}"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Calorías: ${historial.totales.calorias.toStringAsFixed(2)} kcal"),
                              Text("Proteínas: ${historial.totales.proteinas.toStringAsFixed(2)} g"),
                              Text("Grasas: ${historial.totales.grasas.toStringAsFixed(2)} g"),
                              Text("Grasas Saturadas: ${historial.totales.grasasSaturadas.toStringAsFixed(2)} g"),
                              Text("Hidratos de Carbono: ${historial.totales.hidratosDeCarbono.toStringAsFixed(2)} g"),
                              Text("Azúcares: ${historial.totales.azucares.toStringAsFixed(2)} g"),
                              Text("Fibra: ${historial.totales.fibra.toStringAsFixed(2)} g"),
                              Text("Sal: ${historial.totales.sal.toStringAsFixed(2)} g"),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text("Cerrar"),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
