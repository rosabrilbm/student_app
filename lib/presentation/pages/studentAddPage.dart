import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:student_app/data/repositories/studentRepository.dart';
import 'package:student_app/data/services/studentService.dart';
import 'package:student_app/shared/colorPalette.dart';
import 'package:student_app/shared/utils/helper/isNullorEmpty.dart';

//Vista de agregar estudiante
class StudentsAddPage extends StatefulWidget {
  const StudentsAddPage({Key? key}) : super(key: key);

  @override
  _StudentsAddPageState createState() => _StudentsAddPageState();
}

class _StudentsAddPageState extends State<StudentsAddPage> {
  late final StudentRepository repository;
  late final StudentService _service;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dniController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();

  String message = '';

  @override
  void initState() {
    super.initState();
    repository = StudentRepository();
    _service = StudentService(repository);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dniController.dispose();
    _birthdateController.dispose();
    super.dispose();
  }

  //Agregar estudiante
  void addStudent() {
    if(!isNullOrEmpty(_dniController.text) && !isNullOrEmpty(_birthdateController.text) && !isNullOrEmpty(_nameController.text)){
      _service.addStudent(_nameController, _dniController, _birthdateController);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('El estudiante ${_nameController.text} se ha agregado correctamente. :)')),
      );
      setState(() {
        message = '';
      });
    }else{
      setState(() {
        message = 'Los campos no pueden estar vacíos';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromARGB(250, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(250, 255, 255, 255),
        title: Container(
          padding: const EdgeInsets.only(left: 15.0, right: 20.0),
          alignment: Alignment.centerRight,
          child: Text('AGREGAR ESTUDIANTE',
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
            // ****NOMBRE ****
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
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // ****FECHA DE NACIMIENTO ****
            Text('FECHA DE NACIMIENTO',
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
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_month,
                      color: ColorPalette.secondaryText, size: 35),
                  onPressed: () async {
                    DateTime? date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1800),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      setState(() {
                        _birthdateController.text = "${date.year}-${date.month}-${date.day}";
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            // ****CEDULA****
            Text('CÉDULA',
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
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: Text(message,
              style: TextStyle(
                fontSize: screenWidth * 0.05,
                color: const Color.fromARGB(233, 102, 120, 109),
                fontWeight: FontWeight.w700,
              ),
            ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.large(
        heroTag: 'save',
        shape: const CircleBorder(),
        backgroundColor: const Color.fromARGB(209, 47, 187, 77),
        onPressed: addStudent,
        child: const Icon(Icons.check, color: Colors.white, size: 35),
      ),
    );
  }
}
