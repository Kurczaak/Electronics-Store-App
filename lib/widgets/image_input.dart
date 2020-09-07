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

  void removePicture(int index) {
    setState(() {
      savedImages.removeAt(index);
    });
  }

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
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FlatButton.icon(
              icon: Icon(Icons.camera),
              label: Text('Zrób zdjęcie'),
              textColor: Theme.of(context).cursorColor,
              onPressed: _takePicture,
            ),
            FlatButton.icon(
              icon: Icon(Icons.perm_media),
              label: Text('Dodaj z galerii'),
              textColor: Theme.of(context).cursorColor,
              onPressed: _takePicture,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(
                savedImages.length.toString() + '/5',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Theme.of(context).hintColor,
                ),
              ),
            ),
          ],
        ),
        Container(
          height: MediaQuery.of(context).size.height / 5,
          child: savedImages.isEmpty
              ? Text(
                  'Brak zdjęć',
                  textAlign: TextAlign.center,
                )
              : GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 4, crossAxisCount: 1),
                  scrollDirection: Axis.horizontal,
                  children: [
                    ...(savedImages).map((img) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Stack(
                          children: [
                            Image.file(
                              img,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.white70,
                                child: IconButton(
                                  alignment: Alignment.center,
                                  icon: Icon(
                                    Icons.close,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    removePicture(savedImages.indexOf(img));
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
        ),
        SizedBox(width: 10),
      ],
    );
  }
}
