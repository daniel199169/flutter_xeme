import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xenome/models/User.dart';
import 'package:xenome/utils/session_manager.dart';
import 'basic_firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password);

  Future<String> signUp(String tellusname, String email, String password);

  Future<FirebaseUser> getCurrentUser();

  Future<User> getUserInfo(String userId);

  Future<bool> setUserInfo(User user);

  Future<void> sendEmailVerification();

  Future<bool> signOut();

  Future<bool> isEmailVerified();

  Future<void> updateImage(String image, String userId);
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signIn(String email, String password) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    print('--------><-------: Firebase User: ' + user.toString());
    return user.uid;
  }

  Future<String> signUp(
    String tellusname, String email, String password) async {
    print("signUp before");
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    print(result);
    FirebaseUser user = result.user;
    try {

      //register firestore
      await userCollection
          .document(user.uid)
          .setData({
        "uid": user.uid,
        "tellusname": tellusname,
        "email": email,
        "image":
         "https://firebasestorage.googleapis.com/v0/b/xenome-mobile.appspot.com/o/profiles%2Fuser_big_outlined%402x.png?alt=media&token=5707511f-cdcd-4bf8-b49e-fde668bcd4f5",
        "permission" : "free"
      })
          .then((result) => {})
          .catchError((err) => print(err));
      return user.uid;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<String> signUpWithGoogle(
      String tellusname, String email, String uid, String imageUrl) async {
    try {

      //register firestore
      await userCollection
          .document(uid)
          .setData({
        "uid": uid,
        "tellusname": tellusname,
        "email": email,
        "image":imageUrl,
        "permission" : "free"
      })
          .then((result) => {})
          .catchError((err) => print(err));
      return uid;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<bool> signOut() async {
    await FirebaseAuth.instance.signOut();
    return true;
  }

  //  Get User Information
//  Future<User> getUserInfo(String userId) async {
//    final TransactionHandler txHandler = (Transaction tx) async {
//      DocumentSnapshot ds = await tx.get(userCollection.document(userId));
//      if (!ds.exists) return null;
//      return ds.data;
//  };
//    return db.runTransaction(txHandler).then((res) {
//      if (res == null || res.isEmpty) return null;
//      return User.fromJson(res);
//    }).catchError((error) {
//      print(error);
//      return null;
//    });
//  }

  Future<User> getUserInfo(String uid) async {
    QuerySnapshot docSnapShot = await db
        .collection('Users')
        .where('uid', isEqualTo: uid)
        .getDocuments();
    if (docSnapShot == null || docSnapShot.documents.length == 0) {
      return null;
    }
    return User.fromJson(docSnapShot.documents[0].data);
  }



  Future<bool> setUserInfo(User user) async {
    var userId = SessionManager.getUserId();
    print("start");
    final TransactionHandler txHandler = (Transaction tx) async {
      DocumentSnapshot ds = await tx.get(userCollection.document(userId));
      await tx.set(ds.reference, user.toJson());
      print("++++++++++++++++++++");
      print("update request");
      return {'updated': true};
    };

    return db.runTransaction(txHandler).then((res) {
      return res['updated'] as bool;
    }).catchError((error) {
      print(error);
      return false;
    });
  }

  Future<void> updateImage(String image, String userId) async {
    QuerySnapshot docSnapShot = await db
        .collection('Users')
        .where('uid', isEqualTo: userId)
        .getDocuments();
    if (docSnapShot == null) return;
    docSnapShot.documents[0].reference.updateData({'image': image});
    SessionManager.setImage(image);
  }

  /////////////////////////////////////////////////
  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }

// Get User Information
//  Future<User> getUserInfo(String userId) async {
//    final TransactionHandler txHandler = (Transaction tx) async {
//      DocumentSnapshot ds = await tx.get(userCollection.document(userId));
//      if (!ds.exists) return null;
//      return ds.data;
//    };
//    return db.runTransaction(txHandler).then((res) {
//      if (res == null || res.isEmpty) return null;
//      return User.fromJson(res);
//    }).catchError((error) {
//      print(error);
//      return null;
//    });
//  }

//
//  static String verificationId;
//
//  // Get Current Firebase Authenticated User Instance
//  static Future<FirebaseUser> getCurrentUser() async {
//    final FirebaseUser user = await authInstance.currentUser();
//    return user;
//  }
//
//  // Signin with email and password
//  static Future<dynamic> signIn(String email, String password) async {
//    AuthResult user = await authInstance.signInWithEmailAndPassword(email: email, password: password);
//    print("sign info user $user.user");
//    return user.user.uid;
//  }
//
//  static Future<String> registerUser(String tellusname, String email, String password) async {
//    print("registering...");
//    AuthResult result = await authInstance.createUserWithEmailAndPassword(email: email, password: password);
//    FirebaseUser user = result.user;
//    try {
//      //register firestore
//      await userCollection.document(user.uid).setData({
//        "uid": user.uid,
//        "tellusname": tellusname,
//        "email": email,
//        })
//        .then((result) => {})
//        .catchError((err) => print(err));
//      return user.uid;
//    } catch (e) {
//      print(e);
//      return null;
//    }
//  }
//
//  static Future<bool> logOut() async {
//    await authInstance.signOut();
//    return true;
//  }
//
//
//  //////////////////////////////////////////////////////////
//  static Future<bool> loggedIn() async {
//    var user = await await authInstance.currentUser();
//    if (user != null) {
//      return true;
//    } else {
//      return false;
//    }
//  }
//
//  // Get Current Firebase Authenticated User ID
//  static Future<String> getFirebaseUserId() async {
//    final FirebaseUser user = await authInstance.currentUser();
//    return user.uid;
//  }
//
//  // Get all User List
//  static Future<List<User>> getAllUser() async {
//    var querySnapshot = await userCollection.getDocuments();
//    if (querySnapshot == null) return [];
//    return querySnapshot.documents
//            .map((snapshot) => User.fromJson(snapshot.data))
//            ?.toList() ??
//        [];
//  }
//
//  // Get User Information
//  static Future<User> getUserInfo() async {
//    var userId = await Auth.getFirebaseUserId();
//    final TransactionHandler txHandler = (Transaction tx) async {
//      DocumentSnapshot ds = await tx.get(userCollection.document(userId));
//      if (!ds.exists) return null;
//      return ds.data;
//    };
//    return db.runTransaction(txHandler).then((res) {
//      if (res == null || res.isEmpty) return null;
//      return User.fromJson(res);
//    }).catchError((error) {
//      print(error);
//      return null;
//    });
//  }
//  static Future<User> getUserInfoById(String userId) async {
//    DocumentSnapshot docRef = await userCollection.document(userId).get();
//    print("-----> ${docRef.data}");
//    return User.fromJson(docRef.data);
//  }
//
//  static Future<bool> setUserInfo(User user) async {
//    var userId = SessionManager.getUserId();
//    final TransactionHandler txHandler = (Transaction tx) async {
//      DocumentSnapshot ds = await tx.get(userCollection.document(userId));
//      await tx.set(ds.reference, user.toJson());
//    return {'updated': true};
//    };
//
//    return db.runTransaction(txHandler).then((res) {
//      return res['updated'] as bool;
//    }).catchError((error) {
//      print(error);
//      return false;
//    });
//  }
//
//  static Future<bool> updateUserInfo(Map<String, String> payload) async {
//    var userId = await getFirebaseUserId();
//    try {
//      await firestoreInstance.collection('Users').document(userId).updateData({
//        'name': payload['name'],
//        'gender': payload['gender'],
//        'birthday': payload['birthday'],
//        'email': payload['email'],
//        'code': payload['code']
//      });
//      return true;
//    } catch (e) {
//      print(e);
//      return false;
//    }
//  }
//
//  static Future<bool> updateUserRole(String userId, String roleStr) async {
//    try {
//      await firestoreInstance.collection('Users').document(userId).updateData({
//         'role': roleStr
//      });
//      return true;
//    } catch(e){
//      print(e);
//      return false;
//    }
//  }
}
