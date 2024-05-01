import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:zendesk_messaging/failure.dart';
import 'package:zendesk_messaging/service.dart';
import 'package:zendesk_messaging/zendesk_pigeon.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const bool useChannelNotPigeon = true;
  static const String androidChannelKey = "your android key";
  static const String iosChannelKey = "your iOS key";

  String? channelMessages;
  bool isLogin = false;
  int unreadMessageCount = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    /// TODO: eventually uncomment
    /// ZendeskMessaging.invalidate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Zendesk Messaging Example'),
        ),
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: ListView(
              children: [
                Text(channelMessages ?? "N/A"),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () => _init(),
                  child: const Text("Initialize"),
                ),
                ElevatedButton(
                  onPressed: () => _show(),
                  child: const Text("Show"),
                ),
                if (isLogin) ...[
                  ElevatedButton(
                    onPressed: () => _getUnreadMessageCount(),
                    child:
                        Text('Get unread message count - $unreadMessageCount'),
                  ),
                ],
                /*
                ElevatedButton(
                  onPressed: () => _setTags(),
                  child: const Text("Add tags"),
                ),
                ElevatedButton(
                  onPressed: () => _clearTags(),
                  child: const Text("Clear tags"),
                ),
                */
                ElevatedButton(
                  onPressed: () => _login(),
                  child: const Text("Login"),
                ),
                ElevatedButton(
                  onPressed: () => _logout(),
                  child: const Text("Logout"),
                ),
                /*
                ElevatedButton(
                  onPressed: () => _checkUserLoggedIn(),
                  child: const Text("Check LoggedIn"),
                ),
                ElevatedButton(
                  onPressed: () => _setFields(),
                  child: const Text("Add Fields"),
                ),
                ElevatedButton(
                  onPressed: () => _clearFields(),
                  child: const Text("Clear Fields"),
                ),
                */
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _init() async {
    Failure? failure = await ZendeskMessaging.initialize(
      useChannelNotPigeon: useChannelNotPigeon,
      androidChannelKey: androidChannelKey,
      iosChannelKey: iosChannelKey,
    );

    if (mounted == false) return;
    setState(() {
      if (failure == null) {
        channelMessages = null;
      } else {
        channelMessages = _setFailure(failure);
      }
    });
  }

  void _login() async {
    Result<ZendeskUser, Failure> result =
        await ZendeskMessaging.loginUser("my_jwt");
    if (mounted == false) return;
    setState(() {
      result.when((ZendeskUser success) {
        channelMessages = jsonEncode(success.toJson());
        isLogin = true;
      }, (Failure failure) {
        channelMessages = _setFailure(failure);
      });
    });
  }

  void _logout() async {
    Failure? failure = await ZendeskMessaging.logoutUser();
    if (mounted == false) return;
    setState(() {
      if (failure == null) {
        channelMessages = "";
        unreadMessageCount = 0;
        isLogin = false;
      } else {
        channelMessages = _setFailure(failure);
      }
    });
  }

  void _getUnreadMessageCount() async {
    Result<int, Failure> result =
        await ZendeskMessaging.getUnreadMessageCount();
    if (mounted == false) return;
    setState(() {
      result.when((int success) {
        channelMessages = "$success";
        unreadMessageCount = success;
      }, (Failure failure) {
        channelMessages = _setFailure(failure);
      });
    });
  }

  void _setTags() async {
    /// TODO: eventually uncomment
    /*
    final tags = ['tag1', 'tag2', 'tag3'];
    await ZendeskMessaging.setConversationTags(tags);
    */
  }

  void _clearTags() async {
    /// TODO: eventually uncomment
    /*
    await ZendeskMessaging.clearConversationTags();
    */
  }

  void _checkUserLoggedIn() async {
    /// TODO: eventually uncomment
    /*
    Result<bool, Failure> isLoggedIn = await ZendeskMessaging.isLoggedIn();
    if (mounted) {
      isLoggedIn.when(
        (success) {
          setState(() {
            channelMessages.add('User is ${success ? '' : 'not'} logged in');
          });
        },
        (error) {},
      );
    }
    */
  }

  void _setFields() async {
    /// TODO: eventually uncomment
    /*
    Map<String, String> fieldsMap = {};

    fieldsMap["field1"] = "Value 1";
    fieldsMap["field2"] = "Value 2";

    await ZendeskMessaging.setConversationFields(fieldsMap);
    */
  }

  void _clearFields() async {
    /// TODO: eventually uncomment
    /*
    await ZendeskMessaging.clearConversationFields();
    */
  }

  void _show() async {
    Failure? failure = await ZendeskMessaging.show();
    if (mounted == false) return;
    setState(() {
      if (failure == null) {
        channelMessages = "";
      } else {
        channelMessages = _setFailure(failure);
      }
    });
  }

  _setFailure(Failure failure) {
    if (failure.dataType == ZendeskError) {
      return jsonEncode((failure.data as ZendeskError).toJson());
    } else {
      return "$failure";
    }
  }
}
