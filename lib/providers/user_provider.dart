import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:phone_book/models/contact.dart';

class UserProvider extends ChangeNotifier {
  getAllContactUser(String id_user, String token) async {
    var result = await http.get(
        Uri.parse(
          'https://phone-book-be.herokuapp.com/api/user/list?id_user=$id_user',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'x-access-token': '$token',
        });

    print(result.statusCode);
    print(result.body);
    if (result.statusCode == 200) {
      List data = jsonDecode(result.body);
      List<Contact> contacts =
          data.map((item) => Contact.fromJson(item)).toList();
      return contacts;
    } else {
      return <Contact>[];
    }
  }

  getAllFavoriteContacts(String id_user, String token) async {
    var result = await http.get(
        Uri.parse(
          'https://phone-book-be.herokuapp.com/api/user/listfavorite?id_user=$id_user',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'x-access-token': '$token',
        });

    print(result.statusCode);
    print(result.body);
    if (result.statusCode == 200) {
      List data = jsonDecode(result.body);
      List<Contact> contacts =
          data.map((item) => Contact.fromJson(item)).toList();
      return contacts;
    } else {
      return <Contact>[];
    }
  }

  setFavoriteContact(String id_user, String token, String id_contact) async {
    var result = await http.patch(
        Uri.parse(
          'https://phone-book-be.herokuapp.com/api/user/favorite?id_user=$id_user&id_contact=$id_contact',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'x-access-token': '$token',
        });

    print(result.statusCode);
    print(result.body);
    if (result.statusCode == 200) {
      return 'Sukses menambahkan kontak favorit';
    } else {
      return 'Gagal menambahkan kontak favorit';
    }
  }

  getAllRecentsContact(String id_user, String token) async {
    var result = await http.get(
        Uri.parse(
          'https://phone-book-be.herokuapp.com/api/user/recent?id_user=$id_user',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'x-access-token': '$token',
        });

    print(result.statusCode);
    print(result.body);
    if (result.statusCode == 200) {
      List data = jsonDecode(result.body);
      List<Contact> contacts =
          data.map((item) => Contact.fromJson(item)).toList();
      return contacts;
    } else {
      return <Contact>[];
    }
  }

  getSpecificContact(String id_user, String token, String id_contact) async {
    var result = await http.get(
        Uri.parse(
          'https://phone-book-be.herokuapp.com/api/user/listspecific?id_user=$id_user&id_contact=$id_contact',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'x-access-token': '$token',
        });

    print(result.statusCode);
    print(result.body);
    if (result.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(result.body);
      Contact contact = Contact.fromJson(data);
      print(data);
      return contact;
    } else {
      return <Contact>[];
    }
  }
}
