import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nutrition_app/Subpantallas/formulario_manual.dart';
import 'package:nutrition_app/gestiones/planificacion_gestion.dart';
import 'package:nutrition_app/models/alimento.dart';
import 'package:nutrition_app/models/plato_planificado.dart';

class CrearPlatoPantalla extends StatefulWidget {
  final DateTime fechaSeleccionada;
  final String? tipoComidaInicial;
  final PlatoPlanificado? platoExistente;

  const CrearPlatoPantalla({
    super.key,
    required this.fechaSeleccionada,
    this.tipoComidaInicial,
    this.platoExistente,
  });

  @override
  State<CrearPlatoPantalla> createState() => _CrearPlatoPantallaState();
}

class _CrearPlatoPantallaState extends State<CrearPlatoPantalla> {
  final TextEditingController nombrePlatoCtrl = TextEditingController();
  final List<Alimento> alimentos = [];
  String? tipoComidaSeleccionada;
  late DateTime fechaSeleccionada;

  final List<String> tiposComida = ['desayuno', 'almuerzo', 'cena', 'snack'];

  @override
  void initState() {
    super.initState();
    fechaSeleccionada = widget.fechaSeleccionada;
    tipoComidaSeleccionada = widget.tipoComidaInicial;
  }

  void _abrirFormularioAlimento() async {
    final Alimento? nuevoAlimento = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Formulariomanual(soloDevolver: true),
      ),
    );

    if (nuevoAlimento != null) {
      setState(() {
        alimentos.add(nuevoAlimento);
      });
    }
  }

  void _guardarPlato() async {
    if (nombrePlatoCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Introduce un nombre para el plato')),
      );
      return;
    }
    if (tipoComidaSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona el tipo de comida')),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario no autentificado')),
      );
      return;
    }

    final nuevoPlato = PlatoPlanificado(
      nombre: nombrePlatoCtrl.text,
      tipoComida: tipoComidaSeleccionada!,
      fecha: fechaSeleccionada,
      alimentos: alimentos,
    );

    final gestion = PlanificacionGestion(user.uid);
    await gestion.agregarPlato(nuevoPlato);
    Navigator.pop(context, nuevoPlato);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear plato')),
      body: Column(
        children: [
          TextFormField(
            controller: nombrePlatoCtrl,
            decoration: const InputDecoration(labelText: 'Nombre del plato'),
          ),
          DropdownButton<String>(
            hint: const Text('Selecciona tipo de comida'),
            value: tipoComidaSeleccionada,
            items: tiposComida
                .map((tipo) => DropdownMenuItem(value: tipo, child: Text(tipo)))
                .toList(),
            onChanged: (value) {
              setState(() {
                tipoComidaSeleccionada = value;
              });
            },
          ),
          ElevatedButton(onPressed: _abrirFormularioAlimento, child: const Text('Añadir alimento')),
          Expanded(
            child: ListView.builder(
              itemCount: alimentos.length,
              itemBuilder: (_, index) => ListTile(
                title: Text(alimentos[index].nombre),
                subtitle: Text('${alimentos[index].cantidad} g'),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _guardarPlato,
            child: const Text('Guardar plato'),
          ),
        ],
      ),
    );
  }
}
