import 'package:flutter/material.dart';
import 'package:phone_book/pages/contacts_page.dart';
import 'package:phone_book/pages/detail_contact_page.dart';
import 'package:phone_book/pages/favorites_page.dart';
import 'package:phone_book/pages/login_page.dart';
import 'package:phone_book/providers/user_provider.dart';
import 'package:phone_book/theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/contact.dart';

class ContactCard extends StatefulWidget {
  final Contact contact;
  ContactCard(this.contact);

  @override
  State<ContactCard> createState() => _ContactCardState(this.contact);
}

class _ContactCardState extends State<ContactCard> {
  final Contact contact;
  _ContactCardState(this.contact);

  String id_user = "";
  String token = "";
  getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var islogin = pref.getBool("is_login");
    if (islogin != null && islogin == true) {
      setState(() {
        id_user = pref.getString("id")!;
        token = pref.getString("token")!;
        print(ModalRoute.of(context)?.settings.name);
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

    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailContactPage(contact),
            ));
      },
      child: Container(
        height: 36,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: bgProfile,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  width: 36,
                  height: 36,
                  child: Center(
                    child: Image.asset(
                      'assets/images/user1.png',
                      width: 18,
                      height: 19,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 17,
            ),
            Expanded(
              flex: 9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(contact.name),
                  Text(contact.phone),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    print(token);
                    print(contact.id);
                    spaceProvider.setFavoriteContact(
                        id_user, token, contact.id);
                    Future.delayed(Duration(milliseconds: 1000), () {
                      // Do something
                      if (ModalRoute.of(context)?.settings.name.toString() ==
                          '/contact') {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/contact', (Route<dynamic> route) => false);
                      }
                      if (ModalRoute.of(context)?.settings.name.toString() ==
                          '/favorite') {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/favorite', (Route<dynamic> route) => false);
                      }
                    });
                    print(ModalRoute.of(context)?.settings.name);
                  },
                  child: ModalRoute.of(context)?.settings.name != '/recent'
                      ? Image.asset(
                          contact.favorite == 'Y'
                              ? 'assets/images/star.png'
                              : 'assets/images/icon_star_regular.png',
                          width: 16,
                          height: 16,
                        )
                      : Container(),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// class ContactCard extends StatelessWidget {
//   final Contact contact;
//   ContactCard(this.contact);

//   @override
//   Widget build(BuildContext context) {
//     String id_user = "";
//     String token = "";
//     getPref() async {
//       SharedPreferences pref = await SharedPreferences.getInstance();
//       var islogin = pref.getBool("is_login");
//       if (islogin != null && islogin == true) {
//         setState(() {
//           id_user = pref.getString("id")!;
//           token = pref.getString("token")!;
//         });
//       } else {
//         Navigator.of(context, rootNavigator: true).pop();
//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(
//             builder: (BuildContext context) => const LoginPage(),
//           ),
//           (route) => false,
//         );
//       }
//     }

//     var spaceProvider = Provider.of<UserProvider>(context);
//     spaceProvider.getAllContactUser(id_user, token);

//     @override
//     void initState() {
//       getPref();
//       initState();
//     }

//     @override
//     dispose() {
//       dispose();
//     }

  //   return InkWell(
  //     onTap: () {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => DetailContactPage(contact),
  //         ),
  //       );
  //     },
  //     child: Container(
  //       height: 36,
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Column(
  //             children: [
  //               Container(
  //                 decoration: BoxDecoration(
  //                   color: bgProfile,
  //                   borderRadius: BorderRadius.circular(50),
  //                 ),
  //                 width: 36,
  //                 height: 36,
  //                 child: Center(
  //                   child: Image.asset(
  //                     'assets/images/user1.png',
  //                     width: 18,
  //                     height: 19,
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //           SizedBox(
  //             width: 17,
  //           ),
  //           Expanded(
  //             flex: 9,
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(contact.name),
  //                 Text(contact.phone),
  //               ],
  //             ),
  //           ),
  //           Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Image.asset(
  //                 contact.favorite == 'Y'
  //                     ? 'assets/images/star.png'
  //                     : 'assets/images/icon_star_regular.png',
  //                 width: 16,
  //                 height: 16,
  //               )
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
// }
