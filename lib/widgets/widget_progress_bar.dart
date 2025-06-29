import 'package:flutter/material.dart';

class WidgetProgressBar extends StatelessWidget {
  final double valor;
  final double maxValor;
  final Color color;

  const WidgetProgressBar({super.key, required this.valor, required this.maxValor, required this.color});

  @override
  Widget build(BuildContext context) {
    double progress = (valor / maxValor).clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
      children: [
        SizedBox(width: 8),
        Expanded(
          child: LinearProgressIndicator(
            borderRadius: BorderRadius.circular(4),
              backgroundColor: Colors.grey[300],
              value: progress,
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 10,
            ),
        ),
        SizedBox(width: 8),
        Text("${valor.toInt()}${maxValor > 100 ? ' / ${maxValor.toInt()}' : ''}",style: TextStyle(color: Colors.green),),
      ],
    ),
    );
  }
}