import 'package:congrega/features/dashboard/presentation/widgets/friends_widget/FriendsWidget.dart';
import 'package:congrega/features/loginSignup/model/User.dart';
import 'package:congrega/features/users/UserRepository.dart';
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
    KiwiContainer().resolve<UserRepository>().searchByUsername(username).then((searchResults) {
      KiwiContainer().resolve<UserRepository>().getUser().then((currentUser) {
        results =
            searchResults.where((User user) => user.username != currentUser.username).toList();
        setState(() {});
      });
    });
  }

  late List<User> results = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add friend")),
      body: SafeArea(
        child: ListView.builder(
          itemCount: results.length + 1,
          itemBuilder: (context, index) {
            if (index == 0)
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  onChanged: (value) => {updateSearchText(value)},
                  decoration: InputDecoration(
                      labelText: "Search for username or name",
                      border: SearchFriendPage.newEventOutlineInputBorder),
                ),
              );

            return createResultTile(results[index - 1]);
          },
        ),
      ),
    );
  }

  Widget createResultTile(User user) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(user.username[0].toUpperCase()),
      ),
      title: Text(user.username),
      subtitle: Text(user.name),
      onTap: () => showModalBottomSheet<void>(
          context: context, builder: (BuildContext context) => FriendBottomSheet(user: user)),
    );
  }
}
