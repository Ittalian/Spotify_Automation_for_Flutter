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

  // アクセストークンの取得
  Future<void> playMusic(int index) async {
    final accessTokenUrl = Uri.parse('https://accounts.spotify.com/api/token');
    final accessTokenResponse = await http.post(accessTokenUrl, headers: {
      'Authorization':
          'Basic ZDMxNGNhZjdhODIwNDlmZWIwYzgwYzZiOTIzZGNkODA6YzUxOTU3ZmNiYWVhNDAwMDhlYjRkOGJhYzgwMzQwYmU=',
      'Content-Type': 'application/x-www-form-urlencoded',
    }, body: {
      'grant_type': 'refresh_token',
      'refresh_token':
          'AQDgisALHNFTFI2N1Rlj9_x1XgJdt6sB3wQXHDsvJtgBObpRvAD4O5bx1RjCIeBzA3T4wLSuoFyNyL0fsAvC3aBioPZxyfx8N7bwT6rn4J51V5crgBLdkWQdqfBwhBbd5HA',
    });

    final accessToken = jsonDecode(accessTokenResponse.body)['access_token'];
    final playMusicUrl = Uri.parse(
        'https://api.spotify.com/v1/me/player/play?device_id=4bb8a462453c69392da0985c0084e61c96dadbc7');
    final playMusicBody = jsonEncode({
      'context_uri': 'spotify:playlist:6OJHpbVGr7JigmFEU9xq0O',
      'offset': {
        'position': index,
      },
      'position_ms': 0,
    });
    final playMusicResponse = await http.put(
      playMusicUrl,
      headers: {
      'Authorization': 'Bearer ${accessToken.toString()}',
      'Content-Type': 'application/json',
      },
      body: playMusicBody
    );

    setState(() {
      responseState = playMusicResponse;
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
              responseState == null
                  ? ''
                  : "completed!",
              style: const TextStyle(fontSize: 30),
            ),
            ElevatedButton(
              onPressed: () => playMusic(3),
              child: const Text('Push to play music!'),
            )
          ],
        ),
      ),
    );
  }
}
