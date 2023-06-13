import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_11_12/CloudFireStore/model/student_model.dart';
import 'package:flutter_firebase_11_12/CloudFireStore/service/student_serive.dart';
import 'package:get/get.dart';
class StudentView extends StatefulWidget {
  const StudentView({super.key});

  @override
  State<StudentView> createState() => _StudentViewState();
}

class _StudentViewState extends State<StudentView> {
  final nameController = TextEditingController();
  final genderController = TextEditingController();
  final scoreController = TextEditingController();
  StudentService studentService = StudentService();
  final CollectionReference _tbstudent = FirebaseFirestore.instance.collection('tbstudent');
  Future<void> showForm()async{
    Get.defaultDialog(
      title: 'Enter Student Information',
      content: Container(
        //color: Colors.red,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  label: const Text('Name'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      20
                    )
                  )
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: genderController,
                decoration: InputDecoration(
                  label: const Text('Gender'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      20
                    )
                  )
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: scoreController,
                decoration: InputDecoration(
                  label: const Text('Score'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      20
                    )
                  )
                ),
              ),
            ),
          ],
        )
      ),
      onConfirm: () {  
        studentService.createStudent(
          Student(
            name: nameController.text, 
            gender: genderController.text, 
            score: double.parse(scoreController.text)
          )
        );  
        Get.back();
      },
      textConfirm: 'Create',
      confirmTextColor: Colors.white,
      buttonColor: Colors.pink,
      onCancel: () {
        
      },
      cancelTextColor: Colors.black
    );
  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Students View'),
      ),
      body: StreamBuilder(
        stream: _tbstudent.snapshots(),
        builder: (context, snapshot) {
          // Watting
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          // Has Error
          if(snapshot.hasError){
            return const Center(
              child: Text(
                'No data'
              ),
            );
          }
          // Success
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
             DocumentSnapshot documentSnapshot = snapshot.data!.docs[index];
            return  Card(
              child: ListTile(
                title: Text(documentSnapshot['name']),
                subtitle: Text(documentSnapshot['score'].toString()),
                trailing: Text(documentSnapshot['gender']),
              ),
            );
          },
        );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showForm(
           
          );
        },
        child: const Icon(
          Icons.add
        ),
      ),
    );
  }

}