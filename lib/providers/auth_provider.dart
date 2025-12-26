//
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../models/admin_user.dart';
//
// class AuthProvider with ChangeNotifier {
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
//     _checkAuthState();
//   }
//
//   Future<void> _checkAuthState() async {
//     _isLoading = true;
//     notifyListeners();
//
//     User? user = _auth.currentUser;
//
//     if (user != null) {
//       // Check if user is admin
//       DocumentSnapshot adminDoc = await _firestore
//           .collection('admins')
//           .doc(user.uid)
//           .get();
//
//       if (adminDoc.exists) {
//         _currentAdmin = AdminUser.fromFirestore(adminDoc);
//         print('✅ Admin logged in: ${_currentAdmin?.fullName}');
//       } else {
//         print('❌ User is not an admin');
//         await _auth.signOut();
//       }
//     }
//
//     _isLoading = false;
//     notifyListeners();
//   }
//
//   Future<String?> signin(String email, String password) async {
//     try {
//       UserCredential credential = await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//
//       // Check if user is admin
//       DocumentSnapshot adminDoc = await _firestore
//           .collection('admins')
//           .doc(credential.user!.uid)
//           .get();
//
//       if (!adminDoc.exists) {
//         await _auth.signOut();
//         return 'আপনি অ্যাডমিন নন';
//       }
//
//       _currentAdmin = AdminUser.fromFirestore(adminDoc);
//       notifyListeners();
//       return null;
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'user-not-found') {
//         return 'ইউজার খুঁজে পাওয়া যায়নি';
//       } else if (e.code == 'wrong-password') {
//         return 'ভুল পাসওয়ার্ড';
//       }
//       return e.message;
//     } catch (e) {
//       return e.toString();
//     }
//   }
//
//   Future<void> logout() async {
//     await _auth.signOut();
//     _currentAdmin = null;
//     notifyListeners();
//   }
// }
//


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
      try {
        // 'users' কালেকশন থেকে চেক করা হচ্ছে যেখানে role = 'admin'
        DocumentSnapshot userDoc = await _firestore
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists && userDoc.get('role') == 'admin') {
          _currentAdmin = AdminUser.fromFirestore(userDoc);
          print('✅ Admin logged in: ${_currentAdmin?.fullName}');
        } else {
          print('❌ Unauthorized access attempt');
          await _auth.signOut();
          _currentAdmin = null;
        }
      } catch (e) {
        print('Error checking auth state: $e');
        _currentAdmin = null;
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

      // অ্যাডমিন কি না তা 'users' কালেকশনের 'role' ফিল্ড থেকে চেক করা হচ্ছে
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(credential.user!.uid)
          .get();

      if (!userDoc.exists || userDoc.get('role') != 'admin') {
        await _auth.signOut();
        return 'আপনার অ্যাডমিন এক্সেস নেই। অনুগ্রহ করে কর্তৃপক্ষের সাথে যোগাযোগ করুন।';
      }

      _currentAdmin = AdminUser.fromFirestore(userDoc);
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') return 'ইউজার খুঁজে পাওয়া যায়নি';
      if (e.code == 'wrong-password') return 'ভুল পাসওয়ার্ড';
      return e.message;
    } catch (e) {
      return 'একটি সমস্যা হয়েছে: ${e.toString()}';
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    _currentAdmin = null;
    notifyListeners();
  }
}