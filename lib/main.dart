import 'package:flutter/material.dart';
import 'package:student_app/presentation/pages/studentPage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 

  // Configuración de Supabase
  await Supabase.initialize(
    url: "https://gevostfvldtnqushnebo.supabase.co",
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imdldm9zdGZ2bGR0bnF1c2huZWJvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzMyMzM0ODgsImV4cCI6MjA0ODgwOTQ4OH0.31oJBRb8FzpMHBjxU82XAtpnVs3Er8fp78FBuflGWBQ"
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Gestión de Estudiantes',
      debugShowCheckedModeBanner: false, 
      theme: ThemeData(
        fontFamily: 'Nunito'
      ),
      home: StudentPage()
    );
  }
}
