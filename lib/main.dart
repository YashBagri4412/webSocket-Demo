import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'WebSocket';
    return MaterialApp(
      title: title,
      home: MyHomePage(
        title: title,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _channel = WebSocketChannel.connect(
    Uri.parse('wss://miniproject-msrit.herokuapp.com/ws2'),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: StreamBuilder(
          stream: _channel.stream,
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              final response = jsonDecode(snapshot.data.toString());
              print(response['MOSFET_TEMP']);
              //'MOSFET_TEMP' 'SPEED' 'BATTERY' 'DISTANCE' 'FAULT_CODE'
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Mosfet temp is : ${response['MOSFET_TEMP']}'),
                  Text('Speed is : ${response['SPEED']}'),
                  Text('Battery is : ${response['BATTERY']}'),
                  Text('Distance is : ${response['DISTANCE']}'),
                  Text('Fault code is : ${response['FAULT_CODE']}'),
                ],
              );
            } else {
              return Text("Hello");
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Send message',
        child: Icon(Icons.send),
      ),
    );
  }

  void _sendMessage() {
    _channel.sink.add('yes');
  }

  Future<void> getText() async {
    for (int i = 0; i < 5; i++) {
      var url = Uri.parse('https://miniproject-msrit.herokuapp.com/');
      var response = await http.get(url);
      print(response.body.toString());
    }
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }
}
