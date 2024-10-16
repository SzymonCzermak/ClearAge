import 'package:flutter/material.dart';
import 'photo_edit_page.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'styles.dart'; // Importujemy styles.dart

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fotomorfia',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double buttonFontSize = 20.0; // Zmienna dla rozmiaru tekstu przycisku
  Color buttonTextColor =
      const Color.fromARGB(255, 255, 255, 255); // Kolor tekstu
  bool _isTextVisible = false; // Flaga, czy tekst jest widoczny

  @override
  void initState() {
    super.initState();
    // Wywołanie animacji po zbudowaniu widgetu
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _isTextVisible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Użycie gradientu tła
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppStyles.backgroundGradient, // Gradient tła
              ),
            ),
          ),
          // Animowane logo i przycisk pojawiające się równocześnie
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Logo z animacją pojawiania się
                AppStyles.animatedOpacity(
                  isVisible: _isTextVisible,
                  child: SvgPicture.asset(
                    'assets/Fotomorfia.svg',
                    height: 350,
                    width: 350,
                  ),
                ),
                const SizedBox(height: 20),
                // Przyciski z animacją pojawiania się
                AppStyles.animatedOpacity(
                  isVisible: _isTextVisible,
                  duration: const Duration(seconds: 5),
                  child: Container(
                    decoration: AppStyles.buttonDecoration, // Styl przycisku
                    child: ElevatedButton(
                      onPressed: () {
                        _navigateWithFade(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 45, vertical: 10),
                        backgroundColor: Colors.transparent,
                        shadowColor: const Color.fromARGB(255, 255, 255, 255),
                        elevation: 0,
                      ),
                      child: Text(
                        'Rozpocznij',
                        style: AppStyles.buttonTextStyle(
                            buttonFontSize, buttonTextColor), // Styl tekstu
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Funkcja do nawigacji z animacją fade
  void _navigateWithFade(BuildContext context) {
    Navigator.of(context)
        .push(AppStyles.createFadeRoute(const PhotoEditPage()));
  }
}
