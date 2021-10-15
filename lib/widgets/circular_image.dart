import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CircularImageWidget extends StatefulWidget {
  final Function(File image) onImageChanged;

  const CircularImageWidget({Key key, @required this.onImageChanged})
      : super(key: key);
  @override
  _CircularImageWidgetState createState() => _CircularImageWidgetState();
}

class _CircularImageWidgetState extends State<CircularImageWidget> {
  File _image;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 150,
        width: 150,
        decoration: const BoxDecoration(
          color: Colors.grey,
          shape: BoxShape.circle,
          // image: DecorationImage(
          //     fit: BoxFit.fill,
          //     image: _image != null ? AssetImage(_image.path) : null)
        ),
        child: _image == null
            ? const Icon(
                Icons.add_a_photo,
                color: Colors.white,
                size: 65,
              )
            : ClipOval(
                child: Image.file(
                _image,
                width: 120,
                height: 120,
                fit: BoxFit.scaleDown,
              )),
      ),
      onTap: () {
        getImage();
      },
    );
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      widget.onImageChanged(File(pickedFile.path));
    }
  }
}
