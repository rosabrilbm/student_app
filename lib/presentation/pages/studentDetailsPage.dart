import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:student_app/data/repositories/studentRepository.dart';
import 'package:student_app/data/services/studentService.dart';
import 'package:student_app/presentation/pages/studentPage.dart';
import 'package:student_app/shared/colorPalette.dart';
import 'package:student_app/shared/utils/helper/isNullorEmpty.dart';
import '../../domain/entities/student.dart';

//Vista de detalles (edición y eliminar)
class StudentDetailsPage extends StatefulWidget {
  final Student student;
  final bool? isEditable;
  const StudentDetailsPage(
      {Key? key, required this.student, this.isEditable = false})
      : super(key: key);

  @override
  _EditablePageState createState() => _EditablePageState();
}

class _EditablePageState extends State<StudentDetailsPage> {
  late Student _editableStudent;
  //controladores
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dniController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();

  late final StudentRepository repository;
  late final StudentService _service;

  //lógica para cuando se presione el editar en la vista principal
  late bool? isEditableWidget = true;
  bool isEdit = false;
  String message = '';

  void editable(bool isEditable) {
    setState(() {
      isEdit = isEditable;
    });
  }

  @override
  void initState() {
    super.initState();
    _editableStudent = widget.student;
    isEditableWidget = widget.isEditable;
    _nameController.text = _editableStudent.name;
    _dniController.text = _editableStudent.dni;
    _birthdateController.text = _editableStudent.birthdate;
    repository = StudentRepository();
    _service = StudentService(repository);

    if (isEditableWidget == true) {
      editable(true);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dniController.dispose();
    _birthdateController.dispose();
    super.dispose();
  }

  // Eliminar estudiante
  void delete() {
    _service.delete(_editableStudent.id ?? 0, _editableStudent);
    setState(() {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => StudentPage(),
        ),
      );
      isEdit = false;
    });
  }

  //guardar edición
  void saveEdit() async {
    if (isNullOrEmpty(_nameController.text)) {
      _nameController.text = _editableStudent.name;
    }
    if (isNullOrEmpty(_dniController.text)) {
      _dniController.text = _editableStudent.dni;
    }
    if (isNullOrEmpty(_birthdateController.text)) {
      _birthdateController.text = _editableStudent.birthdate;
    }
    
    try {
      await _service.editStudent(
        _editableStudent.id ?? 0,
        _nameController,
        _dniController,
        _birthdateController,
      );

      setState(() {
        _editableStudent = Student(
          id: _editableStudent.id,
          name: _nameController.text,
          dni: _dniController.text,
          birthdate: _birthdateController.text,
        );
        isEdit = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Los datos del estudiante han sido actualizados correctamente.'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Ha ocurrido un error al actualizar los datos.')),
      );
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromARGB(250, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: Container(
          padding: const EdgeInsets.only(left: 15.0, right: 20.0),
          alignment: Alignment.centerRight,
          child: Text(
            (!isEdit) ? 'DETALLES DEL ESTUDIANTE' : 'EDITAR ESTUDIANTE',
            style: TextStyle(
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.w800,
              color: ColorPalette.secondaryText,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 28.0, right: 28.0, top: 34),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Si está en modo edición
            if (isEdit)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'NOMBRE',
                    style: TextStyle(
                      fontSize: screenWidth * 0.07,
                      color: ColorPalette.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 1),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: _editableStudent.name,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'FECHA DE NACIMIENTO',
                    style: TextStyle(
                      fontSize: screenWidth * 0.07,
                      color: ColorPalette.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextFormField(
                    controller: _birthdateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: _editableStudent.birthdate,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_month, size: 35),
                        onPressed: () async {
                          DateTime? date = await showDatePicker(context: context,initialDate: DateTime.now(),firstDate: DateTime(1900),lastDate: DateTime.now(),
                          );
                          if (date != null) {
                            setState(() {
                              _birthdateController.text =
                                  "${date.year}-${date.month}-${date.day}";
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'CÉDULA',
                    style: TextStyle(
                      fontSize: screenWidth * 0.07,
                      color: ColorPalette.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 1),
                  TextFormField(
                    keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly, 
                    ],
                    controller: _dniController,
                    decoration: InputDecoration(
                      labelText: _editableStudent.dni,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ],
              )
            //Modo de detalles
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'NOMBRE',
                    style: TextStyle(
                      fontSize: screenWidth * 0.07,
                      color: ColorPalette.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    _editableStudent.name,
                    style: TextStyle(
                      fontSize: screenWidth * 0.06,
                      color: const Color.fromARGB(119, 58, 79, 64),
                      backgroundColor: const Color.fromARGB(112, 177, 236, 195),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'FECHA DE NACIMIENTO',
                    style: TextStyle(
                      fontSize: screenWidth * 0.07,
                      color: ColorPalette.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    _editableStudent.birthdate,
                    style: TextStyle(
                      fontSize: screenWidth * 0.06,
                      color: const Color.fromARGB(119, 58, 79, 64),
                      backgroundColor: const Color.fromARGB(112, 177, 236, 195),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'CÉDULA',
                    style: TextStyle(
                      fontSize: screenWidth * 0.07,
                      color: ColorPalette.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    _editableStudent.dni,
                    style: TextStyle(
                      fontSize: screenWidth * 0.06,
                      color: const Color.fromARGB(119, 58, 79, 64),
                      backgroundColor: const Color.fromARGB(112, 177, 236, 195),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
      //Botones flotantes
      floatingActionButton: isEdit
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FloatingActionButton.large(
                  heroTag: 'save',
                  shape: const CircleBorder(),
                  backgroundColor: const Color.fromARGB(209, 47, 187, 77),
                  onPressed: saveEdit,
                  child: const Icon(Icons.check, color: Colors.white, size: 35),
                ),
                FloatingActionButton.small(
                  heroTag: 'delete',
                  shape: const CircleBorder(),
                  backgroundColor: Colors.black,
                  onPressed: delete,
                  child: const Icon(Icons.delete_outline_rounded,
                      color: ColorPalette.icon, size: 35),
                ),
                FloatingActionButton.small(
                  heroTag: 'cancel',
                  shape: const CircleBorder(),
                  backgroundColor: Colors.black,
                  onPressed: () => editable(false),
                  child: const Icon(Icons.cancel_sharp,
                      color: ColorPalette.icon, size: 35),
                ),
              ],
            )
          : FloatingActionButton.large(
              heroTag: 'edit',
              shape: const CircleBorder(),
              backgroundColor: const Color.fromARGB(209, 0, 0, 0),
              onPressed: () => editable(true),
              child: const Icon(Icons.edit, color: ColorPalette.icon, size: 35),
            ),
    );
  }
}
