// ignore_for_file: sized_box_for_whitespace, avoid_unnecessary_containers, prefer_const_constructors

import "package:flutter/material.dart";
import "package:google_ml_kit/google_ml_kit.dart";
import "package:image_picker/image_picker.dart";
import "dart:io";

class Ml extends StatefulWidget {
  const Ml({Key? key}) : super(key: key);

  @override
  _MlState createState() => _MlState();
}

class _MlState extends State<Ml> {
  var image = "";
  final textDetector = GoogleMlKit.vision.textDetector();
  func(String img) async {
    final inputImage = InputImage.fromFile(File(img));
    final RecognisedText recognisedText =
        await textDetector.processImage(inputImage);
    print("---------------");
    print(recognisedText.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: [
            Container(
              width: 300,
              height: 300,
              child: image != ""
                  ? Image.file(
                      File(image),
                    )
                  : Text("null"),
            ),
            ElevatedButton(
              onPressed: () async {
                ImagePicker picker = ImagePicker();
                var file = await picker.pickImage(source: ImageSource.camera);
                if (file != null) {
                  setState(() {
                    image = file.path;
                  });
                } else {
                  print("null");
                }
              },
              child: Text("pick"),
            ),
            ElevatedButton(
              onPressed: () async {
                func(image);
              },
              child: Text("get"),
            ),
          ],
        ),
      ),
    );
  }
}
