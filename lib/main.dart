import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Enviar Requisição',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String url = '';
  String latitude = '';
  String longitude = '';

  void _getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      latitude = position.latitude.toString();
      longitude = position.longitude.toString();
    });
  }

  void my_pooling(){
    _getLocation();
    _sendRequest();
  }

  void _sendRequest() async {
    final Map<String, String> headers = {'Content-Type': 'application/json'};
    final Map<String, dynamic> data = {'lat': latitude, 'lon': longitude};
    final String jsonData = jsonEncode(data);
    final response = await http.post(Uri.parse(url),
    headers: headers,
    body: jsonData);
    if (response.statusCode == 200) {

    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erro'),
            content: Text('Falha ao enviar a requisição!'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enviar Requisição'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Latitude: $latitude',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 10.0),
            Text(
              'Longitude: $longitude',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 20.0),
            TextField(
              onChanged: (value) {
                setState(() {
                  url = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'URL',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Sucesso'),
                    content: Text('Iniciou envio de cordenadas com sucesso!\n\n'
                    'Latitude: $latitude\n'
                    'Longitude: $longitude'),
                    actions: [
                      TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      ),
                    ],
                  );
                  },
                );          
                _getLocation();
                Timer.periodic(Duration(seconds: 5), (Timer timer) {
                  my_pooling();
                });
              },
              child: Text('Enviar Requisição'),
            ),
          ],
        ),
      ),
    );
  }
}
