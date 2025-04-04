import 'package:flutter/material.dart';
import 'package:nutrition_app/widgets/WidgetCardComidas.dart';
import 'package:nutrition_app/widgets/WidgetNutrientes.dart';
import 'package:nutrition_app/widgets/WidgetProgressBar.dart';

class PantallaHome extends StatelessWidget {
  const PantallaHome({super.key});

  @override
  Widget build(BuildContext context) {
    //Placeholders, cambiar a futuro-----------------------------------
    List<Map<String, dynamic>> consumidos = [
      {"nombre": "Tortilla de patatas", "calorias":500.0,"cantidad": 200.0,"tipoComida":1},
      {"nombre": "Cereales", "calorias":600.0,"cantidad": 200.0, "tipoComida":2},
      {"nombre": "Ensalada Cesar", "calorias":300.0,"cantidad": 400.0, "tipoComida":3},
      {"nombre": "Palomitas", "calorias":800.0,"cantidad": 500.0, "tipoComida":4},
      {"nombre": "Tortilla de patatas", "calorias":500.0,"cantidad": 200.0,"tipoComida":1},
      {"nombre": "Cereales", "calorias":600.0,"cantidad": 200.0, "tipoComida":2},
      {"nombre": "Ensalada Cesar", "calorias":300.0,"cantidad": 400.0, "tipoComida":3},
      {"nombre": "Palomitas", "calorias":800.0,"cantidad": 500.0, "tipoComida":4},
    ];
    //-----------------------------------------------------------------
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Objetivo calórico
          Container(
            color: Colors.white,
            child: Column(
              children: [
                Text(
                  "Objetivo calórico :  ${1800}",
                  style: TextStyle(
                    color: Colors.green.shade300,
                    fontWeight: FontWeight.bold,
                     fontSize: 15),
                ),
                SizedBox(height: 10),
                WidgetProgressBar(
                  valor: 600,
                  maxValor: 1800,
                  color: Colors.green.shade300,
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          //Muestra de información nutricional
          Text(
            "Información nutricional",
            style: TextStyle(
              color: Colors.green.shade300,
              fontSize: 18, 
              fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Widgetnutrientes(nombre: "Grasas", cantidad: 9.9, color: Colors.pink.shade300),
              SizedBox(width: 3),
              Widgetnutrientes(nombre: "Carbohidratos", cantidad: 9.9, color: Colors.cyan.shade300),
              SizedBox(width: 3),
              Widgetnutrientes(nombre: "Proteinas", cantidad: 9.9, color: Colors.deepOrange.shade300),
              SizedBox(width: 3),
              Widgetnutrientes(nombre: "Sal", cantidad: 9.9, color: Colors.deepPurple.shade300),
              SizedBox(width: 3),
            ],
          ),
          SizedBox(height: 10),
          //Boton desplegable de informacion vitaminas
          Container(
            decoration: ShapeDecoration(
              shape: StadiumBorder(),
              color: Colors.green.shade300
            ),
            padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  " Vitaminas y minerales",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18, 
                    fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                    ),
                ]
              ),
          ),
          SizedBox(height: 10),
          //Registro de comidas consumidas diario
          Text(
            " Diario de comidas:",
            style: TextStyle(
              color: Colors.green.shade300,
              fontSize: 18, 
              fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 10),
          Expanded(
            child: Container(
              color: Colors.transparent,
              child: ListView.builder(
                itemCount: consumidos.length,
                itemBuilder: (context,index){
                  return WidgetCardConsumido(
                  nombre: consumidos[index]["nombre"],
                   calorias: consumidos[index]["calorias"], 
                   cantidad: consumidos[index]["cantidad"],
                   tipoComida: consumidos[index]["tipoComida"]
                   );
                },
              ),
            )
          ),  
        ],
      ),
    );
  }
}
