import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PantallaLogin extends StatefulWidget {
  @override
  _PantallaLoginState createState() => _PantallaLoginState();
}

class _PantallaLoginState extends State<PantallaLogin> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _esRegistro = false;

  Future<void> _autenticarUsuario() async {
    try {
      final auth = FirebaseAuth.instance;
      if (_esRegistro) {
        await auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      } else {
        await auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_esRegistro ? "Registro" : "Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _emailController, decoration: InputDecoration(labelText: "Correo")),
            TextField(controller: _passwordController, obscureText: true, decoration: InputDecoration(labelText: "Contraseña")),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _autenticarUsuario,
              child: Text(_esRegistro ? "Registrarse" : "Iniciar sesión"),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/Registro'),
              child: Text("¿No tienes cuenta? Regístrate"),
            ),

          ],
        ),
      ),
    );
  }
}
