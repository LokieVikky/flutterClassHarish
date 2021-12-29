import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:practice/user_model.dart';

class ListViewScreen extends StatefulWidget {
  const ListViewScreen({Key? key}) : super(key: key);

  @override
  _ListViewScreenState createState() => _ListViewScreenState();
}

class _ListViewScreenState extends State<ListViewScreen> {
  List<User> usersList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(10),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Text(usersList[index].id.toString()),
                      Text(usersList[index].firstName),
                      Text(usersList[index].lastName),
                      Text(usersList[index].email),
                      Text(usersList[index].avatarURL),
                      Divider(),
                    ],
                  );
                },
                itemCount: usersList.length,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                getUsers();
              },
              child: Text('Get USERS'),
            ),
          ],
        ),
      ),
    );
  }

  getUsers() async {
    String getUserApiURL = 'https://reqres.in/api/users?page=1';
    // Object Creation Syntax
    // ClassName objectName = ClassName();
    HttpClient _httpClient = HttpClient();
    IOClient ioClient = IOClient(_httpClient);
    // async // await
    // API CALL
    http.Response response = await ioClient.get(Uri.parse(getUserApiURL));
    if (response.statusCode == 200) {
      String body = response.body;
      Map<String, dynamic> responseBody = jsonDecode(body);
      setState(() {
        usersList = (responseBody['data'] as List).map((user) {
          return User(user['id'], user['email'], user['first_name'], user['last_name'],
              user['avatar']);
        }).toList();
      });
    } else {
      print('Error' + response.statusCode.toString());
    }
    return response;
  }
}
