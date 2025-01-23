import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String extractedText = '';
  File? imageFile;
  final ImagePicker imagePicker = ImagePicker();
  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  Future<void> pickImage(ImageSource source) async {
    try {
      final pickedFile = await imagePicker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          imageFile = File(pickedFile.path);
        });
        processImage(imageFile!);
      }
    } catch (e) {
      throw Exception('Error picking image:$e');
    }
  }

  Future<void> processImage(File image) async {
    try {
      final inputImage = InputImage.fromFile(image);
      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);
      setState(() {
        extractedText = recognizedText.text;
      });
    } catch (e) {
      throw Exception('Error Processing Image:$e');
    }
  }

  @override
  void dispose() {
    textRecognizer.close();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image to Text'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            imageFile != null
                ? Image.file(
                    File(imageFile!.path),
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  )
                : Text('No image selected'),
            ElevatedButton(
                onPressed: () {
                  pickImage(ImageSource.gallery);
                },
                child: Text('Gallery')),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
                onPressed: () {
                  pickImage(ImageSource.camera);
                },
                child: Text('Camera')),
            SizedBox(
              height: 20,
            ),
            Text(
              extractedText.isEmpty ? 'No text extracted' : extractedText,
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
