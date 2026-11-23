import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseReference {
  static final FirebaseStorage storage = FirebaseStorage.instance;
  static final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  static final CollectionReference<Map<String, dynamic>> admins = firestore.collection('admins');
  static final CollectionReference<Map<String, dynamic>> mothers = firestore.collection('New Mothers');
  static final CollectionReference<Map<String, dynamic>> healthProfessionals = firestore.collection('Health Professionals');
  static final CollectionReference<Map<String, dynamic>> hospitals = firestore.collection('health_facilities');



}