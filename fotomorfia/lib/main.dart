import 'package:flutter/material.dart';
import 'photo_edit_page.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Importujemy flutter_svg dla logo

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
      Color.fromARGB(255, 0, 145, 113); // Zmienna dla koloru tekstu

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Czarne tło z prostym gradientem w dwóch rogach
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromARGB(
                        183, 0, 192, 115), // Zielony w lewym górnym rogu
                    Color.fromARGB(
                        199, 115, 0, 209), // Fioletowy w prawym dolnym rogu
                  ],
                ),
              ),
            ),
          ),
          // Logo SVG, przycisk i inne elementy stopniowo wyłaniające się
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(seconds: 3), // Czas trwania animacji
            builder: (context, double opacity, child) {
              return Opacity(
                opacity: opacity,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SvgPicture.asset(
                        'assets/Fotomorfia.svg', // Ścieżka do pliku SVG z logo
                        height: 350, // Ustawienie rozmiaru logo
                        width: 350,
                      ),
                      const SizedBox(height: 5),
                      ElevatedButton(
                        onPressed: () {
                          _navigateWithFade(context);
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(150, 50), // Rozmiar przycisku
                          padding: const EdgeInsets.symmetric(
                              horizontal: 45, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(15), // Zaokrąglone rogi
                          ),
                        ),
                        child: Text(
                          'Rozpocznij',
                          style: TextStyle(
                            fontSize:
                                buttonFontSize, // Dynamiczna zmiana rozmiaru tekstu
                            color:
                                buttonTextColor, // Dynamiczna zmiana koloru tekstu
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Funkcja do nawigacji z animacją fade
  void _navigateWithFade(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const PhotoEditPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Animacja fade
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }
}
