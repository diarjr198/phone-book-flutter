import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:phone_book/pages/contacts_page.dart';
import 'package:phone_book/pages/login_page.dart';
import 'package:phone_book/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AddContactPage extends StatefulWidget {
  const AddContactPage({Key? key}) : super(key: key);

  @override
  _AddContactPage createState() => _AddContactPage();
}

class _AddContactPage extends State<AddContactPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var txtEditEmail = TextEditingController();
  var txtEditName = TextEditingController();
  var txtEditPhone = TextEditingController();
  var txtEditCompany = TextEditingController();
  var txtEditJob = TextEditingController();

  String id_user = "";
  String token = "";
  getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var islogin = pref.getBool("is_login");
    if (islogin != null && islogin == true) {
      setState(() {
        id_user = pref.getString("id")!;
        token = pref.getString("token")!;
      });
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const LoginPage(),
        ),
        (route) => false,
      );
    }
  }

  void _validateInputs() {
    // print(txtEditEmail.text);
    // print(txtEditPassword.text);
    // print(_formKey.currentState!.validate());
    if (_formKey.currentState!.validate()) {
      //If all data are correct then save data to out variables
      _formKey.currentState!.save();
      doAdd(txtEditName.text, txtEditPhone.text, txtEditEmail.text,
          txtEditCompany.text, txtEditJob.text);
      // print('Form is valid');
    }
  }

  doAdd(name, phone, email, company, job) async {
    final GlobalKey<State> _keyLoader = GlobalKey<State>();

    try {
      final response = await http.post(
        Uri.parse(
            "https://phone-book-be.herokuapp.com/api/user/add?id_user=$id_user"),
        headers: {
          'Accept': 'application/json',
          'x-access-token': '$token',
        },
        body: {
          "name": name,
          "phone": phone,
          "email": email,
          "company": company,
          "job": job,
        },
      );

      final output = jsonDecode(response.body);
      if (response.statusCode == 201) {
        // Navigator.of(_keyLoader.currentContext!, rootNavigator: false).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
            'Success Add Contact',
            style: const TextStyle(fontSize: 16),
          )),
        );

        // if (output['success'] == true) {
        // Navigator.of(context, rootNavigator: true).pop();
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/contact', (Route<dynamic> route) => false);
        // }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getPref();
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
      backgroundColor: primaryContactColor,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 17),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/contact',
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(left: 20),
                  width: 64,
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/icon_back.png',
                        width: 21,
                      ),
                      SizedBox(width: 7),
                      Text(
                        'Back',
                        style: blackTextStyle.copyWith(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 36,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 40,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 184,
                          height: 160,
                          decoration: BoxDecoration(
                            color: bgProfile,
                            borderRadius: BorderRadius.circular(
                              11,
                            ),
                          ),
                          child: Image.asset(
                            'assets/images/icon_data_contact.png',
                            width: 75,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 46,
                    ),
                    Form(
                      key: _formKey,
                      child: Container(
                        child: Column(
                          children: [
                            TextFormField(
                              validator: (String? arg) {
                                if (arg == null || arg.isEmpty) {
                                  return 'Nama harus diisi';
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
                                fillColor: bgProfile,
                                hintText: 'Name',
                                hintStyle: TextStyle(color: blackColor),
                              ),
                            ),
                            SizedBox(
                              height: 13,
                            ),
                            Row(
                              children: [
                                Container(
                                  width:
                                      (MediaQuery.of(context).size.width - 90) /
                                          2,
                                  child: TextFormField(
                                    validator: (String? arg) {
                                      if (arg == null || arg.isEmpty) {
                                        return 'Phone harus diisi';
                                      } else {
                                        return null;
                                      }
                                    },
                                    controller: txtEditPhone,
                                    onSaved: (String? val) {
                                      txtEditPhone.text = val!;
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      filled: true,
                                      fillColor: bgProfile,
                                      hintText: 'Phone',
                                      hintStyle: TextStyle(color: blackColor),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  width:
                                      (MediaQuery.of(context).size.width - 90) /
                                          2,
                                  child: TextFormField(
                                    validator: (String? arg) {
                                      if (arg == null || arg.isEmpty) {
                                        return 'Email harus diisi';
                                      } else {
                                        return null;
                                      }
                                    },
                                    controller: txtEditEmail,
                                    onSaved: (String? val) {
                                      txtEditEmail.text = val!;
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      filled: true,
                                      fillColor: bgProfile,
                                      hintText: 'Email',
                                      hintStyle: TextStyle(color: blackColor),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 13,
                            ),
                            Row(
                              children: [
                                Container(
                                  width:
                                      (MediaQuery.of(context).size.width - 90) /
                                          2,
                                  child: TextFormField(
                                    validator: (String? arg) {
                                      if (arg == null || arg.isEmpty) {
                                        return 'Company harus diisi';
                                      } else {
                                        return null;
                                      }
                                    },
                                    controller: txtEditCompany,
                                    onSaved: (String? val) {
                                      txtEditCompany.text = val!;
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      filled: true,
                                      fillColor: bgProfile,
                                      hintText: 'Company',
                                      hintStyle: TextStyle(color: blackColor),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  width:
                                      (MediaQuery.of(context).size.width - 90) /
                                          2,
                                  child: TextFormField(
                                    validator: (String? arg) {
                                      if (arg == null || arg.isEmpty) {
                                        return 'Job harus diisi';
                                      } else {
                                        return null;
                                      }
                                    },
                                    controller: txtEditJob,
                                    onSaved: (String? val) {
                                      txtEditJob.text = val!;
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      filled: true,
                                      fillColor: bgProfile,
                                      hintText: 'Job',
                                      hintStyle: TextStyle(color: blackColor),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 36,
                            ),
                            Container(
                              height: 53,
                              width: MediaQuery.of(context).size.width,
                              child: RaisedButton(
                                onPressed: () {
                                  _validateInputs();
                                },
                                color: buttonColor,
                                child: Text(
                                  'CREATE NEW ACCOUNT',
                                  style: whiteTextStyle.copyWith(
                                    fontSize: 16,
                                  ),
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
            ],
          ),
        ),
      ),
    );
  }
}
