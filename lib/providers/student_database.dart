import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_example/screens/home_screen.dart';
import '../models/student_model.dart';

class StudentProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Student> _students = [];

  List<Student> get students => _students;

  // Fetch Students from Firestore
  Future<void> fetchStudents() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('students').get();
      _students = querySnapshot.docs.map((doc) => Student.fromFirestore(doc)).toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching students: $e');
    }
  }

  // Add or Update Student
  Future<void> addOrUpdateStudent(String? id, String name, int age, String email, String course, BuildContext context) async {
    try {
      if (id == null) {
        // Adding a new student
        DocumentReference docRef = await _firestore.collection('students').add({
          'name': name,
          'age': age,
          'email': email,
          'course': course,
        });

        _students.add(Student(id: docRef.id, name: name, age: age, email: email, course: course));
      } else {
        // Updating an existing student
        await _firestore.collection('students').doc(id).update({
          'name': name,
          'age': age,
          'email': email,
          'course': course,
        });

        int index = _students.indexWhere((student) => student.id == id);
        if (index != -1) {
          _students[index] = Student(id: id, name: name, age: age, email: email, course: course);
        }
      }

      notifyListeners();
      await fetchStudents(); // ✅ Refresh list after adding or updating

      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen())); // ✅ Close form after submission
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Student ${id == null ? 'added' : 'updated'} successfully!")),
      );
    } catch (e) {
      debugPrint('Error saving student: $e');
      _showErrorMessage(context, "Error saving student. Please try again.");
    }
  }

  // Show Delete Confirmation Dialog
  void showDeleteDialog(String id, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: Text("Delete Student"),
        content: Text("Are you sure you want to delete this student?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await deleteStudent(id, context);
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Delete Student from Firestore
  Future<void> deleteStudent(String id, BuildContext context) async {
    try {
      await _firestore.collection('students').doc(id).delete();
      _students.removeWhere((student) => student.id == id);
      notifyListeners();
      await fetchStudents(); // ✅ Refresh list after deletion

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Student deleted successfully!")),
      );
    } catch (e) {
      debugPrint('Error deleting student: $e');
      _showErrorMessage(context, "Error deleting student. Please try again.");
    }
  }

  // Show Error Messages
  void _showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, style: TextStyle(color: Colors.white))),
    );
  }
}
