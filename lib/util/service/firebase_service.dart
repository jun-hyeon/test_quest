import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseServiceProvider = Provider<FirebaseService>((ref) {
  FirebaseService.instance.initialize();
  return FirebaseService.instance;
});

class FirebaseService {
  FirebaseService._();

  static final FirebaseService _instance = FirebaseService._();
  static FirebaseService get instance => _instance;

  late final FirebaseAuth _auth;
  FirebaseAuth get auth => _auth;

  late final FirebaseFirestore _firestore;
  FirebaseFirestore get firestore => _firestore;

  late final FirebaseStorage _storage;
  FirebaseStorage get storage => _storage;

  void initialize() {
    try {
      _auth = FirebaseAuth.instance;
      _firestore = FirebaseFirestore.instance;
      _storage = FirebaseStorage.instance;
      log('FirebaseService initialize success');
    } on FirebaseException catch (e) {
      log('FirebaseService initialize error: $e');
      rethrow;
    }
  }
}
