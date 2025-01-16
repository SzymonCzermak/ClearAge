import 'package:flutter/material.dart';
import 'styles.dart';

class ThresholdDialog extends StatefulWidget {
  final double initialThreshold;
  final Function(double) onThresholdChanged;

  const ThresholdDialog({
    required this.initialThreshold,
    required this.onThresholdChanged,
    super.key,
  });

  @override
  State<ThresholdDialog> createState() => _ThresholdDialogState();
}

class _ThresholdDialogState extends State<ThresholdDialog> {
  late double localThreshold;

  @override
  void initState() {
    super.initState();
    localThreshold = widget.initialThreshold; // Inicjalizacja wartości
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: AppStyles.backgroundGradient, // Tło z gradientem
          borderRadius: BorderRadius.circular(15.0), // Zaokrąglone rogi
          border: Border.all(
            color: Colors.white, // Biała ramka
            width: 2.0, // Grubość ramki
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Ustaw próg pełnoletności',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '0%',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: Slider(
                      value: localThreshold,
                      min: 0.0,
                      max: 100.0,
                      divisions: 100,
                      activeColor: Colors.greenAccent, // Kolor aktywnej części
                      inactiveColor: Colors.white, // Kolor nieaktywnej części
                      onChanged: (value) {
                        setState(() {
                          localThreshold = value; // Aktualizacja wartości i UI
                        });
                      },
                    ),
                  ),
                  const Text(
                    '100%',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Obecny próg: ${localThreshold.toStringAsFixed(0)}%',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: AppStyles.buttonDecoration, // Dekoracja przycisku
                child: ElevatedButton(
                  onPressed: () {
                    widget
                        .onThresholdChanged(localThreshold); // Zapisanie progu
                    Navigator.of(context).pop(); // Zamknięcie dialogu
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 10,
                    ),
                    backgroundColor: Colors.transparent, // Przezroczyste tło
                    shadowColor: Colors.transparent, // Brak cienia
                    elevation: 0, // Brak podniesienia
                  ),
                  child: Text(
                    'Zapisz',
                    style: AppStyles.buttonTextStyle(20, Colors.white),
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
