import 'package:nutrition_app/models/alimento.dart';

class NutrientesTotales {
  double calorias;
  double grasas;
  double grasasSaturadas;
  double hidratosDeCarbono;
  double azucares;
  double proteinas;
  double sal;
  double fibra;

  NutrientesTotales({
    this.calorias = 0,
    this.grasas = 0,
    this.grasasSaturadas = 0,
    this.hidratosDeCarbono = 0,
    this.azucares = 0,
    this.proteinas = 0,
    this.sal = 0,
    this.fibra = 0,
  });

  void sumar(Alimento alimento) {
    calorias += alimento.calorias ?? 0;
    grasas += alimento.grasas ?? 0;
    grasasSaturadas += alimento.grasasSaturadas ?? 0;
    hidratosDeCarbono += alimento.hidratosDeCarbono ?? 0;
    azucares += alimento.azucares ?? 0;
    proteinas += alimento.proteinas ?? 0;
    sal += alimento.sal ?? 0;
    fibra += alimento.fibra ?? 0;
  }

  void restar(Alimento alimento) {
    calorias -= alimento.calorias ?? 0;
    grasas -= alimento.grasas ?? 0;
    grasasSaturadas -= alimento.grasasSaturadas ?? 0;
    hidratosDeCarbono -= alimento.hidratosDeCarbono ?? 0;
    azucares -= alimento.azucares ?? 0;
    proteinas -= alimento.proteinas ?? 0;
    sal -= alimento.sal ?? 0;
    fibra -= alimento.fibra ?? 0;
  }

  Map<String, dynamic> toJson() => {
    'calorias': calorias,
    'grasas': grasas,
    'grasasSaturadas': grasasSaturadas,
    'hidratosDeCarbono': hidratosDeCarbono,
    'azucares': azucares,
    'proteinas': proteinas,
    'sal': sal,
    'fibra': fibra,
  };

  factory NutrientesTotales.fromJson(Map<String, dynamic> json) => NutrientesTotales(
    calorias: (json['calorias'] ?? 0).toDouble(),
    grasas: (json['grasas'] ?? 0).toDouble(),
    grasasSaturadas: (json['grasasSaturadas'] ?? 0).toDouble(),
    hidratosDeCarbono: (json['hidratosDeCarbono'] ?? 0).toDouble(),
    azucares: (json['azucares'] ?? 0).toDouble(),
    proteinas: (json['proteinas'] ?? 0).toDouble(),
    sal: (json['sal'] ?? 0).toDouble(),
    fibra: (json['fibra'] ?? 0).toDouble(),
  );
}
