import 'package:flutter/material.dart';
import 'strings.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(GHFlutterApp());

class GHFlutterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.green.shade800),
      title: Strings.appTitle,
      home: GHFlutter(),
    );
  }
}

class GHFlutter extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => GHFlutterState();
}

class GHFlutterState extends State<GHFlutter> {
  var _members = <Member>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //check on how to make appbar look iosy or androidy
      appBar: AppBar(
        title: Text(Strings.appTitle),
      ),
      body: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: _members.length *
              2, // this times 2 is pretty crucial. the list builder has
          //to know the exact number of things that are gonna be in the list.
          itemBuilder: (BuildContext context, int position) {
            if (position.isOdd) return Divider();

            final index = position ~/ 2; //integer division
            return _buildRow(position);
          }),
    );
  }

  _loadData() async {
    String dataURL = "https://api.github.com/orgs/raywenderlich/members";
    http.Response response = await http.get(dataURL);
    setState(() {
      final membersJSON = json.decode(response.body);
      for (var memberJSON in membersJSON) {
        final member =
            new Member(memberJSON["login"], memberJSON["avatar_url"]);
        _members.add(member);
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _loadData();
  }

  Widget _buildRow(int position) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: ListTile(
        title: Text("${_members[position].login}", style: _biggerFont),
        leading: CircleAvatar(
          backgroundColor: Colors.green,
          backgroundImage: NetworkImage(_members[position].avatarUrl),
        ),
      ),
    );
  }
}

class Member {
  final String login;
  final String avatarUrl;

  Member(this.login, this.avatarUrl) {
    if (login == null) {
      throw ArgumentError("login of Member cannot be null."
          "Received: '$login'");
    }
    if (avatarUrl == null || avatarUrl == " ") {
      throw ArgumentError("AvatarUrl of Member cannot be null."
          "Received: '$avatarUrl'");
    }
  }
}
