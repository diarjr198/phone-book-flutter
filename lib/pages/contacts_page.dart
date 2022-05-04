import 'package:flutter/material.dart';
import 'package:phone_book/pages/add_contact_page.dart';
import 'package:phone_book/pages/favorites_page.dart';
import 'package:phone_book/pages/login_page.dart';
import 'package:phone_book/providers/user_provider.dart';
import 'package:phone_book/theme.dart';
import 'package:phone_book/widgets/contact.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/contact.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
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

  logOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.remove("is_login");
      preferences.remove("token");
      preferences.remove("id");
      preferences.remove("name");
    });

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const LoginPage(),
      ),
      (route) => false,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text(
        "Berhasil logout",
        style: TextStyle(fontSize: 16),
      )),
    );
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
    var spaceProvider = Provider.of<UserProvider>(context);
    spaceProvider.getAllContactUser(id_user, token);
    return Scaffold(
      backgroundColor: primaryContactColor,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(
            new FocusNode(),
          );
        },
        child: SafeArea(
          bottom: false,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 27,
                  right: 24,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 110,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height -
                          MediaQuery.of(context).padding.top -
                          110 -
                          46,
                      child: SingleChildScrollView(
                        child: FutureBuilder(
                          future:
                              spaceProvider.getAllContactUser(id_user, token),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              List<Contact> data =
                                  snapshot.data as List<Contact>;

                              int index = 0;

                              return Column(
                                children: data.map((item) {
                                  index++;
                                  return Container(
                                      margin: EdgeInsets.only(
                                        bottom: 9,
                                      ),
                                      child: ContactCard(item));
                                }).toList(),
                                // [
                                //   Row(
                                //     children: [
                                //       Text(
                                //         'A',
                                //         style: blackTextStyle.copyWith(
                                //             fontSize: 16),
                                //       ),
                                //     ],
                                //   ),
                                //   SizedBox(
                                //     height: 5,
                                //   ),
                                //   ContactCard(
                                //     Contact(
                                //       id: '1',
                                //       id_user: '1',
                                //       name: 'Ali Ragasa',
                                //       phone: '+628536831235',
                                //       company: 'PT. Teknologi',
                                //       job: 'Engineer Teknologi',
                                //       email: 'ali@gmail.com',
                                //       favorite: "N",
                                //     ),
                                //   ),
                                // ],
                              );
                            }
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                        // Column(
                        //   children: [
                        //     Row(
                        //       children: [
                        //         Text(
                        //           'A',
                        //           style: blackTextStyle.copyWith(fontSize: 16),
                        //         ),
                        //       ],
                        //     ),
                        //     SizedBox(
                        //       height: 5,
                        //     ),
                        //     ContactCard(
                        //       Contact(
                        //         id: '1',
                        //         id_user: '1',
                        //         name: 'Ali Ragasa',
                        //         phone: '+628536831235',
                        //         company: 'PT. Teknologi',
                        //         job: 'Engineer Teknologi',
                        //         email: 'ali@gmail.com',
                        //         favorite: "N",
                        //       ),
                        //     ),
                        //     SizedBox(
                        //       height: 9,
                        //     ),
                        //     ContactCard(
                        //       Contact(
                        //         id: '1',
                        //         id_user: '1',
                        //         name: 'Ali Ragasa',
                        //         phone: '+628536831235',
                        //         company: 'PT. Teknologi',
                        //         job: 'Engineer Teknologi',
                        //         email: 'ali@gmail.com',
                        //         favorite: "N",
                        //       ),
                        //     ),
                        //     SizedBox(
                        //       height: 9,
                        //     ),
                        //     ContactCard(
                        //       Contact(
                        //         id: '1',
                        //         id_user: '1',
                        //         name: 'Ali Ragasa',
                        //         phone: '+628536831235',
                        //         company: 'PT. Teknologi',
                        //         job: 'Engineer Teknologi',
                        //         email: 'ali@gmail.com',
                        //         favorite: "N",
                        //       ),
                        //     ),
                        //     SizedBox(
                        //       height: 9,
                        //     ),
                        //     ContactCard(
                        //       Contact(
                        //         id: '1',
                        //         id_user: '1',
                        //         name: 'Ali Ragasa',
                        //         phone: '+628536831235',
                        //         company: 'PT. Teknologi',
                        //         job: 'Engineer Teknologi',
                        //         email: 'ali@gmail.com',
                        //         favorite: "N",
                        //       ),
                        //     ),
                        //     SizedBox(
                        //       height: 18,
                        //     ),
                        //     Row(
                        //       children: [
                        //         Text(
                        //           'B',
                        //           style: blackTextStyle.copyWith(fontSize: 16),
                        //         ),
                        //       ],
                        //     ),
                        //     SizedBox(
                        //       height: 5,
                        //     ),
                        //     ContactCard(
                        //       Contact(
                        //         id: '1',
                        //         id_user: '1',
                        //         name: 'Ali Ragasa',
                        //         phone: '+628536831235',
                        //         company: 'PT. Teknologi',
                        //         job: 'Engineer Teknologi',
                        //         email: 'ali@gmail.com',
                        //         favorite: "N",
                        //       ),
                        //     ),
                        //     SizedBox(
                        //       height: 9,
                        //     ),
                        //     ContactCard(
                        //       Contact(
                        //         id: '1',
                        //         id_user: '1',
                        //         name: 'Ali Ragasa',
                        //         phone: '+628536831235',
                        //         company: 'PT. Teknologi',
                        //         job: 'Engineer Teknologi',
                        //         email: 'ali@gmail.com',
                        //         favorite: "N",
                        //       ),
                        //     ),
                        //     SizedBox(
                        //       height: 9,
                        //     ),
                        //     ContactCard(
                        //       Contact(
                        //         id: '1',
                        //         id_user: '1',
                        //         name: 'Ali Ragasa',
                        //         phone: '+628536831235',
                        //         company: 'PT. Teknologi',
                        //         job: 'Engineer Teknologi',
                        //         email: 'ali@gmail.com',
                        //         favorite: "N",
                        //       ),
                        //     ),
                        //     SizedBox(
                        //       height: 9,
                        //     ),
                        //     ContactCard(
                        //       Contact(
                        //         id: '1',
                        //         id_user: '1',
                        //         name: 'Ali Ragasa',
                        //         phone: '+628536831235',
                        //         company: 'PT. Teknologi',
                        //         job: 'Engineer Teknologi',
                        //         email: 'ali@gmail.com',
                        //         favorite: "N",
                        //       ),
                        //     ),
                        //     SizedBox(
                        //       height: 18,
                        //     ),
                        //   ],
                        // ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: bgProfile,
                width: MediaQuery.of(context).size.width,
                height: 46,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/recent', (Route<dynamic> route) => false);
                        },
                        child: Image.asset(
                          'assets/images/icon_recent.png',
                          width: 32,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (ModalRoute.of(context)?.settings.name !=
                              '/contact') {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/contact', (Route<dynamic> route) => false);
                          }
                        },
                        child: Image.asset(
                          'assets/images/icon_data_contact.png',
                          width: 29,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/favorite', (Route<dynamic> route) => false);
                        },
                        child: Image.asset(
                          'assets/images/icon_favorite.png',
                          width: 31,
                        ),
                      ),
                    ]),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        color: primaryContactColor,
        height: 110,
        margin: EdgeInsets.only(
          left: 27,
          right: 24,
        ),
        child: Column(
          children: [
            SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Column(
                  children: [
                    Text(
                      'My Contacts',
                      style: blackTextStyle.copyWith(fontSize: 16),
                    ),
                  ],
                ),
                Spacer(),
                Column(
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            logOut();
                          },
                          child: Image.asset(
                            'assets/images/power-off-solid.png',
                            width: 19,
                            height: 19,
                          ),
                        ),
                        SizedBox(
                          width: 100,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddContactPage(),
                              ),
                            );
                          },
                          child: Image.asset(
                            'assets/images/vector.png',
                            width: 19,
                            height: 19,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 19,
            ),
            Container(
              height: 35,
              decoration: BoxDecoration(
                color: searchColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: 5,
                  left: 10,
                ),
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search contact',
                    hintStyle: TextStyle(
                      color: blackColor,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
    );
  }
}
