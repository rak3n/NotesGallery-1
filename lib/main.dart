import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes_gallery/provider/discussionProvider.dart';
import 'package:notes_gallery/screens/CommentsScreen/comments_screen.dart';
import 'package:notes_gallery/screens/DiscussionPanelScreen/discussion_panel_screen.dart';
import 'package:notes_gallery/screens/HomePageScreen/home_page_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../provider/authProvider.dart';
import '../provider/noteProvider.dart';
import '../screens/LoginScreen/login_screen.dart';
import '../screens/NotesScreen/notes_screen.dart';
import '../screens/PdfViewerScreen/pdfScreen.dart';
import '../screens/sem_screen.dart';
import '../screens/SignUpScreen/sign_up_screen.dart';
import '../screens/splash_screen.dart';

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
          value: Authentication(),
        ),
        ChangeNotifierProvider.value(
          value: DiscussionProvider(),
        ),
        ChangeNotifierProxyProvider<Authentication, NotesProvider>(
          create: (_) => NotesProvider(userId: '', token: '', notesList: []),
          update: (context, auth, value) => NotesProvider(
            userId: auth.userId,
            token: auth.token,
            notesList: value?.notesList ?? [],
          ),
        ),
      ],
      child: Consumer<Authentication>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: auth.userId != null
              ? DiscussionPanelScreen()
              : FutureBuilder(
                  future: auth.autoLogin(),
                  builder: (ctx, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : LoginScreen(),
                ),
          builder: EasyLoading.init(),
          routes: {
            DiscussionPanelScreen.routeName: (ctx) => DiscussionPanelScreen(),
            SemesterScreen.routName: (ctx) => SemesterScreen(),
            NotesScreen.routName: (ctx) => NotesScreen(),
            LoginScreen.routName: (ctx) => LoginScreen(),
            SignUpScreen.routName: (ctx) => SignUpScreen(),
            PdfScreen.routeName: (ctx) => PdfScreen(),
            CommentsScreen.routeName: (ctx) => CommentsScreen(),
          },
        ),
      ),
    );
  }
}
