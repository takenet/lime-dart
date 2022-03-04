# lime-dart

> Dart implementation of LIME - A lightweight messaging library

[![npm version](https://img.shields.io/npm/v/lime-js.svg?style=flat-square)](https://www.npmjs.com/package/lime-js)

<!-- [![Build Status](https://travis-ci.org/takenet/lime-js.svg)](https://travis-ci.org/takenet/lime-js) -->

LIME allows you to build scalable, real-time messaging applications using a JSON-based [open protocol](http://limeprotocol.org). It's **fully asynchronous** and supports any persistent transport like TCP or Websockets.

You can send and receive any type of object into the wire as long it can be represented as JSON or text (plain or encoded with base64) and it has a **MIME type** to allow the other party handle it in the right way.

The connected nodes can send receipts to the other parties to notify events about messages (for instance, a message was received or the content invalid or not supported).

Besides that, there's a **REST capable** command interface with verbs (_get, set and delete_) and resource identifiers (URIs) to allow rich messaging scenarios. You can use that to provide services like on-band account registration or instance-messaging resources, like presence or roster management.

Finally it has built-in support for authentication, transport encryption and compression.

## Protocol overview

### Envelopes

The basic protocol data package is called **envelope**. As mentioned before, there are four types:

- **Message** - Transports content between nodes
- **Notification** - Notify about message events
- **Command** - Provides an interface for resource management
- **Session** - Establishes the communication channel

All envelope types share some properties (like the `id` - the envelope unique identifier - and the `from` and `to` routing information) but there are some unique properties of each one that allows the proper deserialization when a JSON object is received by the transport.

### Transports

The `Transport` interface represents a persistent transport connection that allows the management of the connection state, besides sending and receiving envelopes. Currently, the dart implementation provides a few official packages for Lime transport classes. These are publicly available on NPM and on our [Github](https://github.com/takenet), but we plan on building more transport classes for Dart:

- [WebSocketTransport](https://github.com/takenet/lime-dart/blob/master/lib/src/protocol/network/web_socket_transport.dart)

### Channels

When two nodes are connected to each other a **session** can be established between them. To help the management of the session state, the library defines the `Channel` abstract class, an abstraction of the session over the `Transport` instance. The node that received the connection is the **server** and the one who is connecting is the **client**. There is currently only one specific implementation of this class for the client (`ClientChannel`), providing specific functionality for the client role in the connection. The only difference between the client and the server is related to the session state management, where the server has full control of it. Besides that, they share the same set of funcionalities.

## How to use

Simply install the `lime-dart` package from the [pub.dev](pub.dev) registry.

With Dart:

    dart pub add lime-dart

With Flutter:

    flutter pub add lime-dart

#### Example

```dart
import 'package:path/path.dart';

class MyClass {
  Iterable<Message> messages;
}
```

#### Or

```dart
import 'package:path/path.dart' as Lime;

class MyClass {
  Iterable<Lime.Message> messages;
}
```

### Starting a connection

To start a connection with a server in a specific domain, the client can use **DNS queries** to check for a _lime_ SRV entry and get the server address. This is not mandatory and the client can use static connection information, but its a good idea to rely on DNS since the protocol is domain based. In the code, the method `open` of the `Transport` interface should be called passing the remote URI (in the server, the URI parameter can be null).

After connecting the transport, the client should send a **new session** envelope to start the session negotiation. The `ClientChannel` class provides the method `startNewSession` for that.

#### Example

```dart
// Creates a new transport and connect to the server
let serverUri = 'ws://localhost:55321';
let transport = WebSocketTransport();

await transport.open(serverUri);

final clientChannel = ClientChannel(transport);
```

### Session establishment

The server is the responsible for the establishment of the session and its parameters, like the `id` and node information (both local and remote). It can optionally negotiate transport options and authenticate the client using a supported authentication scheme. Note that the protocol did not dictate that the session negotiation and authentication are mandatory. In fact, after receiving a **new session** envelope, the server can just send an **established session** envelope to the client to start the envelope exchanging.

#### Negotiation

During the negotiation of transport options, the server sends to the client the available compression and encryption options and allows it to choose which one it wants to use in the session. The client select its options using the `negotiateSession` method from `ClientChannel`. After receiving and validating the client choices the server echoes them back to the client, allowing it to apply the transport options, and the server does itself the same. The `Transport` interface has the methods `setCompression` and `setEncryption` for this reason, but the `Channel` implementation already handles that automatically.

#### Authentication

After the negotiation of transport options negotiation, the server presents to the client the available authentication schemes and the client shall provide the scheme-specific data and identify itself with an identity, which is presented as **name@domain** (like an e-mail). Usually the domain of the client identity is the same of the server if the client is using a local authentication scheme (username/password) but can be a stranger domain if the client is using a transport authentication (TLS certificate).

#### Establishment

When the server establishes the session, it assigns to the client a unique node identifier, in the format **name@domain/instance** similar to the Jabber ID in the XMPP protocol. This identifier is important for envelope routing in multi-party server connection scenarios.

#### Examples

```dart
// Method 1: Establish the session using a helper method
// Method 2: Establish the session manually
```

### Exchanging envelopes

With an established session the nodes can exchange messages, notifications and commands until the server finishes the session. The `Channel` class defines methods to send and receive specific envelopes, like `sendMessage` and `receiveMessage` for messages or `sendCommand` and `receiveCommand` for commands.

#### Routing

The protocol doesn't explicitly define how envelope routing should work during a session. The sole definition is that if an originator does not provide the `to` property value, it means that the message is addressed to the immediate remote party; in the same way that if a node has received an envelope without the `from` property value, it must assume that the envelope is originated by the remote party.

An originator can send an envelope addressed to any destination in the remote server and it may or may not accept it. But an originator should address an envelope to a node different of the remote party only if it is trusted for receiving these envelopes. A remote party can be trusted for that if it has presented a valid domain certificate during the session negotiation. In this case, this node can receive and send envelopes for any identity of the authenticated domain.

#### Examples

##### Messages and notifications

```dart
// Sending a plain text message to the remote party
final textMessage = Message(
  type: 'text/plain',
  content: 'Hello!'
);
clientChannel.sendMessage(textMessage);

// Sending a generic JSON message addressed to a specific node
final jsonMessage = Message(
  to: 'anyone@domain.com',
  type: 'application/json',
  content: JSON.stringify({
    'property1': 'string value',
    'property2': 2,
    'property3': true,
  })
);
clientChannel.sendMessage(jsonMessage);

// Receive a message
clientChannel.onReceiveMessage.stream.listen((Message receivedMessage) {
  console.log('Message received from ${receivedMessage.from}: ${receivedMessage.content}');

  // Send a notification
  final notification = Notification(
    id: receivedMessage.id,
    event: NotificationEvent.received
  );

  clientChannel.sendNotification(notification);
});

// Receive a notification
clientChannel.onReceiveNotification.stream.listen((Notification receivedNotification) => {
  console.log(`Message received from ${receivedNotification.from}: ${receivedNotification.event}`);
});
```

##### Commands

```dart
// Arbitrary commands
final getContactsCommand = Command(
  id: Lime.Guid(),
  method: CommandMethod.GET,
  uri: MY_CONTACTS_URI
);

clientChannel.sendCommand(getContactsCommand);

clientChannel.onReceiveCommand.stream.listen((Command command) => {
  if (command.id == getContactsCommand.id && command.status === CommandStatus.success) {
    final contacts = command.resource;

    for(final contact in contacts) {
      // ...
    }
  }
});
```
