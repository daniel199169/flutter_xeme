import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseAuth authInstance = FirebaseAuth.instance;
Firestore firestoreInstance = Firestore.instance;
final db = Firestore.instance;
final userCollection = Firestore.instance.collection("Users");
