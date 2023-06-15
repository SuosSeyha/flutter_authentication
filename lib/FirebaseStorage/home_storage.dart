import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';
class HomeStorage extends StatefulWidget {
  const HomeStorage({super.key});

  @override
  State<HomeStorage> createState() => _HomeStorageState();
}

class _HomeStorageState extends State<HomeStorage> {
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  XFile? xFile;
  File? file;
  String? imageName;
  final ImagePicker picker = ImagePicker();
  // Compress image
  Future<File> compressImage(File file)async{
    File fileCompress = await FlutterNativeImage.compressImage(file.path,quality: 70);
    debugPrint('Before compress size =${file.lengthSync()}');
    debugPrint('After compress size=${fileCompress.lengthSync()}');
    return fileCompress;
  }
  Future<void> uploadImage({required String type})async{
    xFile = await picker.pickImage(source: type=='Camera'? ImageSource.camera: ImageSource.gallery);
    if(xFile!=null){
      setState(() async{
        file = File(xFile!.path);
        imageName=xFile!.name;
        // call method compressimage
        File fileCompress = await compressImage(file!);
        // Upload to firebase storage
        try{
          await firebaseStorage.ref(imageName).putFile(fileCompress);
        }on FirebaseException catch(e){
          // ignore: avoid_print
          print(e.message);
        }
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            uploadImage(type: 'Gallary');
          },
          icon: const Icon(
            Icons.image
          ),
        ),
        centerTitle: true,
        title: const Text('Firebase Storage'),
        actions: [
          IconButton(
          onPressed: () {
            uploadImage(type: 'Camera');
          },
          icon: const Icon(
            Icons.camera_alt
          ),
        ),
        ],
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(
              top: 10,
              right: 10,
              left: 10
            ),
            height: height/2 *0.6,
            width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.red
            ),
          );
        },
      ),
    );
  }
}