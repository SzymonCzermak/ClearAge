import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Importujemy flutter_svg dla logo
import 'package:fotomorfia/predictionDialog.dart';
import 'styles.dart'; // Importujemy styles.dart dla stylów
import 'package:image_picker/image_picker.dart'; // Do wybierania obrazów
import 'package:tflite_flutter/tflite_flutter.dart'; // Do użycia modelu TFLite
import 'package:image/image.dart' as img; // Do przetwarzania obrazów
import 'dart:io'; // Do obsługi plików

class PhotoEditPage extends StatefulWidget {
  const PhotoEditPage({super.key});

  @override
  State<PhotoEditPage> createState() => _PhotoEditPageState();
}

class _PhotoEditPageState extends State<PhotoEditPage> {
  File? _selectedImage; // Przechowywanie zdjęcia
  String? _predictionResult; // Wynik klasyfikacji zdjęcia
  Interpreter? _interpreter; // Interpreter modelu TFLite
  final ImagePicker _picker = ImagePicker(); // Inicjalizacja ImagePicker
  bool _isLoading = false; // Flaga ładowania

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  // Wczytanie modelu TFLite
  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/model.tflite');
      print('Model załadowany pomyślnie.');
    } catch (e) {
      print('Błąd podczas ładowania modelu: $e');
    }
  }

  // Logika wyboru zdjęcia z galerii
  Future<void> _pickImage() async {
    setState(() => _isLoading = true);
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
        await _predictAgeCategory();
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Logika robienia zdjęcia
  Future<void> _takePicture() async {
    setState(() => _isLoading = true);
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
        await _predictAgeCategory();
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Klasyfikacja zdjęcia za pomocą modelu TFLite
  Future<void> _predictAgeCategory() async {
    if (_selectedImage == null) return;

    if (_interpreter == null) {
      print('Interpreter nie został załadowany.');
      return;
    }

    final imageBytes = await _selectedImage!.readAsBytes();
    final decodedImage = img.decodeImage(imageBytes);

    if (decodedImage == null) {
      print('Nie udało się załadować obrazu.');
      return;
    }

    final resizedImage = img.copyResize(decodedImage, width: 320, height: 370);
    final input =
        resizedImage.data!.buffer.asUint8List().map((e) => e / 255.0).toList();
    final inputTensor = [
      input.reshape([370, 320, 3])
    ];
    final output = List.filled(1, 0.0).reshape([1, 1]);

    try {
      _interpreter!.run(inputTensor, output);
      print('Output: ${output[0][0]}');

      setState(() {
        _predictionResult =
            output[0][0] > 0.5 ? "Dziecko (-18)" : "Dorosły (+18)";
      });

      showDialog(
        context: context,
        builder: (context) => PredictionDialog(
          predictionResult: _predictionResult!,
          selectedImage: _selectedImage!,
        ),
      );
    } catch (e) {
      print('Błąd podczas predykcji: $e');
    }
  }

  @override
  void dispose() {
    _interpreter?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: SvgPicture.asset(
          'assets/Fotomorfia.svg',
          height: 73,
          width: 73,
        ),
        centerTitle: true,
        backgroundColor: Colors.black.withOpacity(0.5),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actionsIconTheme:
            const IconThemeData(color: Color.fromARGB(255, 255, 255, 255)),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppStyles.backgroundGradient,
              ),
            ),
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            )
          else
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: AppStyles.buttonDecoration,
                    child: ElevatedButton(
                      onPressed: _pickImage,
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
                      onPressed: _takePicture,
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
                ],
              ),
            ),
        ],
      ),
    );
  }
}
