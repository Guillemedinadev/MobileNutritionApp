import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nutrition_app/gestiones/historial_gestion.dart';
import 'package:nutrition_app/gestiones/usuario_gestion.dart';
import 'package:nutrition_app/models/historial.dart';
import 'package:nutrition_app/models/plato_planificado.dart';
import 'package:nutrition_app/models/usuario.dart';
import 'package:nutrition_app/widgets/widget_nutrientes.dart';
import 'package:nutrition_app/widgets/widget_progress_bar.dart';

class PantallaHome extends StatefulWidget {
  const PantallaHome({super.key});

  @override
  State<PantallaHome> createState() => _PantallaHomeState();
}

class _PantallaHomeState extends State<PantallaHome> {
  Usuario? usuario;
  Historial? historialHoy;
  bool cargando = true;
  final UsuarioGestion usuarioGestion = UsuarioGestion();
  List<PlatoPlanificado> platosPlanificados = [];
  Set<String> platosSeleccionados = {};

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  Future<void> cargarDatos() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      setState(() {
        cargando = false;
      });
      return;
    }

    usuario = await usuarioGestion.getUsuarioPorId(currentUser.uid);
    if (usuario != null) {
      final gestion = HistorialGestion(usuario!.id!);
      final hoy = DateTime.now();
      historialHoy = await gestion.getHistorialPorFecha(hoy);

      platosPlanificados = await _getPlatosPlanificadosHoy(gestion, hoy);
      platosSeleccionados = historialHoy?.platosConsumidos.map((p) => p.id!).toSet() ?? {};
    }
    setState(() {
      cargando = false;
    });
  }

  Future<List<PlatoPlanificado>> _getPlatosPlanificadosHoy(HistorialGestion gestion, DateTime fecha) async {
    final fechaId = _formatoFecha(fecha);
    final snapshot = await gestion.firestore
        .collection('usuarios')
        .doc(usuario!.id!)
        .collection('planificacion')
        .doc(fechaId)
        .collection('platos')
        .get();

    return snapshot.docs
        .map((doc) => PlatoPlanificado.fromJson(doc.data(), doc.id))
        .toList();
  }

  String _formatoFecha(DateTime fecha) {
    return "${fecha.year.toString().padLeft(4, '0')}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}";
  }

  Future<void> _onCheckboxChanged(bool? valor, PlatoPlanificado plato) async {
    if (usuario == null) return;
    final gestion = HistorialGestion(usuario!.id!);

    if (valor == true) {
      await gestion.registroAlimento(fecha: DateTime.now(), plato: plato);
      platosSeleccionados.add(plato.id!);
    } else {
      await gestion.eliminarRegistroDeHistorial(fecha: DateTime.now(), plato: plato);
      platosSeleccionados.remove(plato.id!);
    }
    historialHoy = await gestion.getHistorialPorFecha(DateTime.now());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (cargando) {
      return const Center(child: CircularProgressIndicator());
    }
    if (usuario == null) {
      return const Center(child: Text("Usuario no encontrado"));
    }
    final caloriasConsumidas = historialHoy?.totales.calorias ?? 0;

    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Calorías consumidas",
                    style: TextStyle(
                        color: Colors.green.shade300,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                  const SizedBox(height: 10),
                  WidgetProgressBar(
                    valor: caloriasConsumidas,
                    maxValor: usuario!.objetivoCalorico.toDouble(),
                    color: Colors.green.shade300,
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    "Información nutricional",
                    style: TextStyle(
                        color: Colors.green.shade300,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                WidgetNutrientes(
                  icon: Icons.bubble_chart,
                  nombre: "Grasas",
                  valor: historialHoy?.totales.grasas ?? 0,
                  color: Colors.pink.shade300,
                ),
                WidgetNutrientes(
                  icon: Icons.bolt,
                  nombre: "Carbohidratos",
                  valor: historialHoy?.totales.hidratosDeCarbono ?? 0,
                  color: Colors.amber.shade300,
                ),
                WidgetNutrientes(
                  icon: Icons.fitness_center,
                  nombre: "Proteinas",
                  valor: historialHoy?.totales.proteinas ?? 0,
                  color: Colors.deepOrange.shade300,
                ),
                WidgetNutrientes(
                  icon: Icons.grain,
                  nombre: "Sal",
                  valor: historialHoy?.totales.sal ?? 0,
                  color: Colors.deepPurple.shade300,
                ),
                WidgetNutrientes(
                  icon: Icons.grass,
                  nombre: "Fibra",
                  valor: historialHoy?.totales.fibra ?? 0,
                  color: Colors.green.shade600,
                ),
                WidgetNutrientes(
                  icon: Icons.bubble_chart_outlined,
                  nombre: "Grasas saturadas",
                  valor: historialHoy?.totales.grasasSaturadas ?? 0,
                  color: Colors.blue.shade300,
                ),
                WidgetNutrientes(
                  icon: Icons.cake,
                  nombre: "Azucar",
                  valor: historialHoy?.totales.azucares ?? 0,
                  color: Colors.red.shade300,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              "Platos planificados para hoy:",
              style: TextStyle(
                  color: Colors.green.shade300,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: platosPlanificados.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final plato = platosPlanificados[index];
                final seleccionado = platosSeleccionados.contains(plato.id);
                return CheckboxListTile(
                  title: Text(plato.nombre),
                  subtitle: Text("${plato.caloriasTotales.toStringAsFixed(0)} kcal"),
                  value: seleccionado,
                  onChanged: (valor) => _onCheckboxChanged(valor, plato),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
