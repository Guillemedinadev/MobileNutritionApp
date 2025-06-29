import 'package:flutter/material.dart';

class WidgetCardConsumido extends StatefulWidget {
  final String nombre;
  final double calorias;
  final double cantidad;
  final int tipoComida;
  
  const WidgetCardConsumido({
    super.key,
    required this.nombre,
    required this.calorias,
    required this.cantidad, 
    required this.tipoComida,
    });

  @override
  State<WidgetCardConsumido> createState() => _WidgetCardConsumidoState();
}

class _WidgetCardConsumidoState extends State<WidgetCardConsumido> {
  bool consumido = false;
Icon iconoComida(int index){
  if(index == 1){
    return Icon(Icons.restaurant_menu_rounded);
  }else if(index == 2){
    return Icon(Icons.breakfast_dining_rounded);
  }else if(index == 3){
    return Icon(Icons.nightlight_outlined);
  }else{ return Icon(Icons.cookie_outlined);}
}

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
          leading: Checkbox(
        value: consumido,
        activeColor: Colors.green.shade300,
        onChanged: (bool? valor) {
          setState(() {
            consumido = valor ?? false;
          });
        },
      ),
          title: Text(
              widget.nombre,
              style: TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
            subtitle: Text(
              "Calorias: ${widget.calorias} / Cantidad : ${widget.cantidad} g",
              style: TextStyle(
                fontSize: 14, 
                fontWeight: FontWeight.normal),
              textAlign: TextAlign.left,
            ),
            trailing: PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, size: 30),
              onSelected: (value) {
                switch (value) {
                    case 'eliminar':
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('¿Eliminar comida?'),
                          content: Text('Esta acción no se puede deshacer.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Eliminar', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                      break;
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
              ],
            ),
        ),
      ),
    );
  }
}