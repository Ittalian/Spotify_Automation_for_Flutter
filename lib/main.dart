import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // HTTPリクエスト用パッケージ
import 'dart:convert'; // JSONへの変換用パッケージ

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  final title = 'Spotify API';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spotify API',
      home: MyHomePage(title: this.title),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  dynamic responseState;

  Future<void> getAccessToken() async {
    final url = Uri.parse('https://accounts.spotify.com/api/token');
    final response = await http.post(url, headers: {
      'Authorization':
          'Basic ZDMxNGNhZjdhODIwNDlmZWIwYzgwYzZiOTIzZGNkODA6YzUxOTU3ZmNiYWVhNDAwMDhlYjRkOGJhYzgwMzQwYmU=',
      'Content-Type': 'application/x-www-form-urlencoded',
    }, body: {
      'grant_type': 'refresh_token',
      'refresh_token':
          'AQDgisALHNFTFI2N1Rlj9_x1XgJdt6sB3wQXHDsvJtgBObpRvAD4O5bx1RjCIeBzA3T4wLSuoFyNyL0fsAvC3aBioPZxyfx8N7bwT6rn4J51V5crgBLdkWQdqfBwhBbd5HA',
    });
    final accessToken = jsonDecode(response.body);
    setState(() {
      responseState = accessToken;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spotify API'),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              responseState == null ? 'Outputed Response' : responseState['access_token'],
              style: const TextStyle(fontSize: 30),
            ),
            ElevatedButton(
              onPressed: getAccessToken,
              child: const Text('APIを叩くよ'),
            )
          ],
        ),
      ),
    );
  }
}
