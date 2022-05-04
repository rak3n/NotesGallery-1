import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:notes_gallery/utils/give_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authentication with ChangeNotifier {
  String? _token;
  String? _userId;
  DateTime? _expiryDate;
  String _status = '';
  bool? _isAdmin;

  bool get isAuth {
    return token != null;
  }

  bool? get isAdmin {
    return _isAdmin;
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
      IdTokenResult? idTokenResult = await user.user?.getIdTokenResult(true);
      print(" User user-> result  ${idTokenResult!.claims!['user_id']}");
      _userId = idTokenResult.claims?['user_id'] ?? "";
      _status = "successful";

      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      prefs.setString('userId', _userId ?? "");

      return status;
    } on FirebaseAuthException catch (e) {
      _status = AuthExceptionHandler.handleException(e);
      notifyListeners();

      return status;
    }
  }

  Future<bool> autoLogin() async {
    print("hitssss");
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("userId")) {
      return false;
    }
    final uid = prefs.getString("userId");
    if (uid == "") {
      return false;
    }
    _userId = uid;
    notifyListeners();
    print("yha tk aaya");
    return true;
  }

  void logout() async {
    print("hitted");
    _userId = null;
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    notifyListeners();
  }

  Future<String?> _authenticate(
      String email, String password, String urlSegment) async {
    String? url = 'https://protected-waters-32301.herokuapp.com/signup';

    final checkAdminUrl =
        Uri.parse("http://protected-waters-32301.herokuapp.com/checkAdmin");
    try {
      final isAdminResponse = await http.post(
        checkAdminUrl,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            'email': email,
          },
        ),
      );
      final adminResponse = json.decode(isAdminResponse.body);
      _isAdmin = adminResponse['idAdmin'];
      notifyListeners();
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            'email': email,
            'password': password,
            'isAdmin': isAdmin,
          },
        ),
        encoding: Encoding.getByName('utf-8'),
      );

      final responseData = json.decode(response.body);
      print('SIgn up response --->$responseData');
      if (responseData['code'] == 'auth/email-already-exists') {
        throw Exception("user mail already exist");
      }

      return signIn(email, password);
    } catch (error) {
      _status = AuthExceptionHandler.handleException(error);

      notifyListeners();
      return status;
    }
  }

  Future<String?> signUp(String? email, String? password) async {
    return _authenticate(email!, password!, 'signUp');
  }
}
