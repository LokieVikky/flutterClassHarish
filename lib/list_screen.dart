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
  List<User> users = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(10),
                itemBuilder: buildItem,
                itemCount: users.length,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                List<User> tempUsers = await getUsers();
                if(tempUsers.isNotEmpty){
                  users.clear();
                  setState(() {
                    users.addAll(tempUsers);
                  });
                }
              },
              child: Text('Get USERS'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildItem(BuildContext context, int index) {
    print(index);
    return Column(
      children: [
        Text(users[index].id.toString()),
        Text(users[index].firstName),
        Text(users[index].lastName),
        Text(users[index].email),
        Text(users[index].avatarURL),
        Divider(),
      ],
    );
  }

  Future<List<User>> getUsers() async {
    List<User> users = [];
    String getUserApiURL = 'https://reqres.in/api/users?page=1';
    HttpClient _httpClient = HttpClient();
    IOClient ioClient = IOClient(_httpClient);
    http.Response response = await ioClient.get(Uri.parse(getUserApiURL));
    if (response.statusCode == 200) {
      String body = response.body;
      Map<String, dynamic> responseBody = jsonDecode(body);
      users = (responseBody['data'] as List).map((user) {
        return User(user['id'], user['email'], user['first_name'],
            user['last_name'], user['avatar']);
      }).toList();
      return users;
    } else {
      print('Error' + response.statusCode.toString());
    }
    return users;
  }
}
