class Usuario{
  String? id;
  String nombre;
  String username;
  String apellido1;
  String? apellido2;
  String email;
  String imagen;
  num objetivoCalorico;
  bool recordatorioComidas;
  bool recordatorioPlanificacion;
  bool avisoExcesoCalorias;
  String? capturaUrl;

  Usuario(
    {this.id,
    required this.nombre,
    required this.username,
    required this.apellido1,
    this.apellido2,
    required this.email,
    this.imagen = '',
    required this.objetivoCalorico,
    this.recordatorioComidas = false,
    this.recordatorioPlanificacion = false,
    this.avisoExcesoCalorias = false,
    this.capturaUrl = '',
    });

  Map<String, dynamic> toJson() => {
    'nombre': nombre,
    'username': username,
    'apellido1': apellido1,
    'apellido2': apellido2,
    'email': email,
    'imagen': imagen,
    'objetivoCalorico': objetivoCalorico,
    'recordatorioComidas': recordatorioComidas,
    'recordatorioPlanificacion': recordatorioPlanificacion,
    'avisoExcesoCalorias': avisoExcesoCalorias,
    'capturaUrl': capturaUrl,
  };

  factory Usuario.fromJson(Map<String, dynamic> json, {String? id}) {
    return Usuario(
      id: id ?? json['id'],
      nombre: json['nombre'] ?? '',
      username: json['username'] ?? '',
      apellido1: json['apellido1'] ?? '',
      apellido2: json['apellido2'],
      email: json['email'] ?? '',
      imagen: json['imagen'] ?? '',
      objetivoCalorico: json['objetivoCalorico'] ?? 0,
      recordatorioComidas: json['recordatorioComidas'] ?? false,
      recordatorioPlanificacion: json['recordatorioPlanificacion'] ?? false,
      avisoExcesoCalorias: json['avisoExcesoCalorias'] ?? false,
      capturaUrl: json['capturaUrl'],
    );
  }

  @override
  String toString() {
    return 'Usuario(nombre: $nombre, username: $username, apellido: $apellido1, apellido: $apellido2, email: $email, objetivo calorico: $objetivoCalorico)';
  }
}