import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:what_todo/models/user.dart';
import 'package:what_todo/screens/userspageview.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key key}) : super(key: key);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  PageController _pageController;
  int checkPageCount = 0;
  Future<Users> fetchUser() async {
    final response = await http.get(Uri.parse('https://reqres.in/api/users'));

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return Users.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
            color: Color(0xFF211551),
          ),
          title: Text(
            "Users",
            style: TextStyle(
                fontSize: 22,
                color: Color(0xFF211551),
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: FutureBuilder(
              future: fetchUser(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return PageView.builder(
                      controller: _pageController,
                      itemCount: snapshot.data.totalPages,
                      onPageChanged: (pageCounter) {
                        setState(() {
                          checkPageCount = pageCounter;
                        });
                      },
                      itemBuilder: (snapshot, index) {
                        return UsersPageView(
                          cruntPage: index,
                          uri: "https://reqres.in/api/users?page=${index + 1}",
                        );
                      });
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return Center(child: CircularProgressIndicator());
              }),
        ),
        // floatingActionButton: Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   children: [
        //     FloatingActionButton(
        //       backgroundColor: Colors.white,
        //       onPressed: () {
        //         _pageController.nextPage(
        //             duration: Duration(milliseconds: 1000),
        //             curve: Curves.easeIn);
        //       },
        //       child: Padding(
        //         padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        //         child: Text(
        //           "Next",
        //           style: TextStyle(
        //             color: Color(0xFF211551),
        //           ),
        //         ),
        //       ),
        //     ),
        //     FloatingActionButton(
        //       backgroundColor: Colors.white,
        //       onPressed: () {
        //         _pageController.previousPage(
        //             duration: Duration(milliseconds: 1000),
        //             curve: Curves.easeOut);
        //       },
        //       child: Padding(
        //         padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        //         child: Text(
        //           "Prev",
        //           style: TextStyle(
        //             color: Color(0xFF211551),
        //           ),
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
