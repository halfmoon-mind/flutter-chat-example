# flutter-chat-example

This is a simple chat application example using Flutter and Node.js.

## Getting Started (Server)

In your terminal:

```
cd node-chat-server
npm install
npm start
```

if you want to run server in background, you can use 'forever' package:

```
npm install forever -g
forever start -c "npm start" ./node-chat-server/
```

**Note:** You must run server in root directory of project.

## Getting Started (Client)

In your terminal:

```
cd flutter-chat
flutter pub get
flutter run
```
