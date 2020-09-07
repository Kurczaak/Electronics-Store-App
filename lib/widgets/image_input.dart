import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class ImageInput extends StatefulWidget {
  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  final List<File> savedImages = [];

  Future<void> _takePicture() async {
    final picker = ImagePicker();
    final image = await picker.getImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );
    if (image == null)
      return;
    else {
      final imageFile = File(image.path);
      final appDir = await syspaths.getApplicationDocumentsDirectory();
      final fileName = path.basename(imageFile.path);
      final storedImage = await imageFile.copy('${appDir.path}/$fileName');

      setState(() {
        savedImages.add(storedImage);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: savedImages.isEmpty
              ? Text(
                  'Brak zdjęcia',
                  textAlign: TextAlign.center,
                )
              : GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  children: [
                    ...(savedImages).map((img) {
                      return Image.file(
                        img,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      );
                    }).toList(),
                  ],
                ),
          alignment: Alignment.center,
        ),
        SizedBox(width: 10),
        Expanded(
          child: FlatButton.icon(
            icon: Icon(Icons.camera),
            label: Text('Zrób zdjęcie'),
            textColor: Theme.of(context).cursorColor,
            onPressed: _takePicture,
          ),
        ),
      ],
    );
  }
}
