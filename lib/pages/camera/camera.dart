import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class Camera extends StatefulWidget {
  const Camera({Key? key}) : super(key: key);

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  File? image;
  final imagePicker = ImagePicker();

  Future getImage() async {
    try {
      final image = await ImagePicker.platform.getImage(
          source: ImageSource.camera,
          preferredCameraDevice: CameraDevice.front);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print("Failed to pick image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.camera_alt_rounded),
      ),
      body: Center(
          child: image != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.file(
                      image!,
                      height: 160,
                      width: 160,
                    ),
                    IconButton(
                        onPressed: () => setState(() {
                              image = null;
                            }),
                        icon: Icon(Icons.close))
                  ],
                )
              : Text("No Image Selected")),
    );
  }
}
