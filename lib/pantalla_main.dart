import 'package:flutter/material.dart';
import 'package:nutrition_app/Subpantallas/formulario_manual.dart';
import 'package:nutrition_app/imagen.dart';
import 'pantallas/pantalla_home.dart';
import 'pantallas/pantalla_usuario.dart';
import 'pantallas/pantalla_planificacion.dart';
import 'pantallas/pantalla_historial.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:firebase_auth/firebase_auth.dart';

final fecha = DateTime.now().toIso8601String().split('T')[0];

class PantallaMain extends StatefulWidget {
  const PantallaMain({super.key});

  @override
  State<PantallaMain> createState() => _PantallaMainState();
}

class _PantallaMainState extends State<PantallaMain> {
  int _selectedIndex = 0;
  late String userId;

  final List<Widget> _pantallas = [
    PantallaPlanificacion(),
    PantallaHistorial(),
    PantallaHome(),
    PantallaUsuario()
  ];

  final List<String> _titulos = [
    "Planificación",
    "Historial",
    "Inicio",
    "Usuario"
  ];

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    userId = user?.uid ?? '';
  }

  void _pulsarItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(_titulos[_selectedIndex]),
        titleTextStyle: TextStyle(
          color: Colors.green,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Colors.white,
      ),
      floatingActionButton: _selectedIndex != 2
          ? null
          : SpeedDial(
              animatedIcon: AnimatedIcons.add_event,
              backgroundColor: Colors.green.shade300,
              foregroundColor: Colors.white,
              children: [
                SpeedDialChild(
                  child: Icon(Icons.photo_camera_outlined),
                  label: 'Escanear comida',
                  onTap: () => seleccionarYProcesarImagen(
                    context: context,
                    userId: userId,
                    tipo: 'comida',
                    fecha: fecha,
                  ),
                ),
                SpeedDialChild(
                  child: Icon(Icons.document_scanner_rounded),
                  label: 'Escanear etiqueta',
                  onTap: () => seleccionarYProcesarImagen(
                    context: context,
                    userId: userId,
                    tipo: 'etiqueta',
                    fecha: fecha,
                  ),
                ),
                SpeedDialChild(
                  child: Icon(Icons.edit_note_rounded),
                  label: 'Formulario manual',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          Formulariomanual(soloDevolver: false),
                    ),
                  ),
                ),
              ],
            ),
      body: _pantallas[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedLabelStyle:
            TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
        onTap: _pulsarItem,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey.shade400,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: "Planificación"),
          BottomNavigationBarItem(
              icon: Icon(Icons.history), label: "Historial"),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Usuario"),
        ],
      ),
    );
  }
}
