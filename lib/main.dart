import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes_gallery/provider/authProvider.dart';
import 'package:notes_gallery/screens/authentication_screen.dart';
import 'package:notes_gallery/screens/notes_screen.dart';
import 'package:notes_gallery/screens/sem_screen.dart';
import 'package:notes_gallery/utils/constants/routes.dart';
import 'package:notes_gallery/widgets/box_gridView.dart';
import 'package:provider/provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Authh(),
        ),
      ],
      child: Consumer<Authh>(
        builder: (ctx, authh, _) => MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: AuthenticationScreen(),
          builder: EasyLoading.init(),
          routes: {
            SemesterScreen.routName: (ctx) => SemesterScreen(),
            NotesScreen.routName: (ctx) => NotesScreen(),
            AuthenticationScreen.routName: (ctx) => AuthenticationScreen(),
          },
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  //MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        // toolbarOpacity: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Notes Gallery",
              style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(51, 53, 117, 1)),
            ),
            Text(
              "A smart way for sharing notes",
              style: TextStyle(
                  fontSize: 12, color: Color.fromRGBO(169, 170, 183, 1)),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
            ),
            Container(
              color: Colors.transparent,
              child: Text(
                "Welcome User",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(51, 53, 117, 1)),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: BoxGridView(),
            ),
          ],
        ),
      ),
    );
  }
}
