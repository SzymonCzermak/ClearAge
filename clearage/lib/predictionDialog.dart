import 'package:flutter/material.dart';
import 'dart:io';
import 'styles.dart';

class PredictionDialog extends StatelessWidget {
  final String predictionResult;
  final File selectedImage;
  final double childProbability; // Prawdopodobieństwo dziecka w %
  final double adultProbability; // Prawdopodobieństwo dorosłego w %
  final double threshold; // Próg pełnoletności w %
  final bool isLoading;

  const PredictionDialog({
    required this.predictionResult,
    required this.selectedImage,
    required this.childProbability,
    required this.adultProbability,
    required this.threshold,
    this.isLoading = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bool isAdult = adultProbability >= threshold;

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
                    color: isAdult ? Colors.green : Colors.red,
                    width: 4.0,
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.file(
                    selectedImage,
                    height: 250, // Zmniejszona wysokość zdjęcia
                    width: 200, // Zmniejszona szerokość zdjęcia
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
                  : Column(
                      children: [
                        Text(
                          'Dorosły: ${adultProbability.toStringAsFixed(2)}%\n'
                          'Dziecko: ${childProbability.toStringAsFixed(2)}%',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          isAdult
                              ? 'Finalna klasyfikacja: Pełnoletni (+18)'
                              : 'Finalna klasyfikacja: Niepełnoletni (-18)',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
              const SizedBox(height: 30),
              Container(
                decoration: AppStyles.buttonDecoration,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
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
