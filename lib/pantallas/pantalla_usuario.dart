import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nutrition_app/Subpantallas/pantalla_editar_usuario.dart';
import 'package:nutrition_app/gestiones/usuario_gestion.dart';
import 'package:nutrition_app/models/usuario.dart';

class PantallaUsuario extends StatefulWidget {
  const PantallaUsuario({super.key});

  @override
  State<PantallaUsuario> createState() => _PantallaUsuarioState();
}

class _PantallaUsuarioState extends State<PantallaUsuario> {
  Usuario? usuario;
  final UsuarioGestion usuarioGestion = UsuarioGestion();

  bool cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarUsuarioAutenticado();
  }

  Future<void> _cargarUsuarioAutenticado() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      setState(() {
        cargando = false;
      });
      return;
    }

    Usuario? usuarioCargado = await usuarioGestion.getUsuarioPorId(currentUser.uid);
    setState(() {
      usuario = usuarioCargado;
      cargando = false;
    });
  }

  Widget _buidlinia() {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      height: 2,
      color: Colors.blueGrey[100],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (cargando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (usuario == null) {
      return const Center(child: Text("Usuario no autentificado"));
    }

    return Container(
      padding: const EdgeInsets.all(10),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${usuario!.nombre} ${usuario!.apellido1} ${usuario!.apellido2}",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    usuario!.email,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    usuario!.username,
                    style: TextStyle(
                      color: Colors.green.shade300,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
              const Spacer(),
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  usuario!.imagen.isNotEmpty ? usuario!.imagen : "",
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, size: 100),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () async {
                  final bool? usuarioEditado = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditarUsuario(usuario: usuario!),
                    ),
                  );
                  if (usuarioEditado == true) {
                    await _cargarUsuarioAutenticado();
                  }
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.all(10),
                  foregroundColor: Colors.black,
                ),
                child: const Text(
                  "editar perfil",
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
          _buidlinia(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Objetivo calórico: ${usuario!.objetivoCalorico}",
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.grey),
                tooltip: 'Editar objetivo calórico',
                onPressed: () {
                  double selectedNumber = usuario!.objetivoCalorico.toDouble();
                  showDialog(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(
                        builder: (context, setStateDialog) {
                          return AlertDialog(
                            title: const Text('Selecciona un número'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(selectedNumber.toInt().toString(), style: const TextStyle(fontSize: 24)),
                                Slider(
                                  value: selectedNumber,
                                  min: 500,
                                  max: 3000,
                                  divisions: 250,
                                  label: selectedNumber.toInt().toString(),
                                  onChanged: (newValue) {
                                    setStateDialog(() {
                                      selectedNumber = newValue;
                                    });
                                  },
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Cancelar'),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  await usuarioGestion.actualizarUsuario(
                                    usuario!.id,
                                    'objetivoCalorico',
                                    selectedNumber.toInt(),
                                  );
                                  Navigator.of(context).pop();
                                  await _cargarUsuarioAutenticado();
                                },
                                child: const Text('Aceptar'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
          _buidlinia(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Recordatorio planificación semanal",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              Switch(
                value: usuario!.recordatorioPlanificacion,
                inactiveTrackColor: Colors.grey.shade300,
                activeColor: Colors.green.shade300,
                onChanged: (bool newValue) async {
                  await usuarioGestion.actualizarUsuario(usuario!.id, 'recordatorioPlanificacion', newValue);
                  setState(() {
                    usuario!.recordatorioPlanificacion = newValue;
                  });
                },
              ),
            ],
          ),
          _buidlinia(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Recordatorio registrar comidas",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              Switch(
                value: usuario!.recordatorioComidas,
                inactiveTrackColor: Colors.grey.shade300,
                activeColor: Colors.green.shade300,
                onChanged: (bool newValue) async {
                  await usuarioGestion.actualizarUsuario(usuario!.id, 'recordatorioComidas', newValue);
                  setState(() {
                    usuario!.recordatorioComidas = newValue;
                  });
                },
              ),
            ],
          ),
          _buidlinia(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Aviso al exceder objetivo calórico",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              Switch(
                value: usuario!.avisoExcesoCalorias,
                inactiveTrackColor: Colors.grey.shade300,
                activeColor: Colors.green.shade300,
                onChanged: (bool newValue) async {
                  await usuarioGestion.actualizarUsuario(usuario!.id, 'avisoExcesoCalorias', newValue);
                  setState(() {
                    usuario!.avisoExcesoCalorias = newValue;
                  });
                },
              ),
            ],
          ),
          _buidlinia(),
          ElevatedButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            child: const Text("Cerrar sesión"),
          ),
        ],
      ),
    );
  }
}
