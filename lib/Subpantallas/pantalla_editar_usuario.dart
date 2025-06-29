import 'package:flutter/material.dart';
import 'package:nutrition_app/models/usuario.dart';
import 'package:nutrition_app/gestiones/usuario_gestion.dart';

class EditarUsuario extends StatefulWidget {
  final Usuario usuario;

  const EditarUsuario({super.key, required this.usuario});

  @override
  State<EditarUsuario> createState() => _EditarUsuarioState();
}

class _EditarUsuarioState extends State<EditarUsuario> {
  final _formKey = GlobalKey<FormState>();
  late Usuario _usuarioEditable;
  final UsuarioGestion usuarioGestion = UsuarioGestion();

  @override
  void initState() {
    super.initState();
    _usuarioEditable = Usuario(
      id: widget.usuario.id,
      nombre: widget.usuario.nombre,
      username: widget.usuario.username,
      apellido1: widget.usuario.apellido1,
      apellido2: widget.usuario.apellido2,
      email: widget.usuario.email,
      imagen: widget.usuario.imagen,
      objetivoCalorico: widget.usuario.objetivoCalorico,
      recordatorioComidas: widget.usuario.recordatorioComidas,
      recordatorioPlanificacion: widget.usuario.recordatorioPlanificacion,
      avisoExcesoCalorias: widget.usuario.avisoExcesoCalorias,
    );
  }

  Future<void> _guardarCambios() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      await usuarioGestion.actualizarUsuario(_usuarioEditable.id, 'nombre', _usuarioEditable.nombre);
      await usuarioGestion.actualizarUsuario(_usuarioEditable.id, 'username', _usuarioEditable.username);
      await usuarioGestion.actualizarUsuario(_usuarioEditable.id, 'apellido1', _usuarioEditable.apellido1);
      await usuarioGestion.actualizarUsuario(_usuarioEditable.id, 'apellido2', _usuarioEditable.apellido2);
      await usuarioGestion.actualizarUsuario(_usuarioEditable.id, 'email', _usuarioEditable.email);

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Editar perfil")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _usuarioEditable.nombre,
                decoration: const InputDecoration(labelText: 'Nombre'),
                onSaved: (value) => _usuarioEditable.nombre = value ?? '',
              ),
              TextFormField(
                initialValue: _usuarioEditable.username,
                decoration: const InputDecoration(labelText: 'Username'),
                onSaved: (value) => _usuarioEditable.username = value ?? '',
              ),
              TextFormField(
                initialValue: _usuarioEditable.apellido1,
                decoration: const InputDecoration(labelText: 'Apellido 1'),
                onSaved: (value) => _usuarioEditable.apellido1 = value ?? '',
              ),
              TextFormField(
                initialValue: _usuarioEditable.apellido2,
                decoration: const InputDecoration(labelText: 'Apellido 2'),
                onSaved: (value) => _usuarioEditable.apellido2 = value ?? '',
              ),
              TextFormField(
                initialValue: _usuarioEditable.email,
                decoration: const InputDecoration(labelText: 'Email'),
                onSaved: (value) => _usuarioEditable.email = value ?? '',
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _guardarCambios,
                child: const Text('Guardar'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
