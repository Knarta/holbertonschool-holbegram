import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:holbegram/screens/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeFirebase();
  runApp(const MyApp());
}

Future<FirebaseApp> _initializeFirebase() {
  if (kIsWeb) {
    return Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyDD9Zx_eLBRXVYimzxxe8VYm4MfKowGmao',
        appId: '1:606191170752:android:fb76e66e7324d1e5672925',
        messagingSenderId: '606191170752',
        projectId: 'holbegram-b477b',
        storageBucket: 'holbegram-b477b.firebasestorage.app',
        authDomain: 'holbegram-b477b.firebaseapp.com',
        databaseURL: 'https://holbegram-b477b-default-rtdb.firebaseio.com',
      ),
    );
  }
  return Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const AppInitializer(),
    );
  }
}

class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  @override
  Widget build(BuildContext context) {
    return LoginScreen(
      emailController: TextEditingController(),
      passwordController: TextEditingController(),
    );
  }
}
