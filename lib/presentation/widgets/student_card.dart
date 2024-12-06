import 'package:flutter/material.dart';
import 'package:student_app/shared/colorPalette.dart';
import '../../domain/entities/student.dart';

//ViewCard utilizado en la pantalla principal
class StudentCard extends StatelessWidget {
  final Student student;
  const StudentCard({
    Key? key,
    required this.student,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Card.outlined(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(width:1, color: Color.fromARGB(73, 79, 86, 81))
      ),
      color: Colors.white,
      child: Container(
          padding: EdgeInsets.all(10.0),
          child: ListTile(
          title: Text(student.name, 
          style: TextStyle(
              fontSize: screenWidth * 0.06,
              color: ColorPalette.primaryText,
              fontWeight: FontWeight.w700
            ),
          ),
          subtitle: Text('${student.dni}', 
          style: TextStyle(
            fontSize: screenWidth *0.04 ,
            fontWeight: FontWeight.w700, 
            color: Color.fromARGB(135, 19, 75, 35),
            ),
          ),
        ),
      )
    );
  }
}
