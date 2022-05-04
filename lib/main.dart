import 'package:flutter/material.dart';
import 'package:phone_book/pages/contacts_page.dart';
import 'package:phone_book/pages/favorites_page.dart';
import 'package:phone_book/pages/login_page.dart';
import 'package:phone_book/pages/recents_page.dart';
import 'package:phone_book/providers/user_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/contact': (context) => ContactsPage(),
          '/favorite': (context) => FavoritesPage(),
          '/recent': (context) => RecentsPage(),
          '/login': (context) => LoginPage(),
        },
        home: LoginPage(),
      ),
    );
  }
}
