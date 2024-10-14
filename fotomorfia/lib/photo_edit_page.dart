import 'package:flutter/material.dart';

class PhotoEditPage extends StatelessWidget {
  const PhotoEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Editor'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Logika wyboru zdjęcia
              },
              child: const Text('Wybierz zdjęcie'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Logika zrobienia zdjęcia
              },
              child: const Text('Zrób zdjęcie'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Logika zastosowania efektu AI
              },
              child: const Text('Zastosuj efekt AI'),
            ),
          ],
        ),
      ),
    );
  }
}
