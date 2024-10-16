import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Importujemy flutter_svg dla logo
import 'styles.dart'; // Importujemy styles.dart dla stylów

class PhotoEditPage extends StatelessWidget {
  const PhotoEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Pozwalamy tłu przejść za AppBar
      appBar: AppBar(
        title: SvgPicture.asset(
          'assets/Fotomorfia.svg', // Ścieżka do pliku SVG z logo
          height: 73, // Zmniejszone logo na AppBar
          width: 73,
        ),
        centerTitle: true, // Logo na środku
        backgroundColor: Colors.black.withOpacity(0.5), // Przezroczysty AppBar
        elevation: 0, // Usunięcie cienia
        iconTheme:
            const IconThemeData(color: Colors.white), // Kolor ikon na AppBar
        actionsIconTheme: const IconThemeData(
            color: Colors.white), // Kolor ikon po prawej stronie
      ),
      body: Stack(
        children: [
          // Tło takie samo jak na pierwszym ekranie
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppStyles.backgroundGradient, // Używamy gradientu tła
              ),
            ),
          ),
          // Przyciski
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Przyciski z takim samym stylem
                Container(
                  decoration: AppStyles.buttonDecoration,
                  child: ElevatedButton(
                    onPressed: () {
                      // Logika wyboru zdjęcia
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 45, vertical: 10),
                      backgroundColor: Colors.transparent,
                      shadowColor: const Color.fromARGB(255, 255, 255, 255),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Wybierz zdjęcie',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Container(
                  decoration: AppStyles.buttonDecoration,
                  child: ElevatedButton(
                    onPressed: () {
                      // Logika zrobienia zdjęcia
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 45, vertical: 10),
                      backgroundColor: Colors.transparent,
                      shadowColor: const Color.fromARGB(255, 255, 255, 255),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Zrób zdjęcie',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
