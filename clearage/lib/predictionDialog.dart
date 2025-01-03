import 'package:flutter/material.dart';
import 'dart:io'; // Do obsługi plików
import 'styles.dart';

class PredictionDialog extends StatelessWidget {
  final String predictionResult;
  final File selectedImage;
  final bool isLoading; // Dodano parametr isLoading

  const PredictionDialog({
    required this.predictionResult,
    required this.selectedImage,
    this.isLoading = false, // Domyślnie false
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: AppStyles.backgroundGradient,
          borderRadius: const BorderRadius.all(Radius.circular(15.0)),
          border: Border.all(
            color: Colors.white,
            width: 2.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Wynik predykcji',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: predictionResult == "Dorosły (+18)"
                        ? const Color.fromARGB(190, 76, 175, 79)
                        : const Color.fromARGB(190, 244, 67, 54),
                    width: 4.0,
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.file(
                    selectedImage,
                    height: 370,
                    width: 320,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              isLoading
                  ? const Text(
                      'Ładowanie, proszę czekać...',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      predictionResult,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
              const SizedBox(height: 30),
              Container(
                decoration: AppStyles.buttonDecoration,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Zamknij okno dialogowe
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 45,
                      vertical: 10,
                    ),
                    backgroundColor: Colors.transparent,
                    shadowColor: const Color.fromARGB(255, 255, 255, 255),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Zamknij',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
