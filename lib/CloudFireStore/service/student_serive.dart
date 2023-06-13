import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/student_model.dart';
class StudentService{
  // CRUD firestore
  final CollectionReference _tbstudent = FirebaseFirestore.instance.collection('tbstudent');
  // create
  Future<void> createStudent(Student student)async{
    await _tbstudent.add(student.toMap());
    print('>> create student successful.');
  } 
  // read
  
  // update
  Future<void> updateStudent(Student student,DocumentSnapshot documentSnapshot)async{
    await _tbstudent.doc(documentSnapshot.id).update(student.toMap());
    print('>> update student successful.');
  }
  // delete
  Future<void> deleteStudent(DocumentSnapshot documentSnapshot)async{
    await _tbstudent.doc(documentSnapshot.id).delete();
    print('>> delete student successful');
  }
}