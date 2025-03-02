import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/student_model.dart';
import '../screens/home_screen.dart'; // Import HomeScreen

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

  // Add Student with Duplicate Email Check
  Future<void> addStudent(String name, int age, String email, String course, BuildContext context) async {
    try {
      // Check if email already exists
      QuerySnapshot existingEmails = await _firestore
          .collection('students')
          .where('email', isEqualTo: email)
          .get();

      if (existingEmails.docs.isNotEmpty) {
        // Show Alert if Email Already Exists
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("A student with this email already exists!")),
        );
        return; // Do NOT navigate back
      }

      // Add student if email is unique
      DocumentReference docRef = await _firestore.collection('students').add({
        'name': name,
        'age': age,
        'email': email,
        'course': course,
      });

      _students.add(Student(id: docRef.id, name: name, age: age, email: email, course: course));
      notifyListeners();

      // ✅ Move to HomeScreen after adding student
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Student added successfully!")),
      );

    } catch (e) {
      debugPrint('Error adding student: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error adding student. Please try again.")),
      );
    }
  }

  // Show Delete Confirmation Dialog
  void showDeleteDialog(String id, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Student"),
        content: Text("Are you sure you want to delete this student?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Cancel
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              deleteStudent(id, context); // Confirm Delete
              Navigator.pop(context);
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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Student deleted successfully!")),
      );
    } catch (e) {
      debugPrint('Error deleting student: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting student. Please try again.")),
      );
    }
  }
}
