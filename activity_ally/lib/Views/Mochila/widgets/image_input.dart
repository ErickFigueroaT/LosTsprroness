import 'dart:io';
import 'package:activity_ally/ImageLoader.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {

  const ImageInput({super.key, required this.onPickImage, this.initialImagePath,});

  final void Function(File image) onPickImage;
  final String? initialImagePath;

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? seleccion;

  void initState(){
    super.initState();
    if(widget.initialImagePath != null){
      loadInitialImage();
    }
  }

  void loadInitialImage() {
    var initialImage = ImageLoader.loadImage(widget.initialImagePath);
    setState(() {
      if (initialImage is FileImage) {
        seleccion = File(widget.initialImagePath!);
        widget.onPickImage(seleccion!);
      }
    });
  }

  void elegirImagen() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );

    if (pickedImage == null) {
      return;
    }

    setState(() {
      seleccion = File(pickedImage.path);
      //print(seleccion);
      //print(pickedImage.path);
    });

    widget.onPickImage(seleccion!);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
        onPressed: () {
          elegirImagen();
        },
        icon: const Icon(Icons.camera),
        label: const Text('Elegir imagen'));

    if (seleccion != null) {
      content = GestureDetector(
          onTap: elegirImagen,
          child: Image.file(
            seleccion!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ));
    }

    return Container(
        decoration: BoxDecoration(
            border: Border.all(
                width: 1,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.2))),
        height: 250,
        width: double.infinity,
        child: content);
  }
}
