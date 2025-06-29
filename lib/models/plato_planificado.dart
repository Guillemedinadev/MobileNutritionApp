import 'package:nutrition_app/models/alimento.dart';

class PlatoPlanificado {
  String? id;
  String nombre;
  String tipoComida;
  List<Alimento> alimentos;
  DateTime fecha;

  PlatoPlanificado({
    this.id,
    required this.nombre,
    required this.tipoComida,
    required this.alimentos,
    required this.fecha,
  });

  double get caloriasTotales =>
      alimentos.fold(0, (sum, a) => sum + ((a.calorias ?? 0) * (a.cantidad ?? 0) / 100));

  double get cantidadTotal =>
      alimentos.fold(0, (sum, a) => sum + (a.cantidad ?? 0));
  
  double get proteinasTotales =>
    alimentos.fold(0, (sum, a) => sum + ((a.proteinas ?? 0) * (a.cantidad ?? 0) / 100));

  double get grasasTotales =>
      alimentos.fold(0, (sum, a) => sum + ((a.grasas ?? 0) * (a.cantidad ?? 0) / 100));

  double get grasasSaturadasTotales =>
      alimentos.fold(0, (sum, a) => sum + ((a.grasasSaturadas ?? 0) * (a.cantidad ?? 0) / 100));

  double get hidratosDeCarbonoTotales =>
      alimentos.fold(0, (sum, a) => sum + ((a.hidratosDeCarbono ?? 0) * (a.cantidad ?? 0) / 100));

  double get azucaresTotales =>
      alimentos.fold(0, (sum, a) => sum + ((a.azucares ?? 0) * (a.cantidad ?? 0) / 100));

  double get fibraTotales =>
      alimentos.fold(0, (sum, a) => sum + ((a.fibra ?? 0) * (a.cantidad ?? 0) / 100));

  double get salTotales =>
      alimentos.fold(0, (sum, a) => sum + ((a.sal ?? 0) * (a.cantidad ?? 0) / 100));


  Map<String, dynamic> toJson() => {
    'id': id,
    'nombre': nombre,
    'tipoComida': tipoComida,
    'fecha': fecha.toIso8601String(),
    'alimentos': alimentos.map((a) => a.toJson()).toList(),
  };

  factory PlatoPlanificado.fromJson(Map<String, dynamic> json, String id) {
    return PlatoPlanificado(
      id: id,
      nombre: json['nombre'],
      tipoComida: json['tipoComida'],
      fecha: DateTime.parse(json['fecha']),
      alimentos: (json['alimentos'] as List<dynamic>)
          .map((a) => Alimento.fromJson(a as Map<String, dynamic>))
          .toList(),
    );
  }
}
