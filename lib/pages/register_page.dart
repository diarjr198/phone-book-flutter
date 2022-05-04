import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:phone_book/pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../theme.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var txtEditName = TextEditingController();
  var txtEditEmail = TextEditingController();
  var txtEditPassword = TextEditingController();

  void _validateInputs() {
    // print(txtEditEmail.text);
    // print(txtEditPassword.text);
    // print(_formKey.currentState!.validate());
    if (_formKey.currentState!.validate()) {
      //If all data are correct then save data to out variables
      _formKey.currentState!.save();
      doLogin(txtEditName.text, txtEditEmail.text, txtEditPassword.text);
      // print('Form is valid');
    }
  }

  doLogin(name, email, password) async {
    final GlobalKey<State> _keyLoader = GlobalKey<State>();

    try {
      final response = await http
          .post(Uri.parse("https://phone-book-be.herokuapp.com/api/register"),
              // headers: {'Content-Type': 'application/json; charset=UTF-8'},
              body: {
            "name": name,
            "email": email,
            "password": password,
          });

      final output = jsonDecode(response.body);
      print(response.statusCode);
      if (response.statusCode == 201) {
        // Navigator.of(_keyLoader.currentContext!, rootNavigator: false).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
            output['message'],
            style: const TextStyle(fontSize: 16),
          )),
        );

        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
        debugPrint(output['message']);
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
            padding: EdgeInsets.only(left: 27, right: 26),
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
                          builder: (context) => LoginPage(),
                        ),
                      );
                    },
                    child: Text(
                      'Sign In',
                      style: whiteTextStyle.copyWith(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 80),
                Center(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/logo_contact2.png',
                        width: 252,
                        height: 200,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 58),
                Form(
                  key: _formKey,
                  child: Container(
                    width: 307,
                    child: Column(
                      children: [
                        TextFormField(
                          validator: (String? arg) {
                            if (arg == null || arg.isEmpty) {
                              return 'Name harus diisi';
                            } else {
                              return null;
                            }
                          },
                          controller: txtEditName,
                          onSaved: (String? val) {
                            txtEditName.text = val!;
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            filled: true,
                            fillColor: inputColor,
                            hintText: 'Name',
                            hintStyle: TextStyle(color: whiteColor),
                          ),
                        ),
                        SizedBox(height: 22),
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
                        SizedBox(height: 70),
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
                              //     builder: (context) => LoginPage(),
                              //   ),
                              // );
                              _validateInputs();
                            },
                            child: Text(
                              'REGISTER',
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
