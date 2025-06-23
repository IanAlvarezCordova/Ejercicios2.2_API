class Contact {
  final int id;
  final String nombre;
  final String empresa;
  final String numero;
  final String foto;

  Contact({
    required this.id,
    required this.nombre,
    required this.empresa,
    required this.numero,
    required this.foto,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'],
      nombre: json['nombre'],
      empresa: json['empresa'],
      numero: json['numero'],
      foto: json['foto'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'empresa': empresa,
      'numero': numero,
      'foto': foto,
    };
  }
}
