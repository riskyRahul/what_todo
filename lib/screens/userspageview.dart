import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:what_todo/models/user.dart';
import 'package:http/http.dart' as http;

class UsersPageView extends StatefulWidget {
  final String uri;
  final int cruntPage;
  const UsersPageView({@required this.uri, @required this.cruntPage, Key key})
      : super(key: key);

  @override
  _UsersPageViewState createState() => _UsersPageViewState();
}

class _UsersPageViewState extends State<UsersPageView> {
  Future<Users> fetchUser(String uri) async {
    final response = await http.get(Uri.parse(uri));
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
        body: FutureBuilder(
          future: fetchUser(widget.uri),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.data.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Container(
                        width: 48,
                        height: 48,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Image.network(
                            snapshot.data.data[index].avatar,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: Text(
                        snapshot.data.data[index].firstName +
                            " " +
                            snapshot.data.data[index].lastName,
                        style: TextStyle(
                          color: Color(0xFF211551),
                        ),
                      ),
                      subtitle: Text(
                        snapshot.data.data[index].email,
                        style: TextStyle(
                          color: Color(0xFF86829D),
                        ),
                      ),
                    );
                  });
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
