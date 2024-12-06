import 'package:flutter/widgets.dart';
import 'package:student_app/data/repositories/studentRepository.dart';
import 'package:student_app/domain/entities/student.dart';

//Servicios
class StudentService {
  final StudentRepository _repository;
  StudentService(this._repository);

  Stream<List<Student>> getStudents() {
    try {
      return _repository.streamStudents;
    } catch (e) {
      print(e);
      return Stream<List<Student>>.empty();
    }
  }

  Future<void> addStudent(TextEditingController name, TextEditingController dni,
      TextEditingController birthdate) async {
    try {
      Student student = new Student(
          name: name.text, dni: dni.text, birthdate: birthdate.text);
      await _repository.createStudent(student);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> editStudent(int id, TextEditingController name,
      TextEditingController dni, TextEditingController birthdate) async {
    try {
      Student student = Student(
          id: id, name: name.text, dni: dni.text, birthdate: birthdate.text);
      await _repository.editStudent(student);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> delete(int id, Student student) async {
    try{
      await _repository.deleteStudent(student, id);
    }catch(e){
      print(e);
      rethrow;
    }
  }

  Future<List<Student>> search(String search) {
    try{
       final response = _repository.searchStudents(search);
      return response;
    }catch(e){
      print(e);
      rethrow;
    }
  }

}
