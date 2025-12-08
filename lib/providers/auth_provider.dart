// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../models/admin_user.dart';
//
// class AuthProvider extends ChangeNotifier {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   AdminUser? _currentAdmin;
//   bool _isLoading = true;
//
//   AdminUser? get currentAdmin => _currentAdmin;
//   bool get isLoading => _isLoading;
//
//   AuthProvider() {
//     _initAuth();
//   }
//
//   // Initialize auth state
//   void _initAuth() async {
//     _auth.authStateChanges().listen((User? user) async {
//       if (user != null) {
//         await _loadAdminData(user.uid);
//       } else {
//         _currentAdmin = null;
//         _isLoading = false;
//         notifyListeners();
//       }
//     });
//   }
//
//   // Load admin data from Firestore
//   Future<void> _loadAdminData(String uid) async {
//     try {
//       DocumentSnapshot doc = await _firestore.collection('admins').doc(uid).get();
//       if (doc.exists) {
//         _currentAdmin = AdminUser.fromFirestore(doc);
//       } else {
//         _currentAdmin = null;
//         await _auth.signOut();
//       }
//     } catch (e) {
//       print('Error loading admin data: $e');
//       _currentAdmin = null;
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   // Admin Login
//   Future<String?> login(String email, String password) async {
//     try {
//       UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//
//       // Check if user is an admin
//       DocumentSnapshot adminDoc = await _firestore
//           .collection('admins')
//           .doc(userCredential.user!.uid)
//           .get();
//
//       if (!adminDoc.exists) {
//         await _auth.signOut();
//         return 'আপনি একজন অ্যাডমিন নন';
//       }
//
//       return null; // Success
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'user-not-found') {
//         return 'এই ইমেইল দিয়ে কোন অ্যাকাউন্ট নেই';
//       } else if (e.code == 'wrong-password') {
//         return 'ভুল পাসওয়ার্ড';
//       } else if (e.code == 'invalid-email') {
//         return 'ভুল ইমেইল ফরম্যাট';
//       } else {
//         return 'লগইন করতে সমস্যা হয়েছে: ${e.message}';
//       }
//     } catch (e) {
//       return 'একটি সমস্যা হয়েছে: $e';
//     }
//   }
//
//   // Admin Registration
//   Future<String?> register(String email, String password, String fullName) async {
//     try {
//       UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//
//       // Create admin document
//       AdminUser newAdmin = AdminUser(
//         uid: userCredential.user!.uid,
//         email: email,
//         fullName: fullName,
//         role: 'admin',
//         createdAt: DateTime.now(),
//       );
//
//       await _firestore
//           .collection('admins')
//           .doc(userCredential.user!.uid)
//           .set(newAdmin.toFirestore());
//
//       return null; // Success
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'weak-password') {
//         return 'পাসওয়ার্ড খুবই দুর্বল';
//       } else if (e.code == 'email-already-in-use') {
//         return 'এই ইমেইল ইতিমধ্যে ব্যবহৃত হয়েছে';
//       } else if (e.code == 'invalid-email') {
//         return 'ভুল ইমেইল ফরম্যাট';
//       } else {
//         return 'রেজিস্ট্রেশন করতে সমস্যা হয়েছে: ${e.message}';
//       }
//     } catch (e) {
//       return 'একটি সমস্যা হয়েছে: $e';
//     }
//   }
//
//   // Logout
//   Future<void> logout() async {
//     await _auth.signOut();
//     _currentAdmin = null;
//     notifyListeners();
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/admin_user.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AdminUser? _currentAdmin;
  bool _isLoading = true;

  AdminUser? get currentAdmin => _currentAdmin;
  bool get isLoading => _isLoading;

  AuthProvider() {
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    _isLoading = true;
    notifyListeners();

    User? user = _auth.currentUser;

    if (user != null) {
      // Check if user is admin
      DocumentSnapshot adminDoc = await _firestore
          .collection('admins')
          .doc(user.uid)
          .get();

      if (adminDoc.exists) {
        _currentAdmin = AdminUser.fromFirestore(adminDoc);
        print('✅ Admin logged in: ${_currentAdmin?.fullName}');
      } else {
        print('❌ User is not an admin');
        await _auth.signOut();
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<String?> signin(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Check if user is admin
      DocumentSnapshot adminDoc = await _firestore
          .collection('admins')
          .doc(credential.user!.uid)
          .get();

      if (!adminDoc.exists) {
        await _auth.signOut();
        return 'আপনি অ্যাডমিন নন';
      }

      _currentAdmin = AdminUser.fromFirestore(adminDoc);
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'ইউজার খুঁজে পাওয়া যায়নি';
      } else if (e.code == 'wrong-password') {
        return 'ভুল পাসওয়ার্ড';
      }
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    _currentAdmin = null;
    notifyListeners();
  }
}