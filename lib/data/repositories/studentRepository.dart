import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:student_app/domain/entities/student.dart';

//Repositorio de interacción con Supabase
class StudentRepository {
  final SupabaseClient _client;
  StudentRepository() : _client = Supabase.instance.client;

  final streamStudents = Supabase.instance.client
      .from('Student')
      .stream(primaryKey: ['id']).map(
          (data) => data.map((response) => Student.fromMap(response)).toList());

  Future<void> createStudent(Student newStudent) async {
    try {
      await _client.from('Student').insert({
        'name': newStudent.name,
        'dni': newStudent.dni,
        'birthdate': newStudent.birthdate,
      });
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> editStudent(Student student) async {
    try {
      await _client.from('Student').update({
        'name': student.name,
        'dni': student.dni,
        'birthdate': student.birthdate
      }).eq('id', student.id ?? 0);

      final res = await _client
          .from('Student')
          .select('id, name, dni')
          .eq('id', student.id ?? 0)
          .single();

      return Map<String, dynamic>.from(res);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future deleteStudent(Student student, int id) async {
    await _client.from('Student').delete().eq('id', id);
  }

  Future<List<Student>> searchStudents(String search) async {
    final response = await _client
        .from('Student')
        .select()
        .ilike('name', '%$search%');

    if (response.isNotEmpty) {
      return response.map<Student>((studentMap) => Student.fromMap(studentMap)).toList();
    } else {
      return [];
    }
  }


}
