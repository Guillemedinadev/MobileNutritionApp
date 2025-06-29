import 'package:cloud_firestore/cloud_firestore.dart';

class Alimento {
  String? id;
  String nombre;
  double? cantidad;
  double? calorias;
  double? grasas;
  double? grasasSaturadas;
  double? hidratosDeCarbono;
  double? azucares;
  double? proteinas;
  double? sal;
  double? fibra;
  String? tipoComida;
  DateTime fecha;

  Alimento({
    this.id,
    required this.nombre,
    this.cantidad,
    this.calorias,
    this.grasas,
    this.grasasSaturadas,
    this.hidratosDeCarbono,
    this.azucares,
    this.proteinas,
    this.sal,
    this.fibra,
    this.tipoComida,
    required this.fecha,
  });

  Alimento copiaConFecha(DateTime nuevaFecha) => Alimento(
    nombre: nombre,
    cantidad: cantidad,
    calorias: calorias,
    grasas: grasas,
    grasasSaturadas: grasasSaturadas,
    hidratosDeCarbono: hidratosDeCarbono,
    azucares: azucares,
    proteinas: proteinas,
    sal: sal,
    fibra: fibra,
    tipoComida: tipoComida,
    fecha: nuevaFecha,
  );

  Map<String, dynamic> toJson() => {
    'nombre':  nombre,
    'cantidad':  cantidad,
    'calorias':  calorias,
    'grasas':  grasas,
    'grasasSaturadas': grasasSaturadas,
    'hidratosDeCarbono': hidratosDeCarbono,
    'azucares': azucares,
    'proteinas': proteinas,
    'sal': sal,
    'fibra': fibra,
    'tipoComida': tipoComida,
    'fecha': Timestamp.fromDate(fecha),
  };

  factory Alimento.fromJson(Map<String, dynamic> json) => Alimento(
  id: json['id'],
  nombre: json['nombre'],
  cantidad: (json['cantidad'] as num?)?.toDouble(),
  calorias: (json['calorias'] as num?)?.toDouble(),
  grasas: (json['grasas'] as num?)?.toDouble(),
  grasasSaturadas: (json['grasasSaturadas'] as num?)?.toDouble(),
  hidratosDeCarbono: (json['hidratosDeCarbono'] as num?)?.toDouble(),
  azucares: (json['azucares'] as num?)?.toDouble(),
  proteinas: (json['proteinas'] as num?)?.toDouble(),
  sal: (json['sal'] as num?)?.toDouble(),
  fibra: (json['fibra'] as num?)?.toDouble(),
  tipoComida: json['tipoComida'],
  fecha: json['fecha'] is Timestamp
      ? (json['fecha'] as Timestamp).toDate()
      : DateTime.parse(json['fecha']),
);
}