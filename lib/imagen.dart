import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;

Future<void> seleccionarYProcesarImagen({
  required BuildContext context,
  required String userId,
  required String tipo,
  required String fecha,
}) async {
  final ImageSource? source = await showModalBottomSheet<ImageSource>(
    context: context,
    builder: (_) {
      return SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Tomar Foto'),
              onTap: () => Navigator.of(context).pop(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Elegir de la Galería'),
              onTap: () => Navigator.of(context).pop(ImageSource.gallery),
            ),
          ],
        ),
      );
    },
  );

  if (source == null) return;

  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: source);
  if (pickedFile == null) return;

  final File imageFile = File(pickedFile.path);
  final String fileName = 'captura_${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
  final storageRef = FirebaseStorage.instance.ref().child('capturas/$fileName');

  await storageRef.putFile(imageFile, SettableMetadata(contentType: 'image/jpeg'));
  final String downloadUrl = await storageRef.getDownloadURL();

  final resultado = await procesarImagenEnCloud(downloadUrl, tipo, userId, fecha);

  if (resultado != null && context.mounted) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(tipo == 'comida' ? 'Valores Nutricionales' : 'Datos de Etiqueta'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: resultado.entries.map((e) => Text('${e.key}: ${e.value}')).toList(),
        ),
        actions: [
          TextButton(
            child: const Text("Cerrar"),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }
}

Future<Map<String, dynamic>?> procesarImagenEnCloud(
    String imageUrl, String tipo, String userId, String fecha) async {
  final url = Uri.parse('https://us-central1-nutritionapplication-23b5c.cloudfunctions.net/procesarComida');
  final body = jsonEncode({'userId': userId, 'imageUrl': imageUrl, 'tipo': tipo,'fecha': fecha,});
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: body,
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['data'] as Map<String, dynamic>?;
  } else {
    print('Error en la solicitud: ${response.statusCode} - ${response.body}');
    return null;
  }
}
