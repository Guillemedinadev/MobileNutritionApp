import 'package:flutter/material.dart';
import 'package:nutrition_app/widgets/WidgetCardPlanificacion.dart';

class PantallaPlanificacion extends StatefulWidget {
  const PantallaPlanificacion({super.key});

  @override
  State<PantallaPlanificacion> createState() => _PantallaPlanificacionState();
}

//Placeholders, cambiar a futuro-----------------------------------
List<Map<String, dynamic>> consumidos = [
  {"nombre": "Tortilla de patatas", "calorias": 500.0, "cantidad": 200.0, "tipoComida": 1, "consumido": false},
  {"nombre": "Cereales", "calorias": 600.0, "cantidad": 200.0, "tipoComida": 2, "consumido": false},
  {"nombre": "Ensalada Cesar", "calorias": 300.0, "cantidad": 400.0, "tipoComida": 3, "consumido": false},
  {"nombre": "Palomitas", "calorias": 800.0, "cantidad": 500.0, "tipoComida": 4, "consumido": false},
  {"nombre": "Tortilla de patatas", "calorias": 500.0, "cantidad": 200.0, "tipoComida": 1, "consumido": false},
  {"nombre": "Cereales", "calorias": 600.0, "cantidad": 200.0, "tipoComida": 2, "consumido": false},
  {"nombre": "Ensalada Cesar", "calorias": 300.0, "cantidad": 400.0, "tipoComida": 3, "consumido": false},
  {"nombre": "Palomitas", "calorias": 800.0, "cantidad": 500.0, "tipoComida": 4, "consumido": false},
];
//-----------------------------------------------------------------
class _PantallaPlanificacionState extends State<PantallaPlanificacion> {
  int? selectedDayIndex;

  @override
  Widget build(BuildContext context) {
    DateTime fechaActual = DateTime.now();
    int month = fechaActual.month;
    int year = fechaActual.year;
    int dayofweek = fechaActual.weekday;

    List<String> daytext = ["Lun", "Mar", "Mier", "Jue", "Vie", "Sab", "Dom"];
    List<String> monthtext = [
      "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio",
      "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"
    ];

    String monthToString(int month) {
      return monthtext[month - 1];
    }

    List<int> diasDeLaSemanaActual = List.generate(7, (index) {
      int difference = index - (dayofweek - 1);
      DateTime dayOfWeekDate = fechaActual.add(Duration(days: difference));
      return dayOfWeekDate.day;
    });

    Widget weekdisplay(int index, int daydisplay) {
      bool isSelected = selectedDayIndex == index;
      return GestureDetector(
        onTap: () {
          setState(() {
            selectedDayIndex = index;
          });
        },
        child: Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isSelected ? Colors.green.shade300 : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? Colors.green.shade300 : Colors.grey.shade400,
              width: 3,
            ),
          ),
          child: Column(
            children: [
              Text(
                "${daytext[index]}",
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Text(
                "$daydisplay",
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Aseguramos que la pantalla inicie con el día actual seleccionado
    if (selectedDayIndex == null) {
      selectedDayIndex = dayofweek - 1; // Seleccionamos el día actual por defecto
    }

    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Muestra mes actual y año
          Container(
            color: Colors.white,
            child: Text(
              "${monthToString(month)} ${year}",
              style: TextStyle(
                  color: Colors.green.shade300,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              weekdisplay(0, diasDeLaSemanaActual[0]),
              weekdisplay(1, diasDeLaSemanaActual[1]),
              weekdisplay(2, diasDeLaSemanaActual[2]),
              weekdisplay(3, diasDeLaSemanaActual[3]),
              weekdisplay(4, diasDeLaSemanaActual[4]),
              weekdisplay(5, diasDeLaSemanaActual[5]),
              weekdisplay(6, diasDeLaSemanaActual[6]),
            ],
          ),
          SizedBox(height: 10),
          Expanded(
            child: Container(
              color: Colors.transparent,
              child: ListView.builder(
                itemCount: consumidos.length,
                itemBuilder: (context, index) {
                  return WidgetCardPlanificacion(
                      nombre: consumidos[index]["nombre"],
                      calorias: consumidos[index]["calorias"],
                      cantidad: consumidos[index]["cantidad"],
                      tipoComida: consumidos[index]["tipoComida"],
                      consumido: consumidos[index]["consumido"]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
