import 'package:flutter/material.dart';
import 'package:notes_gallery/provider/authProvider.dart';
import 'package:notes_gallery/provider/noteProvider.dart';
import 'package:notes_gallery/widgets/indicator.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const routName = '/login';
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final mailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  void showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text("An error occur"),
              content: Text(message),
              actions: <Widget>[
                ElevatedButton(
                  child: Text("Okay"),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lets Sign in"),
      ),
      body: ListView(
        children: [
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  TextFormField(
                    controller: mailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Consumer<Authentication>(
                    builder: (context, auth, child) => Container(
                      child: ElevatedButton(
                        child: isLoading ? Indicator() : const Text('Submit'),
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }
                          setState(() {
                            isLoading = true;
                          });
                          _formKey.currentState!.save();

                          final status = await auth.signIn(
                              mailController.text, passwordController.text);
                          if (status != "successful") {
                            showErrorDialog(status ?? "");
                          }
                          setState(() {
                            isLoading = false;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  TextButton(
                    child: Text("Don't have account! SignUp ->"),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/auth');
                    },
                  ),
                  Consumer<NotesProvider>(
                    builder: (context, note, child) => Container(
                      child: Column(
                        children: [
                          ElevatedButton(
                            child: isLoading
                                ? CircularProgressIndicator()
                                : const Text('Send data'),
                            onPressed: () async {
                              print("NO ACTION");
                              // note.addPdfNote(

                              // );
                            },
                          ),
                          SizedBox(),
                          ElevatedButton(
                            onPressed: () {
                              note.fetchNotes(false);
                            },
                            child: Text("succk me"),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
