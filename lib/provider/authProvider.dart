import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:notes_gallery/models/userModel.dart';
import 'package:notes_gallery/utils/give_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authentication with ChangeNotifier {
  String? _token;
  String? _userId;
  DateTime? _expiryDate;
  String _status = '';
  bool? _isAdmin;
  String? _name;
  UserModel? _currentUser;

  UserModel? get currentUser {
    return _currentUser;
  }

  bool get isAuth {
    return token != null;
  }

  bool? get isAdmin {
    return _isAdmin;
  }

  String? get name {
    return _name;
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
      print("@@@@@@@@@@@@@@@@@@@--->${idTokenResult.claims}");

      _userId = idTokenResult.claims?['user_id'];
      _name = idTokenResult.claims?['displayName'];
      _isAdmin = idTokenResult.claims?['isAdmin'];
      print(_name);
      _status = "successful";
      _currentUser = UserModel(
        uid: _userId ?? '',
        displayName: _name ?? "",
        isStudent: !(_isAdmin ?? false),
      );

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'userId': _currentUser?.uid,
        'userName': _currentUser?.displayName,
        'isStudent': _currentUser?.isStudent,
      });
      prefs.setString('userData', userData);
      print("prefs setted >>>>>");
      print(currentUser?.displayName ?? "");

      notifyListeners();

      return status;
    } on FirebaseAuthException catch (e) {
      _status = AuthExceptionHandler.handleException(e);
      notifyListeners();

      return status;
    }
  }

  Future<bool> autoLogin() async {
    print("1.run ninng/....");
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("userData")) {
      return false;
    }
    print("2.run ninng/....");

    final extractedData =
        json.decode(prefs.getString("userData") ?? "") as Map<String, dynamic>;
    print("3.run ninng/....");

    if (extractedData['userId'] == null) {
      return false;
    }
    print("4.run ninng/....");

    _userId = extractedData['userId'];
    _name = extractedData['userName'];
    _isAdmin = extractedData['isStudent'];

    print("AUTO LOGIN BLOC USER ID---->     ${_userId}");

    print("AUTO LOGIN BLOC USER ADMMIN---->     ${_isAdmin}");

    _currentUser = UserModel(
        displayName: _name ?? "",
        isStudent: _isAdmin ?? true,
        uid: _userId ?? "");
    notifyListeners();
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
      String email, String password, String name) async {
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
            'displayName': name,
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

  Future<String?> signUp(
      String? email, String? password, String? userName) async {
    return _authenticate(email!, password!, userName!);
  }
}
