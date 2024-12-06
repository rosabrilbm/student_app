import 'package:flutter/material.dart';
import 'package:student_app/data/repositories/studentRepository.dart';
import 'package:student_app/data/services/studentService.dart';
import 'package:student_app/domain/entities/student.dart';
import 'package:student_app/presentation/pages/studentAddPage.dart';
import 'package:student_app/presentation/pages/studentDetailsPage.dart';
import 'package:student_app/shared/colorPalette.dart';
import 'package:student_app/shared/utils/helper/isNullorEmpty.dart';
import '../widgets/student_card.dart';

class StudentPage extends StatefulWidget {
  @override
  _StudentPageState createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  late final StudentRepository repository;
  late final StudentService _service;
  final TextEditingController _searchController = TextEditingController();

  bool isSearching = false;

  Stream<List<Student>> getStudents() {
    final repository = StudentRepository();
    final _service = StudentService(repository);
    return _service.getStudents();
  }

  @override
  void initState() {
    super.initState();
    repository = StudentRepository();
    _service = StudentService(repository);
    _searchController.addListener(() {
      search(_searchController.text);
      if(isNullOrEmpty(_searchController.text)){
        setState(() {
          isSearching = false;
        });
      }
    });
  }
  List<Student> students = [];

  void delete(int id, Student student, BuildContext context){
  _service.delete(id, student);
    setState(() {
      students.remove(student);
      Navigator.pop(context);
    });
  }
    
  Future<List<Student>> search(String search) async {
    try {
      final studentsList = await _service.search(search);
      setState(() {
        students = studentsList;
        isSearching = true;
      });
      return studentsList;
    } catch (e) {
      print("Error: $e");
      return []; 
    }
  }

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title:  Container(
          padding: EdgeInsets.only(left: 15.0, right: 20.0, top: 30.0),
          alignment: Alignment.centerLeft, 
          child: Text('ESTUDIANTES',
            style: TextStyle(
              fontSize: displayWidth * 0.08,
              fontWeight: FontWeight.w800,
              color: ColorPalette.primaryText,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 36),
            //****BUSCADOR****
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color.fromARGB(58, 32, 164, 72),
                labelText: 'BUSCAR ESTUDIANTES',
                labelStyle: TextStyle(fontSize: displayWidth * 0.05),
                contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
                suffixIcon: Container(
                  margin: const EdgeInsets.all(10.0),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(114, 32, 164, 72),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.search, size: displayWidth * 0.07, color: ColorPalette.secondaryText),
                    onPressed: () {
                      search(_searchController.text);
                    },
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0), 
                  borderSide: const BorderSide(color: ColorPalette.secondary, width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.0),
                  borderSide: const BorderSide(
                    color: Colors.green,
                    width: 2.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.0),
                  borderSide: const BorderSide(
                    color: Colors.grey, 
                    width: 0,
                  ),
                ),
              ),
            ),
            //*****LISTA DE ESTUDIANTES
            Expanded(
              child: StreamBuilder(
                stream: getStudents(),  
                builder: (context, snapshot) {
                  /*if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else*/ 
                  if (snapshot.hasError) {
                    return Center(child: Text('Ha ocurrido un error :('));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'images/notFound.png',
                            width: displayWidth * 0.6,
                            height: displayWidth * 0.3,
                            fit: BoxFit.cover,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 30.0, right: 30.0),
                            child: Text('SIN REGISTROS, AGREGUE UN ESTUDIANTE',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: displayWidth * 0.045,
                              fontWeight: FontWeight.w800,
                              color: const Color.fromARGB(118, 83, 112, 91),
                            ),
                          ),
                          )
                        ],
                      ),
                    );
                  } else {
                    return Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: Builder(
                        builder: (context) {
                          if (isSearching) {
                            if (students.isNotEmpty) {
                              return ListView.builder(
                                itemCount: students.length,
                                itemBuilder: (context, index) {
                                  final student = students[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(context,
                                        MaterialPageRoute(
                                          builder: (context) => StudentDetailsPage(student: student),
                                        ),
                                      );
                                    },
                                    child: StudentCard(student: student),
                                    onLongPress: () {
                                      _showOptions(context, student);
                                    },
                                  );
                                },
                              );
                            } else {
                              return Center(child: Text('Sin resultados'));
                            }
                          } else {
                            return ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                final student = snapshot.data![index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => StudentDetailsPage(student: student),
                                      ),
                                    );
                                  },
                                  child: StudentCard(student: student),
                                  onLongPress: () {
                                    _showOptions(context, student);
                                  },
                                );
                              },
                            );
                          }
                        },
                      ),
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.large(
        shape: CircleBorder(),
        backgroundColor: const Color.fromARGB(209, 0, 0, 0),
        onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  StudentsAddPage()),
          );
        },
        child: const Icon(Icons.add, color: ColorPalette.icon, size: 35),
      ),
    );
  }

  
Future<void> _showOptions(BuildContext context, Student student) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('${student.name}', style: TextStyle(fontSize: 24)),
          backgroundColor: ColorPalette.icon,
          actions: <Widget>[
            IconButton(
            icon: Icon(Icons.edit, size: 30.0, color: ColorPalette.secondaryText),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => StudentDetailsPage(student: student, isEditable: true),
                ),
              );
            },
            ),
            IconButton(
            icon: Icon(Icons.delete_forever, size: 30.0, color: ColorPalette.secondaryText),
            onPressed: () {
              delete(student.id??0, student, context);
            },
            ),
          ],
        );
      },
    );
  }
}
