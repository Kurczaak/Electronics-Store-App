import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:multi_image_picker/multi_image_picker.dart';

import 'package:flutter_absolute_path/flutter_absolute_path.dart';

class ImageInput extends StatefulWidget {
  final onDelete;
  final returnNumImg;
  ImageInput(this.returnNumImg, this.onDelete);
  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  final List<File> savedImages = [];
  List<Asset> images = List<Asset>();

  void removePicture(int index) {
    setState(() {
      savedImages.removeAt(index);
    });
    widget.returnNumImg(savedImages.length);
  }

  Future<void> imagePicker() async {
    List<Asset> assetArray = [];
    List<File> fileImageArray = [];

    try {
      assetArray = await MultiImagePicker.pickImages(
        maxImages: 5 - savedImages.length,
        enableCamera: true,
        selectedAssets: assetArray,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "",
          actionBarTitle: "ImagePicker",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      print(e.toString());
    }

    assetArray.forEach((imageAsset) async {
      final filePath =
          await FlutterAbsolutePath.getAbsolutePath(imageAsset.identifier);

      File tempFile = File(filePath);
      if (tempFile.existsSync()) {
        fileImageArray.add(tempFile);
        setState(() {
          savedImages.add(tempFile);
          widget.returnNumImg(savedImages.length);
          widget.onDelete();
        });
      }
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
        widget.returnNumImg(savedImages.length);
        widget.onDelete();
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
              onPressed: savedImages.length < 5 ? _takePicture : null,
            ),
            FlatButton.icon(
              icon: Icon(Icons.perm_media),
              label: Text('Dodaj z galerii'),
              textColor: Theme.of(context).cursorColor,
              onPressed: savedImages.length < 5 ? imagePicker : null,
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
              ? Center(
                  child: Text(
                    'Brak zdjęć',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context).errorColor,
                        fontWeight: FontWeight.bold),
                  ),
                )
              : GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 4, crossAxisCount: 1),
                  scrollDirection: Axis.horizontal,
                  children: [
                    ...(savedImages)
                        .map((img) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Stack(
                              children: [
                                Image.file(
                                  img,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
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
                                        widget.onDelete();
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        })
                        .toList()
                        .reversed,
                  ],
                ),
        ),
        SizedBox(width: 10),
      ],
    );
  }
}
