import 'package:flutter/material.dart';
import 'package:nutrition_app/Subpantallas/pantalla_crear_plato.dart';
import 'package:nutrition_app/gestiones/usuario_gestion.dart';
import 'package:nutrition_app/models/usuario.dart';
import 'package:nutrition_app/multi_date_picker.dart';
import 'package:nutrition_app/widgets/widget_card_planificacion.dart';
import 'package:nutrition_app/widgets/widget_divider.dart';
import 'package:nutrition_app/widgets/widget_progress_bar.dart';
import 'package:nutrition_app/gestiones/planificacion_gestion.dart';
import 'package:nutrition_app/models/plato_planificado.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PantallaPlanificacion extends StatefulWidget {
  const PantallaPlanificacion({super.key});

  @override
  State<PantallaPlanificacion> createState() => _PantallaPlanificacionState();
}

class _PantallaPlanificacionState extends State<PantallaPlanificacion> {
  DateTime fechaSeleccionada = DateTime.now();
  final UsuarioGestion usuarioGestion = UsuarioGestion();
  PlanificacionGestion? gestion;
  Usuario? usuario;
  List<PlatoPlanificado> platos = [];
  bool cargando = true;
  bool copiando = false;

  @override
  void initState() {
    super.initState();
    _inicializarUsuarioYGestion();
  }

  Future<void> _inicializarUsuarioYGestion() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      if (!mounted) return;
      setState(() {
        cargando = false;
      });
      return;
    }
    gestion = PlanificacionGestion(currentUser.uid);
    final resultado = await usuarioGestion.getUsuarioPorId(currentUser.uid);
    setState(() {
      usuario = resultado;
    });
    await _cargarPlatos();
    setState(() {
      cargando = false;
    });
  }

  Future<void> _cargarPlatos() async {
    if (gestion == null) return;
    final resultado = await gestion!.obtenerPlatosDeFecha(fechaSeleccionada);
    setState(() {
      platos = resultado;
    });
  }

  Future<void> _crearPlato([String? tipoComida]) async {
    final platoCreado = await Navigator.push<PlatoPlanificado>(
      context,
      MaterialPageRoute(
        builder: (_) => CrearPlatoPantalla(
          fechaSeleccionada: fechaSeleccionada,
          tipoComidaInicial: tipoComida,
        ),
      ),
    );
    if (platoCreado != null) {
      await gestion?.actualizarPlato(platoCreado);
      _cargarPlatos();
    }
  }

  String formatFecha(DateTime date) {
    final dias = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
    final meses = [
      'Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio',
      'Agosto','Septiembre','Octubre','Noviembre','Diciembre'
    ];
    return '${dias[date.weekday - 1]} ${date.day} de ${meses[date.month - 1]}';
  }

  List<PlatoPlanificado> _filtrarPorTipo(String tipo) {
    return platos.where((p) => p.tipoComida.toLowerCase() == tipo.toLowerCase()).toList();
  }

  Widget _seccionComida(String nombreTipo) {
    final lista = _filtrarPorTipo(nombreTipo);
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: WidgetDivider(nombre: nombreTipo)),
          ],
        ),
        ...lista.map(
          (plato) => WidgetCardPlanificacion(
            nombre: plato.nombre,
            calorias: plato.caloriasTotales,
            cantidad: plato.cantidadTotal,
            onEditar: () async {
              final editado = await Navigator.push<PlatoPlanificado>(
                context,
                MaterialPageRoute(
                  builder: (_) => CrearPlatoPantalla(
                    fechaSeleccionada: fechaSeleccionada,
                    tipoComidaInicial: plato.tipoComida,
                    platoExistente: plato,
                  ),
                ),
              );
              if (editado != null) {
                await gestion?.actualizarPlato(editado);
                _cargarPlatos();
              }
            },
            onEliminar: () async {
              if (plato.id != null) {
                await gestion?.eliminarPlato(plato);
                _cargarPlatos();
              }
            },
          ),
        ),
      ],
    );
  }

  Future<void> _seleccionarFechasYCopiarPlanificacion() async {
    final fechasSeleccionadas = await showDialog<List<DateTime>>(
      context: context,
      builder: (context) {
        final Set<DateTime> fechas = {};
        return AlertDialog(
          title: Text('Selecciona las fechas'),
          content: Container(
            height: 400,
            width: 300,
            child: MultiDatePicker(
              onChanged: (seleccionadas) {
                fechas.clear();
                fechas.addAll(seleccionadas);
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(fechas.toList()),
              child: Text('Confirmar'),
            ),
          ],
        );
      },
    );
    if (fechasSeleccionadas == null || fechasSeleccionadas.isEmpty) {
      return;
    }
    setState(() {
      copiando = true;
    });
    try {
      await gestion?.copiarPlatosADias(fechasSeleccionadas, platos);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Planificación copiada a ${fechasSeleccionadas.length} días')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error copiando la planificación: $e')),
      );
    } finally {
      setState(() {
        copiando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (cargando) {
      return const Center(child: CircularProgressIndicator());
    }
    if (usuario == null) {
      return const Center(child: Text("Usuario no autentificado"));
    }
    return Column(
      children: [
        Container(
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  formatFecha(fechaSeleccionada),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
              IconButton(
                onPressed: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: fechaSeleccionada,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null && picked != fechaSeleccionada) {
                    setState(() {
                      fechaSeleccionada = picked;
                    });
                    await _cargarPlatos();
                  }
                },
                icon: Icon(Icons.calendar_today, color: Colors.green.shade300),
              ),
            ],
          ),
        ),
        Container(
          color: Colors.white,
          child: Column(
            children: [
              Text(
                "Calorías planificadas:",
                style: TextStyle(
                  color: Colors.green.shade300,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 5),
              WidgetProgressBar(
                valor: platos.fold(0, (suma, p) => suma + p.caloriasTotales),
                maxValor: usuario?.objetivoCalorico.toDouble() ?? 1800.0,
                color: Colors.green.shade300,
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Planifica tu dieta",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: copiando
                        ? CircularProgressIndicator(color: Colors.green)
                        : Icon(Icons.repeat_rounded, color: Colors.green),
                    onPressed: copiando ? null : _seleccionarFechasYCopiarPlanificacion,
                  ),
                ],
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _seccionComida("Desayuno"),
                  _seccionComida("Almuerzo"),
                  _seccionComida("Cena"),
                  _seccionComida("Snack"),
                ],
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(12),
          child: ElevatedButton.icon(
            icon: Icon(Icons.add_rounded, color: Colors.white),
            label: Text("Añadir alimento", style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade400,
              minimumSize: Size(double.infinity, 48),
            ),
            onPressed: () => _crearPlato(null),
          ),
        ),
      ],
    );
  }
}
