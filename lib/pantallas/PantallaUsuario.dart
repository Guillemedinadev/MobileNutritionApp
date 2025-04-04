import 'package:flutter/material.dart';

class PantallaUsuario extends StatefulWidget {
  const PantallaUsuario({super.key});

  @override
  State<PantallaUsuario> createState() => _PantallaUsuarioState();
}

class _PantallaUsuarioState extends State<PantallaUsuario> {
  final String nombre = "Nombre", username = "@Username", apellido1 = "Apelllido01", apellido2 = "Apelllido02", email = "usuario@gmail.com";

  final int telefono = 666666666;

bool switch01 = false;
bool switch02 = false;
bool switch03 = false;
double objetivo = 1800.0;

Widget _buidlinia() {
  return Container(
    margin: const EdgeInsets.only(
      top: 10,
      bottom: 10,
    ),
    height: 2,
    color: Colors.blueGrey[100],
  );
}

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.green.shade300,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Icon(Icons.person, size: 80, color: Colors.grey.shade300),
                  ),
                  SizedBox(height: 5),
                  Text(
                        username,
                        style: TextStyle(
                          color: Colors.green.shade300,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                ],
              ),
            ],
          ),
          SizedBox(height: 30),
          Text(
            " Nombre: ${nombre}",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 2),
          Text(
            " Apellidos: ${apellido1} ${apellido2}",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 2),
          Text(
            " Email: ${email}",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 2),
          Text(
            " Telefono: ${telefono.toString()}",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Text("editar",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                ),
              ),
            ],
          ),
          _buidlinia(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Objetivo calorico: ${objetivo}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                ),Container(

                    child: Icon(Icons.edit_square,color: Colors.grey.shade300,size: 30),
                  ),
            ],
          ),
          _buidlinia(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Recordatorio planificacion semanal",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                ),
                Switch(
                  value: switch01,
                  inactiveTrackColor: Colors.grey.shade300,
                  activeColor: Colors.green.shade300, 
                  onChanged: (bool newValue){
                    setState(() {
                      switch01 = newValue;
                    });
                  }
                  )
            ],
          ),
          _buidlinia(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Recordatorio registrar comidas ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                ),
                Switch(
                  value: switch02,
                  inactiveTrackColor: Colors.grey.shade300,
                  activeColor: Colors.green.shade300, 
                  onChanged: (bool newValue){
                    setState(() {
                      switch02 = newValue;
                    });
                  }
                  )
            ],
          ),
          _buidlinia(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Aviso al exceder objetivo calorico ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                ),
                Switch(
                  value: switch03,
                  inactiveTrackColor: Colors.grey.shade300,
                  activeColor: Colors.green.shade300, 
                  onChanged: (bool newValue){
                    setState(() {
                      switch03 = newValue;
                    });
                  }
                  )
            ],
          ),
        ],
      ),
    );
  }
}
