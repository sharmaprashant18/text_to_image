import 'dart:io';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class Homepage extends StatefulWidget {
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  XFile? pickedImage;
  String convertedtext = '';
  bool isLoading = false;
  final ImagePicker imagePicker = ImagePicker();
  Future getImage(ImageSource deviceSource) async {
    XFile? result = await imagePicker.pickImage(source: deviceSource);
    if (result != null) {
      setState(() {
        pickedImage = result;
      });
      textRecognition();
    }
  }

  Future textRecognition() async {
    setState(() {
      isLoading = true;
    });
    try {
      final inputImage = InputImage.fromFilePath(pickedImage!.path);
      final textRecognizer =
          TextRecognizer(script: TextRecognitionScript.latin);
      final recognizedText = await textRecognizer.processImage(inputImage);
      setState(() {
        convertedtext = recognizedText.text;
        isLoading = false;
      });
      textRecognizer.close();
    } catch (e) {
      throw Exception('Error:$e');
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image to Text'),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          if (pickedImage == null)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              child: Container(
                height: 400,
                child: Center(
                  child: Text('No Image Selected'),
                ),
              ),
            )
          else
            Center(
              child: Image.file(
                File(pickedImage!.path),
                height: 450,
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: () {
                    getImage(ImageSource.camera);
                  },
                  child: Text('Choose From  Camera')),
              ElevatedButton(
                  onPressed: () {
                    getImage(ImageSource.gallery);
                  },
                  child: Text('Choose From Gallery')),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: Text(
              'Converting Text From Image:',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          if (isLoading)
            Center(
              child: CircularProgressIndicator(),
            )
          else
            Center(
              child:
                  AnimatedTextKit(isRepeatingAnimation: false, animatedTexts: [
                TyperAnimatedText(convertedtext, textAlign: TextAlign.center)
              ]),
            )
        ],
      ),
    );
  }
}
