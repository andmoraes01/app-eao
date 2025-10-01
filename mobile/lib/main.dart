import 'package:flutter/material.dart';
import 'screens/loading_screen.dart';

void main() {
  runApp(const AppEAO());
}

class AppEAO extends StatelessWidget {
  const AppEAO({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AppEAO',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFFFD700), // Amarelo ouro
        scaffoldBackgroundColor: const Color(0xFFFFD700),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFD700),
          primary: const Color(0xFFFFD700),
          secondary: Colors.black,
        ),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          // Label quando focado (flutuando acima)
          floatingLabelStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
          // Label quando focado (cor do outline)
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide(color: Colors.black, width: 2),
          ),
          // Cor do label padrão
          labelStyle: TextStyle(color: Colors.black87),
        ),
      ),
      home: const LoadingScreen(),
    );
  }
}

