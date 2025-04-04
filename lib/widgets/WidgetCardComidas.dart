import 'package:flutter/material.dart';

class WidgetCardConsumido extends StatelessWidget {
  final String nombre;
  final double calorias;
  final double cantidad;
  final int tipoComida;
  
  const WidgetCardConsumido({
    super.key,
    required this.nombre,
    required this.calorias,
    required this.cantidad, 
    required this.tipoComida
    });
    //1=almuerzo,2=desayuno,3=cena,4=snack.
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
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      child: ListTile(
        leading: iconoComida(tipoComida),
        title: Text(
            nombre,
            style: TextStyle(
              fontSize: 18, 
              fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          ),
          subtitle: Text(
            "Calorias: ${calorias} / Cantidad : ${cantidad} g",
            style: TextStyle(
              fontSize: 18, 
              fontWeight: FontWeight.normal),
            textAlign: TextAlign.left,
          ),
          trailing: IconButton(
            icon: Icon(Icons.edit_square),
            onPressed: null,
          ),
      ),
    );
  }
}