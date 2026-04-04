import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:khedma/Core/constants/app_emums.dart';
import 'package:khedma/Core/errors/extentions.dart';
import 'package:khedma/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> loginWithEmail(
    UserType userType,
    String email,
    String password,
  );
  Future<UserModel> registerWithEmail(
    UserType userType,
    String email,
    String password,
  );
  Future<UserModel> loginWithGoogle(UserType userType);
  Future<UserModel> loginWithFacebook(UserType userType);
  Future<void> sendEmailVerification();
  Future<bool> checkEmailVerified();
  Future<void> sendPasswordResetEmail(String email);
  Future<void> logout();
  Future<void> updateUserProfile({
    String? name,
    String? phone,
    LocationModel? location,
    XFile? imageFile,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _firestore;
  final FacebookAuth _facebookAuth;

  AuthRemoteDataSourceImpl({
    required FirebaseAuth firebaseAuth,
    required GoogleSignIn googleSignIn,
    required FirebaseFirestore firestore,
    required FacebookAuth facebookAuth,
  }) : _firebaseAuth = firebaseAuth,
       _googleSignIn = googleSignIn,
       _firestore = firestore,
       _facebookAuth = facebookAuth;

  // دالة مساعدة لإنشاء أو تحديث مستند المستخدم في Firestore
  Future<UserModel> _getOrCreateUser(User user, UserType userType) async {
    final userDoc = _firestore.collection('users').doc(user.uid);
    final docSnapshot = await userDoc.get();

    if (docSnapshot.exists) {
      // المستخدم موجود مسبقاً، نعيد البيانات
      return UserModel.fromFirestore(docSnapshot.data()!, uid: user.uid);
    } else {
      // مستخدم جديد، ننشئ له مستنداً
      final newUser = UserModel(
        id: user.uid,
        email: user.email!,
        name: user.displayName,
        profileImageUrl: user.photoURL,
        location: null,
        phone: null,
        isEmailVerified: user.emailVerified,
        isLocationSelected: false,
        isProfileCompleted: false,
        userType: userType,
      );
      await userDoc.set(newUser.toFirestore());
      return newUser;
    }
  }

  @override
  Future<UserModel> loginWithEmail(
    UserType userType,
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user!;
      return await _getOrCreateUser(user, userType);
    } on FirebaseAuthException catch (e) {
      log(e.toString());
      throw FirebaseErrorHandle.handle(e);
    } catch (e) {
      log('un know : $e');
      throw UnKnowException(message: e.toString());
    }
  }

  @override
  Future<UserModel> registerWithEmail(
    UserType userType,
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user!;
      return await _getOrCreateUser(user, userType);
    } on FirebaseAuthException catch (e) {
      throw FirebaseErrorHandle.handle(e);
    } catch (e) {
      throw UnKnowException(message: e.toString());
    }
  }

  // يجب ان يتم التعريف اولا قبل اى شئ
  Future<void> _intializeGoogle() async {
    await _googleSignIn.initialize(
      clientId: null, // الخاص بال ios اختبارى ولا يوجد مشكله منه
      serverClientId:
          '', // يجب ان يضاف لان بدونه لا يشتغل على ال Android and Wep
    );
  }

  @override
  Future<UserModel> loginWithFacebook(UserType userType) async {
    try {
      final LoginResult result = await _facebookAuth.login();
      if (result.status != LoginStatus.success) {
        throw Exception('فشل تسجيل الدخول');
      }
      final OAuthCredential credential = FacebookAuthProvider.credential(
        result.accessToken!.token,
      );
      final UserCredential userCredential = await _firebaseAuth
          .signInWithCredential(credential);
      return await _getOrCreateUser(userCredential.user!, userType);
    } on FirebaseAuthException catch (e) {
      throw FirebaseErrorHandle.handle(e);
    } catch (e) {
      throw UnKnowException(message: e.toString());
    }
  }

  @override
  Future<UserModel> loginWithGoogle(UserType userType) async {
    try {
      await _intializeGoogle();
      final GoogleSignInAccount googleUser = await _googleSignIn
          .authenticate(); // فتح شاشة التسجيل
      final GoogleSignInAuthentication googleAuth =
          googleUser.authentication; // الحصول على معلومات المسنتخدم لعد التسجيل
      final scope = <String>['email', 'profile', 'openid'];
      final authClient = _googleSignIn.authorizationClient;
      var authorization = await authClient.authorizationForScopes(scope);
      if (authorization == null) {
        final authoriseResult = await authClient.authorizationForScopes(scope);
        if (authoriseResult!.accessToken.isEmpty) {
          throw Exception('فشل الحصول على التفويض');
        }
        authorization = authoriseResult;
      }

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: authorization.accessToken,
      );

      final UserCredential userCredential = await _firebaseAuth
          .signInWithCredential(credential);
      if (userCredential.user == null) {
        throw Exception('فشل تسجيل الدخول الى Firebase');
      }
      return await _getOrCreateUser(userCredential.user!, userType);
    } on GoogleSignInException catch (e) {
      log(e.toString());
      throw GoogleErrorHandle.handle(e);
    } on FirebaseAuthException catch (e) {
      throw FirebaseErrorHandle.handle(e);
    } catch (e) {
      throw UnKnowException(message: 'خطأ غير متوقع ${e.toString()}');
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    try {
      await _firebaseAuth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw FirebaseErrorHandle.handle(e);
    } catch (e) {
      throw UnKnowException(message: e.toString());
    }
  }

  @override
  Future<bool> checkEmailVerified() async {
    try {
      await _firebaseAuth.currentUser?.reload();
      return _firebaseAuth.currentUser?.emailVerified ?? false;
    } on FirebaseAuthException catch (e) {
      throw FirebaseErrorHandle.handle(e);
    } catch (e) {
      throw UnKnowException(message: e.toString());
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw FirebaseErrorHandle.handle(e);
    } catch (e) {
      throw UnKnowException(message: e.toString());
    }
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
    await FacebookAuth.instance.logOut();
  }

  @override
  Future<void> updateUserProfile({
    String? name,
    String? phone,
    LocationModel? location,
    XFile? imageFile,
  }) async {
    try {
      final uid = _firebaseAuth.currentUser?.uid;
      if (uid == null) throw AuthException(message: 'Not authenticated');

      final Map<String, dynamic> updates = {};

      if (name != null) updates['name'] = name;
      if (phone != null) updates['phone'] = phone;
      if (location != null) updates['location'] = location;

      // رفع الصورة إذا وجدت
      // if (imageFile != null) {
      //   final ref = _storage.ref().child('profile_images/$uid');
      //   await ref.putFile(await imageFile.readAsBytes());
      //   final imageUrl = await ref.getDownloadURL();
      //   updates['profileImageUrl'] = imageUrl;
      // }

      if (updates.isNotEmpty) {
        await _firestore.collection('users').doc(uid).update(updates);
      }
    } on FirebaseAuthException catch (e) {
      throw FirebaseErrorHandle.handle(e);
    } catch (e) {
      throw UnKnowException(message: e.toString());
    }
  }
}

class FirebaseErrorHandle {
  static Exception handle(FirebaseAuthException error) {
    switch (error.code) {
      case "user-not-found":
        return AuthException(message: "the User is not found");
      case 'wrong-password':
        return ValidationException(message: "The Password is Wrong");
      case 'email-already-in-use':
        return ValidationException(message: "Email Already In Use");
      case 'invalid-email':
        return ValidationException(message: "email is not validation");
      case 'weak-password':
        return ValidationException(message: "The Password Is Very Weak");
      case 'network-request-failed':
        return NetworkException(message: 'Check The Enternet Connection');
      case 'too-many-requests':
        return ServerException(message: 'That is too many requests');
      default:
        return UnKnowException(
          message: error.message ?? "Something Wrong Throw Authintecation",
        );
    }
  }
}

class GoogleErrorHandle {
  static Exception handle(GoogleSignInException error) {
    switch (error.code) {
      case GoogleSignInExceptionCode.canceled:
        return ServerException(message: "Google Sign in is Canceld");
      case GoogleSignInExceptionCode.interrupted:
        return ServerException(message: "Google sign in is Interrupted");
      case GoogleSignInExceptionCode.uiUnavailable:
        return ValidationException(
          message: "This device Not Allow To Google Sign in",
        );
      default:
        // log("e.description : ${e.description} - e.details : ${e.details}");
        return UnKnowException(
          message:
              "Faild To Sign in By Google in DatanSourse ${error.description} - ${error.details}",
        );
    }
  }
}
