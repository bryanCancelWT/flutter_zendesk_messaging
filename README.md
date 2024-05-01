# Zendesk Messaging

> [!NOTE]
> Very welcome every developer to contribute to this package of Zendesk. Now I have no much time to maintain regularly🥸

<a href="https://pub.dev/packages/zendesk_messaging"><img src="https://img.shields.io/pub/v/zendesk_messaging.svg" alt="Pub"></a>


![](Messaging.png)

**Messaging** is a "user-based" chat

**Live Chat** is a "session-based" chat

- **Better UI (Native)**
- **Chat history**
- **Answer Bot**

-------------------

## Setup
### 1. Enable agent work-space
![](screenshot/screenshot_1.png)
### 2. Enable Messaging
![](screenshot/screenshot_2.png)
###
![](screenshot/screenshot_3.png)
### 3. Add channel and get key
![](screenshot/screenshot_4.png)
###
![](screenshot/screenshot_5.png)

## How to use?
### Initialize
``` dart
  final String androidChannelKey = '';
  final String iosChannelKey = '';

  Failure? failure = await ZendeskMessaging.initialize(
    androidChannelKey: androidChannelKey,
    iosChannelKey: iosChannelKey,
  );
```
> Just use initialize() one time

### Show
The SDK needs to be initialized before
```dart
Failure? failure = await ZendeskMessaging.show();
```
> You can use in onTap()

### Retrieve the unread message count (optional)
The SDK needs to be initialized before
There's must be a logged user to allow the recovery of the unread message count
```dart
Result<int, Failure> result =
        await ZendeskMessaging.getUnreadMessageCount();
```
> If there's no user logged in, the message count will always be zero.

### Authenticate (optional)
The SDK needs to be initialized before
```dart
// login
Result<ZendeskUser, Failure> result = await ZendeskMessaging.loginUser("YOUR_JWT");

// logout
Failure? failure = await ZendeskMessaging.logoutUser();
```

### Set conversation fields (optional)
```dart
Failure? failure = await ZendeskMessaging.setConversationFields({"field1": "Value 1"});
```

### Clear conversation fields(optional)
```dart
Failure? failure = await ZendeskMessaging.clearConversationFields();
```

### Set tags to a support ticket (optional)
Allows custom conversation tags to be set, adding contextual data about the conversation.
```dart
// Add tags to a conversation
Failure? failure = await ZendeskMessaging.setConversationTags(['tag1', 'tag2', 'tag3']);

// Note: Conversation tags are not immediately associated with a conversation when this method is called.
// It will only be applied to a conversation when end users either start a new conversation or send a new message in an existing conversation.
```

### Clear conversation tags (optional)
Allows custom conversation tags to be set, adding contextual data about the conversation.
```dart
// Allows you to clear conversation tags from native SDK storage when the client side context changes.
// This removes all stored conversation tags from the natice SDK storage.
Failure? failure = await ZendeskMessaging.clearConversationTags();

// Note: This method does not affect conversation tags already applied to the conversation.
```

### Invalidate (optional)
After calling this method you will have to call ZendeskMessaging.initialize again if you would like to use ZendeskMessaging.
``` dart
Failure? failure = await ZendeskMessaging.invalidate()
```
> This can be useful if you need to initiate a chat with another set of `androidChannelKey` and `iosChannelKey`

### Check initialization state (optional)
```dart
Result<bool, Failure> result = await ZendeskMessaging.getIsInitialized()
```

### Check authentication state (optional)
The SDK needs to be initialized before
```dart
Result<bool, Failure> result = await ZendeskMessaging.getIsLoggedIn();
```

## Known shortcomings
- **Attachment file**：`Currently does not support.` The official said it will be launched in the future.
- **Chat room closed**：An agent can not reply to a customer at any time.
if the customer is not active in the foreground, the room will be closed automatically. It is inconvenient to track chat history.

## Future Function
- Push Notifications

## Link
- [Zendesk messaging Help](https://support.zendesk.com/hc/en-us/sections/360011686513-Zendesk-messaging)
- [Agent Workspace for messaging](https://support.zendesk.com/hc/en-us/articles/360055902354-Agent-Workspace-for-messaging)
- [Working with messaging in your Android and iOS SDKs](https://support.zendesk.com/hc/en-us/articles/1260801714930-Working-with-messaging-in-your-Android-and-iOS-SDKs)

## Contribute
- You can star and share with other developers if you feel good and learn something from this repository.
- If you have some ideas, please discuss them with us or commit PR.