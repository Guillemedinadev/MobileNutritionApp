import 'package:flutter/material.dart';

class WidgetHistorial extends StatefulWidget {
  final String fecha;
  final double calorias;

  const WidgetHistorial(
    {super.key, 
    required this.fecha,
    required this.calorias,
    });

  @override
  State<WidgetHistorial> createState() => _WidgetHistorialState();
}

class _WidgetHistorialState extends State<WidgetHistorial> {

Color color1 = Colors.green.shade300; 
Color color2 = Colors.red.shade400; 
  @override
Widget build(BuildContext context) {
  return Card(
    color: Colors.white,
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Text(
            widget.fecha,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          Text(
            "${widget.calorias.toStringAsFixed(0)} Kcal",
            style: TextStyle(
              color: widget.calorias > 1800 ? color2 : color1,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}

}