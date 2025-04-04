import 'package:flutter/material.dart';

class WidgetCardPlanificacion extends StatefulWidget {
  final String nombre;
  final double calorias;
  final double cantidad;
  final int tipoComida;
  final bool consumido;
  
   WidgetCardPlanificacion({
    super.key,
    required this.nombre,
    required this.calorias,
    required this.cantidad, 
    required this.tipoComida,
    required this.consumido
    });

  @override
  State<WidgetCardPlanificacion> createState() => _WidgetCardPlanificacionState();
}

class _WidgetCardPlanificacionState extends State<WidgetCardPlanificacion> {
  late bool consumido;

  @override
  void initState() {
    super.initState();
    consumido = widget.consumido;
  }
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
        leading: Checkbox(
        value: consumido,
        activeColor: Colors.green.shade300,
        onChanged: (bool? valor) {
          setState(() {
            consumido = valor ?? false;
          });
        },
      ),//iconoComida(tipoComida),
        title: Row(
          children: [
            Text(
                widget.nombre,
                style: TextStyle(
                  fontSize: 18, 
                  fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              iconoComida(widget.tipoComida)
          ],
        ),
          subtitle: Text(
            "Calorias: ${widget.calorias} / Cantidad : ${widget.cantidad} g",
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