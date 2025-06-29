import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nutrition_app/gestiones/historial_gestion.dart';
import 'package:nutrition_app/models/alimento.dart';

class Formulariomanual extends StatefulWidget {
  final bool soloDevolver;
  const Formulariomanual({super.key, this.soloDevolver = false});

  @override
  State<Formulariomanual> createState() => _FormulariomanualState();
}

class _FormulariomanualState extends State<Formulariomanual> {
  final TextEditingController cantidadCtrl = TextEditingController();
  final TextEditingController nombreCtrl = TextEditingController();
  final TextEditingController caloriasCtrl = TextEditingController();
  final TextEditingController proteinasCtrl = TextEditingController();
  final TextEditingController grasasCtrl = TextEditingController();
  final TextEditingController grasasSaturadasCtrl = TextEditingController();
  final TextEditingController hidratosDeCarbonoCtrl = TextEditingController();
  final TextEditingController azucaresCtrl = TextEditingController();
  final TextEditingController fibraCtrl = TextEditingController();
  final TextEditingController salCtrl = TextEditingController();

  final List<String> tiposComida = ['Desayuno', 'Almuerzo', 'Cena', 'Snack'];
  String? tipoSeleccionado;
  final fecha10 = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  void dispose() {
    cantidadCtrl.dispose();
    nombreCtrl.dispose();
    caloriasCtrl.dispose();
    proteinasCtrl.dispose();
    grasasCtrl.dispose();
    grasasSaturadasCtrl.dispose();
    hidratosDeCarbonoCtrl.dispose();
    azucaresCtrl.dispose();
    fibraCtrl.dispose();
    salCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null && !widget.soloDevolver) {
      return Scaffold(
        body: Center(child: Text('No hay usuario autenticado')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Añadir Alimento'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            children: [
              TextFormField(controller: nombreCtrl, decoration: const InputDecoration(labelText: 'Nombre')),
              if (!widget.soloDevolver)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Tipo',
                      border: OutlineInputBorder(),
                    ),
                    value: tipoSeleccionado,
                    items: tiposComida.map((tipo) {
                      return DropdownMenuItem<String>(
                        value: tipo,
                        child: Text(tipo),
                      );
                    }).toList(),
                    onChanged: (nuevoValor) {
                      setState(() {
                        tipoSeleccionado = nuevoValor;
                      });
                    },
                  ),
                ),
              Column(
                children: [
                  TextFormField(controller: cantidadCtrl, decoration: const InputDecoration(labelText: 'Cantidad (g)')),
                  TextFormField(controller: caloriasCtrl, decoration: const InputDecoration(labelText: 'Valor Energetico(Kcal)')),
                  TextFormField(controller: proteinasCtrl, decoration: const InputDecoration(labelText: 'Proteínas (g)')),
                  TextFormField(controller: grasasCtrl, decoration: const InputDecoration(labelText: 'Grasas (g)')),
                  TextFormField(controller: grasasSaturadasCtrl, decoration: const InputDecoration(labelText: 'Grasas saturadas (g)')),
                  TextFormField(controller: hidratosDeCarbonoCtrl, decoration: const InputDecoration(labelText: 'Hidratos de carbono (g)')),
                  TextFormField(controller: azucaresCtrl, decoration: const InputDecoration(labelText: 'Azucares (g)')),
                  TextFormField(controller: fibraCtrl, decoration: const InputDecoration(labelText: 'Fibra(g)')),
                  TextFormField(controller: salCtrl, decoration: const InputDecoration(labelText: 'Sal(g)')),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green.shade300),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.green.shade300,
                      ),
                      child: TextButton(
                        onPressed: () async {
                          final alimento = Alimento(
                            nombre: nombreCtrl.text,
                            cantidad: double.tryParse(cantidadCtrl.text) ?? 0,
                            calorias: double.tryParse(caloriasCtrl.text) ?? 0,
                            proteinas: double.tryParse(proteinasCtrl.text) ?? 0,
                            grasas: double.tryParse(grasasCtrl.text) ?? 0,
                            grasasSaturadas: double.tryParse(grasasSaturadasCtrl.text) ?? 0,
                            hidratosDeCarbono: double.tryParse(hidratosDeCarbonoCtrl.text) ?? 0,
                            azucares: double.tryParse(azucaresCtrl.text) ?? 0,
                            fibra: double.tryParse(fibraCtrl.text) ?? 0,
                            sal: double.tryParse(salCtrl.text) ?? 0,
                            tipoComida: tipoSeleccionado ?? 'ingrediente',
                            fecha: fecha10,
                          );

                          if (widget.soloDevolver) {
                            Navigator.pop(context, alimento);
                          } else {
                            final historialGestion = HistorialGestion(user!.uid);
                            await historialGestion.registroAlimento(
                              fecha: alimento.fecha,
                              alimento: alimento,
                            );
                            await historialGestion.actualizarTotales(alimento.fecha);
                            Navigator.pop(context);
                          }
                        },
                        child: const Text(
                          "Aceptar",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
