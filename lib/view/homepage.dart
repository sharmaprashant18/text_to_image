// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
// import 'package:image_picker/image_picker.dart';

// class Homepage extends StatefulWidget {
//   const Homepage({super.key});

//   @override
//   State<Homepage> createState() => _HomepageState();
// }

// class _HomepageState extends State<Homepage> {
//   String extractedText = '';
//   File? imageFile;
//   final ImagePicker imagePicker = ImagePicker();
// final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
//   Future<void> pickImage(ImageSource source) async {
//     try {
//       final pickedFile = await imagePicker.pickImage(source: source);
//       if (pickedFile != null) {
//         setState(() {
//           imageFile = File(pickedFile.path);
//         });
//         processImage(imageFile!);
//       }
//     } catch (e) {
//       throw Exception('Error picking image:$e');
//     }
//   }

//   Future<void> processImage(File image) async {
//     try {
//       final inputImage = InputImage.fromFile(image);
//       final RecognizedText recognizedText =
//           await textRecognizer.processImage(inputImage);
//       setState(() {
//         extractedText = recognizedText.text;
//       });
//     } catch (e) {
//       throw Exception('Error Processing Image:$e');
//     }
//   }

//   @override
//   void dispose() {
//     textRecognizer.close();
//     super.dispose();
//   }

//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Image to Text'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             imageFile != null
//                 ? Image.file(
//                     File(imageFile!.path),
//                     height: 200,
//                     width: 200,
//                     fit: BoxFit.cover,
//                   )
//                 : Text('No image selected'),
//             ElevatedButton(
//                 onPressed: () {
//                   pickImage(ImageSource.gallery);
//                 },
//                 child: Text('Gallery')),
//             SizedBox(
//               height: 15,
//             ),
//             ElevatedButton(
//                 onPressed: () {
//                   pickImage(ImageSource.camera);
//                 },
//                 child: Text('Camera')),
//             SizedBox(
//               height: 20,
//             ),
//             Text(
//               extractedText.isEmpty ? 'No text extracted' : extractedText,
//               style: TextStyle(fontSize: 20),
//               textAlign: TextAlign.center,
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
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

  textRecognition() async {
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
          isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Center(
                  child: AnimatedTextKit(
                      isRepeatingAnimation: false,
                      animatedTexts: [
                        TyperAnimatedText(convertedtext,
                            textAlign: TextAlign.center)
                      ]),
                )
        ],
      ),
    );
  }
}
