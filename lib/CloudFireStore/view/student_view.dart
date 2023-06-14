import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_11_12/CloudFireStore/model/student_model.dart';
import 'package:flutter_firebase_11_12/CloudFireStore/service/student_serive.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
  void clear(){
    nameController.clear();
    genderController.clear();
    scoreController.clear();
  }
  Future<void> showForm(Student? student,DocumentSnapshot? documentSnapshot)async{
    // check
    if(student !=null || documentSnapshot !=null){
      nameController.text = student!.name;
      genderController.text=student.gender;
      scoreController.text=student.score.toString();
    }

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
               // keyboardType: TextInputType.number,
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
      barrierDismissible: false,
      onConfirm: () {  
        if(student==null){
          studentService.createStudent(
          Student(
            name: nameController.text, 
            gender: genderController.text, 
            score: int.parse(scoreController.text)
          )
        );  
        }else{
          studentService.updateStudent(
            Student(
              name: nameController.text, 
              gender: genderController.text, 
              score: int.parse(scoreController.text)
            ), 
            documentSnapshot!
            );
        }
        clear();
        Get.back();
      },
      textConfirm: student !=null ? 'Update': 'Create',
      confirmTextColor: Colors.white,
      buttonColor: Colors.pink,
      onCancel: () {
        clear();
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
            return  Slidable(
                endActionPane:  ActionPane(
                  motion: DrawerMotion(), 
                  children: [
                    SlidableAction(
                      autoClose: true,
                      borderRadius: BorderRadius.circular(20),
                      foregroundColor: Colors.blue,
                      //backgroundColor: Colors.yellow,
                      label: 'Edit',
                      icon: Icons.edit,
                      onPressed: (context) {
                        
                        showForm(
                          Student(
                          name: documentSnapshot['name'],
                           gender: documentSnapshot['gender'],
                            score: documentSnapshot['score']
                          ), 
                          documentSnapshot
                          );
                      },
                    ),
                    SlidableAction(
                      autoClose: true,
                      foregroundColor: Colors.red,
                      label: 'Delete',
                      icon: Icons.delete,
                      onPressed: (context) {
                        studentService.deleteStudent(documentSnapshot);
                      },
                    )
                  ]
                ),
                child: Card(
                child: ListTile(
                  tileColor: Colors.blueGrey,
                  title: Text(
                    documentSnapshot['name'],
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                    ),
                  subtitle: Text(
                    documentSnapshot['score'].toString(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    ),
                  trailing: Text(
                    documentSnapshot['gender'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,  
                    ),
                    ),
                ),
              ),
            );
          },
        );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showForm(null,null);
        },
        child: const Icon(
          Icons.add
        ),
      ),
    );
  }

}