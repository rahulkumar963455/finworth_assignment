import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// 🟢 Model Class
class Student {
  final String id;
  final String name;
  final int age;
  final String email;
  final String course;

  Student({required this.id, required this.name, required this.age, required this.email, required this.course});

  factory Student.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Student(
      id: doc.id,
      name: data['name'] ?? '',
      age: data['age'] ?? 0,
      email: data['email'] ?? '',
      course: data['course'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'age': age, 'email': email, 'course': course};
  }
}