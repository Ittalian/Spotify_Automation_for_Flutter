import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // HTTPリクエスト用パッケージ
import 'dart:convert';

import 'package:speech_to_text/speech_to_text.dart'; // JSONへの変換用パッケージ

const BG_COLOR = Color(0xff2C2C2C);
const TEXT_COLOR = Color(0xffFEFDFC);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  final title = 'Spotify Automation';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'spotify automation',
      home: MyHomePage(title: title),
      debugShowCheckedModeBanner: false,
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
  SpeechToText speechToText = SpeechToText();
  var text = "音声を文字に変換します";
  var debugText = "";
  var isListening = false;
  var index = 0;

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
    final playMusicResponse = await http.put(playMusicUrl,
        headers: {
          'Authorization': 'Bearer ${accessToken.toString()}',
          'Content-Type': 'application/json',
        },
        body: playMusicBody);
    setState(() {
      responseState = playMusicResponse;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: AvatarGlow(
        animate: isListening,
        duration: const Duration(milliseconds: 2000),
        glowColor: BG_COLOR,
        child: GestureDetector(
          // ボタンを押している間だけ認識
          onTapDown: (details) async {
            if (!isListening) {
              var available = await speechToText.initialize();
              if (available) {
                setState(() {
                  isListening = true;
                  speechToText.listen(
                    onResult: (result) {
                      setState(() {
                        text = result.recognizedWords;
                      });
                      if (result.recognizedWords.startsWith("こ")) {
                        index = 3;
                        playMusic(index);
                        debugText = "認識";
                      }
                    },
                    localeId: 'ja_JP', // 日本語の設定
                  );
                });
              }
            }
          },
          // ボタンを離すと認識
          onTapUp: (details) {
            setState(() {
              isListening = false;
            });
            speechToText.stop();
          },
          child: CircleAvatar(
            backgroundColor: BG_COLOR,
            radius: 35,
            child: Icon(
              isListening ? Icons.mic : Icons.mic_none,
              color: Colors.white,
            ),
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text(
          'Spotify API',
          style: TextStyle(fontWeight: FontWeight.w600, color: TEXT_COLOR),
        ),
        backgroundColor: BG_COLOR,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              responseState == null ? '' : "Completed!",
              style: const TextStyle(fontSize: 30),
            ),
            const SizedBox(height: 30), // 縦の余白
            ElevatedButton(
              onPressed: () => playMusic(3),
              child: const Text('Push to play music!'),
            ),
            const SizedBox(height: 30),

            // デバッグ用
            Text(text),
            const SizedBox(height: 30),
            Text(debugText)
            
          ],
        ),
      ),
    );
  }
}
