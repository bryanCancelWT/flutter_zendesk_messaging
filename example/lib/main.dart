import 'package:flutter/material.dart';
import 'package:zendesk_messaging/service.dart';

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

  final List<String> channelMessages = [];

  bool isLogin = false;
  int unreadMessageCount = 0;

  @override
  void initState() {
    super.initState();
    // Optional, observe all incoming messages
    ZendeskMessaging.setMessageHandler(
      (type, arguments) {
        setState(() {
          channelMessages.add("$type - args=$arguments");
        });
      },
      useChannelNotPigeon: useChannelNotPigeon,
    );
  }

  @override
  void dispose() {
    /// TODO: eventually uncomment
    /// ZendeskMessaging.invalidate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final message = channelMessages.join("\n");

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
                Text(message),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () => ZendeskMessaging.initialize(
                    useChannelNotPigeon: useChannelNotPigeon,
                    androidChannelKey: androidChannelKey,
                    iosChannelKey: iosChannelKey,
                  ),
                  child: const Text("Initialize"),
                ),
                if (isLogin) ...[
                  ElevatedButton(
                    onPressed: () => ZendeskMessaging.show(),
                    child: const Text("Show messaging"),
                  ),
                  ElevatedButton(
                    onPressed: () => _getUnreadMessageCount(),
                    child:
                        Text('Get unread message count - $unreadMessageCount'),
                  ),
                ],
                ElevatedButton(
                  onPressed: () => _setTags(),
                  child: const Text("Add tags"),
                ),
                ElevatedButton(
                  onPressed: () => _clearTags(),
                  child: const Text("Clear tags"),
                ),
                ElevatedButton(
                  onPressed: () => _login(),
                  child: const Text("Login"),
                ),
                ElevatedButton(
                  onPressed: () => _logout(),
                  child: const Text("Logout"),
                ),
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
                ElevatedButton(
                  onPressed: () => _show(),
                  child: const Text("Show"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _login() {
    // You can attach local observer when calling some methods to be notified when ready
    ZendeskMessaging.loginUser("my_jwt");
  }

  void _logout() {
    ZendeskMessaging.logoutUser();
    setState(() {
      isLogin = false;
    });
  }

  void _getUnreadMessageCount() async {
    /// TODO: eventually uncomment
    /*
    Result<int, Failure> messageCount =
        await ZendeskMessaging.getUnreadMessageCount();
    if (mounted) {
      messageCount.when(
        (success) {
          setState(() {
            unreadMessageCount = success;
          });
        },
        (error) {},
      );
    }
    */
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

  void _show() {
    ZendeskMessaging.show();
  }
}
