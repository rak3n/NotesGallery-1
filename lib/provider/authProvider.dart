import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:notes_gallery/utils/give_exception.dart';

class Authentication with ChangeNotifier {
  String? _token;
  String? _userId;
  DateTime? _expiryDate;
  String? _status;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String? get status {
    return _status;
  }

  String? get userId {
    return _userId;
  }

  // String get userId {
  //   return _userId;
  // }
  //f
  Future<String?> signIn(
    String email,
    String password,
  ) async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    try {
      UserCredential user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print(" USER user detail-:  ${user.user}");
      print(" USER additional user info  detail-:  ${user.additionalUserInfo}");
      print(" USER credential detail-:  ${user.credential}");
      _userId = user.user!.uid;

      _status = "successful";
      notifyListeners();

      return status;
    } on FirebaseAuthException catch (e) {
      _status = AuthExceptionHandler.handleException(e);
      notifyListeners();

      return status;
    }
  }

  Future<String?> signUp(
    String email,
    String password,
  ) async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    try {
      UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print(user);

      _userId = user.user!.uid;
      _status = "successful";
      notifyListeners();

      return status;
    } on FirebaseAuthException catch (e) {
      _status = AuthExceptionHandler.handleException(e);
      notifyListeners();

      return status;
    }
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyBqFBMKeLjnLeqSBCtfXj3jog6g7K0QH4I';
    //this both are genrated by firebase

    try {
      final response = await http.post(
        Uri(path: url),
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );

      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      //if response data is not null ie it has get values do this\

      _token = responseData['idToken'];
      _userId = responseData["localId"];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  // Future<void> signUp(String? email, String? password) async {
  //   return _authenticate(email!, password!, 'signUp');
  // }

  // Future<void> signIn(String? email, String? password) async {
  //   return _authenticate(email!, password!, 'signInWithPassword');
  // }
}
