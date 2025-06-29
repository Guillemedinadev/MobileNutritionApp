import 'package:flutter/material.dart';

class WidgetCardPlanificacion extends StatelessWidget {
  final String nombre;
  final double calorias;
  final double cantidad;
  
  final VoidCallback? onEditar;
  final VoidCallback? onEliminar;

  const WidgetCardPlanificacion({
    super.key,
    required this.nombre,
    required this.calorias,
    required this.cantidad,
    this.onEditar,
    this.onEliminar,
    });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
        child: ListTile(
          title: Text(
              nombre,
              style: TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
            subtitle: Text(
              "Calorias: $calorias / Cantidad : $cantidad g",
              style: TextStyle(
                fontSize: 14, 
                fontWeight: FontWeight.normal),
              textAlign: TextAlign.left,
            ),
            trailing: PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, size: 30),
              onSelected: (value) {
                if (value == 'editar') {
                  onEditar?.call();
                } else if (value == 'eliminar') {
                  onEliminar?.call();
                }
              },
              itemBuilder: (BuildContext context) => [
                PopupMenuItem(
                  value: 'editar',
                  child: ListTile(
                    leading: Icon(Icons.edit, color: Colors.green),
                    title: Text('Editar'),
                  ),
                ),
                PopupMenuItem(
                  value: 'eliminar',
                  child: ListTile(
                    leading: Icon(Icons.delete, color: Colors.green),
                    title: Text('Eliminar'),
                  ),
                ),
                /*PopupMenuItem(
                  value: 'repetir',
                  child: ListTile(
                    leading: Icon(Icons.repeat, color: Colors.green),
                    title: Text('Repetir'),
                  ),
                ),*/
              ],
            ),
        ),
      ),
    );
  }
}