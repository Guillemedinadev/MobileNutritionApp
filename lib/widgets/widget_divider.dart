import 'package:flutter/material.dart';

class WidgetDivider extends StatelessWidget {
  final String nombre;

  const WidgetDivider(
    {super.key, 
    required this.nombre,
    });

  @override
  Widget build(BuildContext context) {
    return 
        /*Expanded(
          flex: 5,
          child:Divider(
            color: Colors.grey.shade500,
            thickness: 2,
          ) 
        ),*/
        Text(nombre,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
            color: Colors.grey.shade500),);
  }
}