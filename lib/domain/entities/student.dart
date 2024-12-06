class Student {
  final int? id;
  final String name;
  final String dni;
  final String birthdate;

  Student({
    this.id,
    required this.name,
    required this.dni,
    required this.birthdate,
  });

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'] ?? 0, 
      name: map['name'] ?? '', 
      dni: map['dni'] ?? '', 
      birthdate: map['birthdate'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dni': dni,
      'birthdate': birthdate,
    };
  }
}
