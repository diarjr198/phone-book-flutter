import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:phone_book/pages/contacts_page.dart';
import 'package:phone_book/pages/register_page.dart';
import 'package:phone_book/theme.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var txtEditEmail = TextEditingController();
  var txtEditPassword = TextEditingController();

  void _validateInputs() {
    // print(txtEditEmail.text);
    // print(txtEditPassword.text);
    // print(_formKey.currentState!.validate());
    if (_formKey.currentState!.validate()) {
      //If all data are correct then save data to out variables
      _formKey.currentState!.save();
      doLogin(txtEditEmail.text, txtEditPassword.text);
      // print('Form is valid');
    }
  }

  doLogin(email, password) async {
    final GlobalKey<State> _keyLoader = GlobalKey<State>();

    try {
      final response = await http
          .post(Uri.parse("https://phone-book-be.herokuapp.com/api/login"),
              // headers: {'Content-Type': 'application/json; charset=UTF-8'},
              body: {
            "email": email,
            "password": password,
          });

      final output = jsonDecode(response.body);
      if (response.statusCode == 200) {
        // Navigator.of(_keyLoader.currentContext!, rootNavigator: false).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
            output['message'],
            style: const TextStyle(fontSize: 16),
          )),
        );

        if (output['success'] == true) {
          saveSession(
              output['token'], output['user']['id'], output['user']['name']);
        }
        //debugPrint(output['message']);
      } else {
        // Navigator.of(_keyLoader.currentContext!, rootNavigator: false).pop();
        //debugPrint(output['message']);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
            output['message'].toString(),
            style: const TextStyle(fontSize: 16),
          )),
        );
      }
    } catch (e) {
      // Navigator.of(_keyLoader.currentContext!, rootNavigator: false).pop();
      debugPrint('$e');
    }
  }

  saveSession(String token, String id, String name) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("token", token);
    await pref.setString("id", id);
    await pref.setString("name", name);
    await pref.setBool("is_login", true);
    print(pref);

    Navigator.of(context)
        .pushNamedAndRemoveUntil('/contact', (Route<dynamic> route) => false);
  }

  void ceckLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var islogin = pref.getBool("is_login");
    if (islogin != null && islogin) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/contact', (Route<dynamic> route) => false);
    }
  }

  @override
  void initState() {
    ceckLogin();
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: primaryColor,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: 27,
              right: 26,
            ),
            child: Column(
              children: [
                SizedBox(height: 17),
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterPage(),
                        ),
                      );
                    },
                    child: Text(
                      'Sign Up',
                      style: whiteTextStyle.copyWith(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50),
                Center(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/logo_contact1.png',
                        width: 330,
                        height: 324,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 48),
                Form(
                  key: _formKey,
                  child: Container(
                    width: 307,
                    child: Column(
                      children: [
                        TextFormField(
                          validator: (email) =>
                              email != null && !EmailValidator.validate(email)
                                  ? 'Masukkan email yang valid'
                                  : null,
                          controller: txtEditEmail,
                          onSaved: (String? val) {
                            txtEditEmail.text = val!;
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            filled: true,
                            fillColor: inputColor,
                            hintText: 'Email',
                            hintStyle: TextStyle(color: whiteColor),
                          ),
                        ),
                        SizedBox(height: 22),
                        TextFormField(
                          obscureText: true, //make decript inputan
                          validator: (String? arg) {
                            if (arg == null || arg.isEmpty) {
                              return 'Password harus diisi';
                            } else {
                              return null;
                            }
                          },
                          controller: txtEditPassword,
                          onSaved: (String? val) {
                            txtEditPassword.text = val!;
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            filled: true,
                            fillColor: inputColor,
                            hintText: 'Password',
                            hintStyle: TextStyle(color: whiteColor),
                          ),
                        ),
                        SizedBox(height: 57),
                        Container(
                          color: secondaryColor,
                          width: 307,
                          height: 44,
                          child: RaisedButton(
                            color: secondaryColor,
                            onPressed: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => ContactsPage(),
                              //   ),
                              // );
                              _validateInputs();
                            },
                            child: Text(
                              'LOGIN',
                              style: whiteTextStyle.copyWith(fontSize: 16),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
