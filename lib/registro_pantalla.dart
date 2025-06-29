import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nutrition_app/gestiones/usuario_gestion.dart';
import 'package:nutrition_app/models/usuario.dart';

class RegistroPantalla extends StatefulWidget {
  const RegistroPantalla({super.key});

  @override
  _RegistroPantallaState createState() => _RegistroPantallaState();
}

class _RegistroPantallaState extends State<RegistroPantalla> {
  final _auth = FirebaseAuth.instance;
  final _nombreController = TextEditingController();
  final _usernameController = TextEditingController();
  final _apellido1Controller = TextEditingController();
  final _apellido2Controller = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _objetivoCaloricoController = TextEditingController();
  File? _imagenPerfil;

  Future<void> _seleccionarImagen() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _imagenPerfil = File(picked.path));
    }
  }

  Future<void> _registrarUsuario() async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      final uid = cred.user!.uid;
      String urlImagen = '';

      if (_imagenPerfil != null) {
        final ref = FirebaseStorage.instance.ref().child('perfil/$uid.jpg');
        await ref.putFile(_imagenPerfil!);
        urlImagen = await ref.getDownloadURL();
      }

      final usuario = Usuario(
        id: uid,
        nombre: _nombreController.text.trim(),
        username: _usernameController.text.trim(),
        apellido1: _apellido1Controller.text.trim(),
        apellido2: _apellido2Controller.text.trim(),
        email: _emailController.text.trim(),
        objetivoCalorico: num.tryParse(_objetivoCaloricoController.text) ?? 2000,
        recordatorioComidas: false,
        recordatorioPlanificacion: false,
        avisoExcesoCalorias: false,
        imagen: urlImagen,
      );

      await UsuarioGestion().crearUsuario(usuario);
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/Inicio',
        (Route<dynamic> route) => false,
      );

    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Error desconocido')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registro')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: _seleccionarImagen,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _imagenPerfil != null ? FileImage(_imagenPerfil!) : null,
                child: _imagenPerfil == null ? Icon(Icons.add_a_photo) : null,
              ),
            ),
            TextField(controller: _nombreController, decoration: InputDecoration(labelText: 'Nombre')),
            TextField(controller: _usernameController, decoration: InputDecoration(labelText: 'Usuario')),
            TextField(controller: _apellido1Controller, decoration: InputDecoration(labelText: 'Primer Apellido')),
            TextField(controller: _apellido2Controller, decoration: InputDecoration(labelText: 'Segundo Apellido (opcional)')),
            TextField(
              controller: _objetivoCaloricoController,
              decoration: InputDecoration(labelText: 'Objetivo Calórico'),
              keyboardType: TextInputType.number,
            ),
            TextField(controller: _emailController, decoration: InputDecoration(labelText: 'Correo')),
            TextField(controller: _passwordController, decoration: InputDecoration(labelText: 'Contraseña'), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _registrarUsuario, child: Text('Registrarse')),
          ],
        ),
      ),
    );
  }
}
