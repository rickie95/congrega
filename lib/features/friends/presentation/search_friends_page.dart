import 'package:congrega/features/friends/data/friends_repository.dart';
import 'package:congrega/features/loginSignup/model/User.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kiwi/kiwi.dart';

class SearchFriendPage extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => SearchFriendPage());
  }

  static const OutlineInputBorder newEventOutlineInputBorder =
      OutlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 2));

  @override
  State<StatefulWidget> createState() => _SearchFriendPageState();
}

class _SearchFriendPageState extends State<SearchFriendPage> {
  void updateSearchText(String username) {
    KiwiContainer()
        .resolve<FriendRepository>()
        .searchByUsername(username)
        .then((searchResults) {
      results = searchResults;
      setState(() {});
    });
  }

  late List<User> results = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add friend")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: ListView.builder(
            itemCount: results.length + 1,
            itemBuilder: (context, index) {
              if (index == 0)
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Text(
                        "Search for an user",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextField(
                      onChanged: (value) => {updateSearchText(value)},
                      decoration: InputDecoration(
                          labelText: "Write an username",
                          border: SearchFriendPage.newEventOutlineInputBorder),
                    )
                  ],
                );

              return ListTile(title: Text(results[index - 1].name));
            },
          ),
        ),
      ),
    );
  }
}
