import 'package:flutter/material.dart';
import 'pantallas/PantallaHome.dart';
import 'pantallas/PantallaUsuario.dart';
import 'pantallas/PantallaAnadirAlimentos.dart';
import 'pantallas/PantallaPlanificacion.dart';
import 'pantallas/PantallaHistorial.dart';

class PantallaMain extends StatefulWidget {
  const PantallaMain({super.key});

  @override
  State<PantallaMain> createState() => _PantallaMainState();
}

class _PantallaMainState extends State<PantallaMain> {

  int _selectedIndex = 0;
  final List<Widget> _pantallas=[
    PantallaPlanificacion(),
    PantallaHistorial(),
    PantallaAnadirAlimentos(),
    PantallaHome(),
    PantallaUsuario()
  ];
  final List<String> _titulos=[
    "Planificación",
    "Historial",
    "Añadir Alimentos",
    "Inicio",
    "Usuario"
  ];

void _pulsarItem(int index){
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
        titleTextStyle: TextStyle(color: Colors.green,fontSize: 25,fontWeight: FontWeight.bold),
        backgroundColor: Colors.white,
      ),
      floatingActionButton: _selectedIndex!=3?null:FloatingActionButton(child: Text('+'),onPressed: () {}),
      body: _pantallas[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.green),
        onTap: _pulsarItem,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey.shade400,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Planificación",backgroundColor: Colors.white),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "Historial",backgroundColor: Colors.white),
          BottomNavigationBarItem(icon: Icon(Icons.add_box_outlined), label: "Añadir Alimentos",backgroundColor: Colors.white),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio",backgroundColor: Colors.white),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Usuario",backgroundColor: Colors.white),
        ]
      ),
    );
  }
}