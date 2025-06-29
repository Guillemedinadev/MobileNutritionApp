import 'package:nutrition_app/models/alimento.dart';
import 'package:nutrition_app/models/nutrientes_totales.dart';
import 'package:nutrition_app/models/plato_planificado.dart';

class Historial {
  String fecha; 
  List<Alimento> capturados; // alimentos/platos añadidos por foto o manual
  List<PlatoPlanificado> platosConsumidos; // platos planificados consumidos
  NutrientesTotales totales; // total de valores nutricionales del día

  Historial({
    required this.fecha,
    required this.capturados,
    required this.platosConsumidos,
    required this.totales,
  });

  Map<String, dynamic> toJson() => {
    'fecha': fecha,
    'capturados': capturados.map((c) => c.toJson()).toList(),
    'platosConsumidos': platosConsumidos.map((p) => p.toJson()).toList(),
    'totales': totales.toJson(),
  };

  factory Historial.fromJson(Map<String, dynamic> json) => Historial(
    fecha: json['fecha'] ?? '',
    capturados: json['capturados'] != null
        ? List<Alimento>.from(
            (json['capturados'] as List).map((e) => Alimento.fromJson(e)))
        : [],
    platosConsumidos: json['platosConsumidos'] != null
        ? List<PlatoPlanificado>.from(
            (json['platosConsumidos'] as List)
                .map((e) => PlatoPlanificado.fromJson(e, e['id'])))
        : [],
    totales: json['totales'] != null
        ? NutrientesTotales.fromJson(json['totales'])
        : NutrientesTotales(),
  );
}
