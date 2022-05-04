import 'dart:convert';

import 'package:android_intent_plus/android_intent.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:phone_book/models/contact.dart';
import 'package:phone_book/pages/contacts_page.dart';
import 'package:phone_book/pages/login_page.dart';
import 'package:phone_book/providers/user_provider.dart';
import 'package:phone_book/theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class DetailContactPage extends StatefulWidget {
  final Contact contact;
  String route = '';
  DetailContactPage(this.contact);

  @override
  State<DetailContactPage> createState() =>
      _DetailContactPageState(this.contact);
}

class _DetailContactPageState extends State<DetailContactPage> {
  final Contact contact;
  _DetailContactPageState(this.contact);

  var update = false;

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
      doUpdate(txtEditName.text, txtEditPhone.text, txtEditEmail.text,
          txtEditCompany.text, txtEditJob.text);
      // print('Form is valid');
    }
  }

  onGoBack(dynamic value) {
    setState(() {});
  }

  doUpdate(name, phone, email, company, job) async {
    final GlobalKey<State> _keyLoader = GlobalKey<State>();

    try {
      final response = await http.put(
        Uri.parse(
            "https://phone-book-be.herokuapp.com/api/user/update?id_user=$id_user&id_contact=${contact.id}"),
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
      if (response.statusCode == 200) {
        // Navigator.of(_keyLoader.currentContext!, rootNavigator: false).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
            'Success Update Contact',
            style: const TextStyle(fontSize: 16),
          )),
        );

        Map<String, dynamic> data = jsonDecode(response.body);
        Contact contact = Contact.fromJson(data);
        print(data);

        // if (output['success'] == true) {
        // Navigator.of(context, rootNavigator: true).pop();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DetailContactPage(contact)),
          // (Route<dynamic> route) => false,
        ).then(onGoBack);
        // }
      }
    } catch (e) {
      print(e);
    }
  }

  doDelete() async {
    final GlobalKey<State> _keyLoader = GlobalKey<State>();

    try {
      final response = await http.delete(
        Uri.parse(
            "https://phone-book-be.herokuapp.com/api/user/delete?id_user=$id_user&id_contact=${contact.id}"),
        headers: {
          'Accept': 'application/json',
          'x-access-token': '$token',
        },
      );

      final output = jsonDecode(response.body);
      if (response.statusCode == 200) {
        // Navigator.of(_keyLoader.currentContext!, rootNavigator: false).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
            'Success Delete Contact',
            style: const TextStyle(fontSize: 16),
          )),
        );

        Map<String, dynamic> data = jsonDecode(response.body);
        Contact contact = Contact.fromJson(data);
        print(data);

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
    txtEditEmail..text = this.contact.email;
    txtEditName..text = this.contact.name;
    txtEditPhone..text = this.contact.phone;
    txtEditCompany..text = this.contact.company;
    txtEditJob..text = this.contact.job;
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _launchUrl(String url) async {
      // try {
      //   await launch(
      //     url,
      //     customTabsOption: CustomTabsOption(
      //       extraCustomTabs: <String>[
      //         // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
      //         'com.mtdeer.exostreamr',
      //       ],
      //     ),
      //   );
      // } catch (e) {
      //   debugPrint(e.toString());
      // }
      // if (await canLaunch(url)) {
      //   await launch(url);
      // } else {
      //   throw 'Could not launch $url';
      // }
      // print('sukses');

      if (await canLaunch(url)) {
        bool isInstalled =
            await DeviceApps.isAppInstalled('com.mtdeer.exostreamr');
        if (isInstalled != false) {
          print('test');
          // await launch(url,
          //     forceWebView: false,
          //     forceSafariVC: false,
          //     universalLinksOnly: true);
          AndroidIntent intent = AndroidIntent(
            action: 'action_view',
            data: url,
          );
          await intent.launch();
        }
      } else {
        throw 'Could not launch $url';
      }
    }

    _setUpdate() {
      setState(() {
        update = !update;
      });
    }

    var spaceProvider = Provider.of<UserProvider>(context);
    spaceProvider.getSpecificContact(id_user, token, contact.id);

    return Scaffold(
      backgroundColor: primaryContactColor,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 17),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 64,
                          child: InkWell(
                            onTap: () {
                              // Navigator.pop(context, true);
                              Navigator.pushNamed(
                                context,
                                '/contact',
                              ).then((value) => setState(() {}));
                            },
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
                      ],
                    ),
                    Column(
                      children: [
                        Row(children: [
                          !update
                              ? InkWell(
                                  onTap: () {
                                    // _launchUrl(
                                    //     'http://ip2121.com:8081/web1/hbo/playlist.m3u8');
                                    _setUpdate();

                                    print(update);
                                  },
                                  child: Image.asset(
                                    'assets/images/pencil-solid.png',
                                    height: 17,
                                  ))
                              : Container(),
                          update
                              ? InkWell(
                                  onTap: () {
                                    _setUpdate();
                                  },
                                  child: Image.asset(
                                    'assets/images/xmark-solid.png',
                                    height: 18,
                                  ),
                                )
                              : Container(),
                          SizedBox(
                            width: 20,
                          ),
                          InkWell(
                            onTap: () {
                              doDelete();
                            },
                            child: Image.asset(
                              'assets/images/trash-solid.png',
                              height: 17,
                            ),
                          ),
                        ]),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 36,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: !update ? 56 : 40,
                ),
                child: FutureBuilder(
                  future: spaceProvider.getSpecificContact(
                      id_user, token, contact.id),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      Contact contact = snapshot.data as Contact;
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  width: 161,
                                  height: 161,
                                  decoration: BoxDecoration(
                                    color: bgProfile,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Image.asset(
                                    'assets/images/icon_data_contact.png',
                                    width: 75,
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: 22,
                          ),
                          update == false
                              ? Column(
                                  children: [
                                    Text(
                                      this.contact.name,
                                      style: blackTextStyle.copyWith(
                                        fontSize: 18,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 46,
                                    ),
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/icon_call.png',
                                          width: 23,
                                        ),
                                        SizedBox(width: 22),
                                        Text(
                                          this.contact.phone,
                                          style: blackTextStyle.copyWith(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 22,
                                    ),
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/icon_office.png',
                                          width: 23,
                                        ),
                                        SizedBox(width: 22),
                                        Text(
                                          this.contact.company,
                                          style: blackTextStyle.copyWith(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 22,
                                    ),
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/icon_job.png',
                                          width: 23,
                                        ),
                                        SizedBox(width: 22),
                                        Text(
                                          this.contact.job,
                                          style: blackTextStyle.copyWith(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 22,
                                    ),
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/icon_email.png',
                                          width: 23,
                                        ),
                                        SizedBox(width: 22),
                                        Text(
                                          this.contact.email,
                                          style: blackTextStyle.copyWith(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : Container(),
                          update
                              ? Form(
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
                                            hintStyle:
                                                TextStyle(color: blackColor),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 13,
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              width: (MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      90) /
                                                  2,
                                              child: TextFormField(
                                                validator: (String? arg) {
                                                  if (arg == null ||
                                                      arg.isEmpty) {
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
                                                  hintStyle: TextStyle(
                                                      color: blackColor),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                              width: (MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      90) /
                                                  2,
                                              child: TextFormField(
                                                validator: (String? arg) {
                                                  if (arg == null ||
                                                      arg.isEmpty) {
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
                                                  hintStyle: TextStyle(
                                                      color: blackColor),
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
                                              width: (MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      90) /
                                                  2,
                                              child: TextFormField(
                                                validator: (String? arg) {
                                                  if (arg == null ||
                                                      arg.isEmpty) {
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
                                                  hintStyle: TextStyle(
                                                      color: blackColor),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                              width: (MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      90) /
                                                  2,
                                              child: TextFormField(
                                                validator: (String? arg) {
                                                  if (arg == null ||
                                                      arg.isEmpty) {
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
                                                  hintStyle: TextStyle(
                                                      color: blackColor),
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
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: RaisedButton(
                                            onPressed: () {
                                              _validateInputs();
                                            },
                                            color: buttonColor,
                                            child: Text(
                                              'UPDATE CONTACT',
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
                              : Container(),
                        ],
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
