import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:notenih/home_page.dart';
// import 'package:notenih/login.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(), // Membuat ThemeNotifier instance
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Note App',
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: Provider.of<ThemeNotifier>(context).currentTheme,
        home: const HomePage(),);
  }
}

class ThemeNotifier extends ChangeNotifier {
  ThemeMode _currentTheme = ThemeMode.light;

  ThemeMode get currentTheme => _currentTheme;

  void toggleTheme() {
    if (_currentTheme == ThemeMode.light) {
      _currentTheme = ThemeMode.dark;
      // showToast("Dark Mode ON");
    } else {
      _currentTheme = ThemeMode.light;
      // showToast("Light Mode ON");
    }
    notifyListeners(); // Memberi tahu listener bahwa tema berubah
  }

  // void showToast(String message) {
  //   Fluttertoast.showToast(
  //     msg: message,
  //     toastLength: Toast.LENGTH_SHORT,
  //     gravity: ToastGravity.BOTTOM,
  //     backgroundColor: Colors.black54,
  //     textColor: Colors.white,
  //   );
  // }
}
