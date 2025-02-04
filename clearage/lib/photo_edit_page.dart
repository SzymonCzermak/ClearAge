import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fotomorfia/ThresholdDialog.dart';
import 'package:fotomorfia/predictionDialog.dart';
import 'styles.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'dart:io';

class PhotoEditPage extends StatefulWidget {
  const PhotoEditPage({super.key});

  @override
  State<PhotoEditPage> createState() => _PhotoEditPageState();
}

class _PhotoEditPageState extends State<PhotoEditPage> {
  File? _selectedImage;
  String? _predictionResult;
  Interpreter? _interpreter;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  double _threshold = 50.0; // Domyślny próg pełnoletności

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/model5.tflite');
      print('Model załadowany pomyślnie.');
    } catch (e) {
      print('Błąd podczas ładowania modelu: $e');
    }
  }

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
      final double probability = output[0][0] * 100;

      // Odwrócenie logiki:
      final double adultProbability = 100 - probability; // Dorosły
      final double childProbability = probability; // Dziecko

      setState(() {
        _predictionResult = childProbability >= _threshold
            ? 'Niepełnoletni (-18)'
            : 'Pełnoletni (+18)';
      });

      // Wyświetlenie dialogu
      showDialog(
        context: context,
        builder: (context) => PredictionDialog(
          predictionResult: _predictionResult!,
          selectedImage: _selectedImage!,
          childProbability: childProbability,
          adultProbability: adultProbability,
          threshold: _threshold,
        ),
      );
    } catch (e) {
      print('Błąd podczas predykcji: $e');
    }
  }

  void _showThresholdDialog() {
    showDialog(
      context: context,
      builder: (context) => ThresholdDialog(
        initialThreshold: _threshold,
        onThresholdChanged: (newThreshold) {
          setState(() {
            _threshold = newThreshold;
          });
        },
      ),
    );
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
                  const SizedBox(height: 50),
                  Container(
                    decoration: AppStyles.buttonDecoration,
                    child: ElevatedButton(
                      onPressed: _showThresholdDialog,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 45, vertical: 10),
                        backgroundColor: Colors.transparent,
                        shadowColor: const Color.fromARGB(255, 255, 255, 255),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Ustaw próg pełnoletności',
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
