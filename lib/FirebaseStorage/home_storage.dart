import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
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
  bool isLoading=false;
  // Refresh image
  Future <void>refreshImage()async{
    setState(() async{
      await downloadImage();
    });
    return Future.delayed(const Duration(seconds: 2));
  }
  // Compress image
  Future<File> compressImage(File file)async{
    File fileCompress = await FlutterNativeImage.compressImage(file.path,quality: 70);
    debugPrint('Before compress size =${file.lengthSync()}');
    debugPrint('After compress size=${fileCompress.lengthSync()}');
    return fileCompress;
  }
  Future<void> uploadImage({required String type})async{
    xFile = await picker.pickImage(source: type=='Camera'? ImageSource.camera: ImageSource.gallery);
    if(xFile==null) return;
     
        file = File(xFile!.path);
        imageName=xFile!.name;
        
        // call method compressimage
        File fileCompress = await compressImage(file!);
        // Upload to firebase storage
        
        try{
          setState(() {
            isLoading=true;
          });
          await firebaseStorage.ref(imageName).putFile(fileCompress);
          setState(() {
            isLoading=false;
          });
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Upload image successful')));
          // refresh
          //await downloadImage();
         // ignore: use_build_context_synchronously
         
        }on FirebaseException catch(e){
          // ignore: avoid_print
          print(e.message);
        }
  }

  Future<List> downloadImage()async{
    List<Map> files=[];
    final ListResult result = await firebaseStorage.ref().listAll();
    final List<Reference> allFiles = result.items;
    await Future.forEach(allFiles, (Reference file) async{
      final String fileUrl = await file.getDownloadURL();
      files.add({
        'url':fileUrl,
        'path':file.fullPath
      });
      debugPrint('url: $fileUrl');
      debugPrint('path: ${file.fullPath}');
    });
    return files;
  }

  Future <void> deleteImage(String imageName)async{
    await firebaseStorage.ref(imageName).delete();
    debugPrint(' Delete image successful.');
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
      body: isLoading ? const Center(
        child: CircularProgressIndicator(),
      ) : LiquidPullToRefresh(
        animSpeedFactor: 20,
        //backgroundColor: Colors.red,
        onRefresh: refreshImage,
        child: FutureBuilder(
          future: downloadImage(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if(snapshot.hasError){
              return const Center(
                child: Text('No image'),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final Map image = snapshot.data![index];
                return Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                        top: 10,
                        right: 10,
                        left: 10
                      ),
                      height: height/2 *0.6,
                      width: width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.red,
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(
                            image['url']
                          )
                        )
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 5,
                        right: 10
                      ),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            deleteImage(image['path']);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Delete image successful')));
                        }, 
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                          size: 30,
                        )),
                    )
                  ],
                );
              },
            );
          },
        ),
      )
    ); 
  }
}