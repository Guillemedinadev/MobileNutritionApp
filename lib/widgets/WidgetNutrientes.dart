import 'package:flutter/material.dart';

class Widgetnutrientes extends StatelessWidget {
  final String nombre;
  final double cantidad;
  final Color color;

  const Widgetnutrientes(
    {super.key, 
    required this.nombre,
    required this.cantidad,
    required this.color
    });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: color,
                      width: 3
                    )
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${cantidad} g",
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                        ),),
                      Text(
                        nombre,
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                          fontSize: 11
                        ),
                        ),
                    ],
                  ),
                ),
    );
  }
}