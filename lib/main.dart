import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // HTTPリクエスト用パッケージ
import 'dart:convert';

import 'package:speech_to_text/speech_to_text.dart'; // JSONへの変換用パッケージ

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
  var text = "聞きたい曲の名前を教えてください";
  var isListening = false;
  bool isSongExist = true;
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
    return Container(
        margin: const EdgeInsets.only(top: 30),
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/home_image.png"), fit: BoxFit.cover),
        ),
        child: Scaffold(
          backgroundColor: Colors.white.withOpacity(0),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: AvatarGlow(
            animate: isListening,
            duration: const Duration(milliseconds: 2000),
            glowColor: Colors.white,
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
                          if (result.recognizedWords.startsWith("祝日")) {
                            index = 0;
                            playMusic(index);
                            text = "「祝日天国」\nを再生します";
                            isSongExist = true;
                          } else if (result.recognizedWords.startsWith("もう恋")) {
                            index = 1;
                            playMusic(index);
                            text = "「もう恋なんてしない」\nを再生します";
                            isSongExist = true;
                          } else if (result.recognizedWords.startsWith("ディ")) {
                            index = 2;
                            playMusic(index);
                            text = "「DIGNITY」\nを再生します";
                            isSongExist = true;
                          } else if (result.recognizedWords.startsWith("ビーム")) {
                            index = 3;
                            playMusic(index);
                            text = "「ビームが撃てたらいいのに」\nを再生します";
                            isSongExist = true;
                          } else if (result.recognizedWords
                              .startsWith("ハピネス")) {
                            index = 4;
                            playMusic(index);
                            text = "「HAPPINESS」\nを再生します";
                            isSongExist = true;
                          } else if (result.recognizedWords.startsWith("奇跡の")) {
                            index = 5;
                            playMusic(index);
                            text = "「軌跡の果て」\nを再生します";
                            isSongExist = true;
                          } else if (result.recognizedWords.startsWith("クレイ") ||
                              result.recognizedWords.startsWith("クライ")) {
                            index = 6;
                            playMusic(index);
                            text = "「Cradles」\nを再生します";
                            isSongExist = true;
                          } else if (result.recognizedWords
                              .startsWith("フラワー")) {
                            index = 7;
                            playMusic(index);
                            text = "「flowerwall」\nを再生します";
                            isSongExist = true;
                          } else if (result.recognizedWords
                              .startsWith("名もなき")) {
                            index = 8;
                            playMusic(index);
                            text = "「名もなき詩」\nを再生します";
                            isSongExist = true;
                          } else if (result.recognizedWords
                              .startsWith("プリテン")) {
                            index = 9;
                            playMusic(index);
                            text = "「Pretender」\nを再生します";
                            isSongExist = true;
                          } else {
                            text = "";
                            isSongExist = false;
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
                if (!isSongExist) {
                  text = "該当する曲がありません\nもう一度教えてください";
                } else {
                  text = "聞きたい曲の名前を教えてください";
                }
              },
              child: CircleAvatar(
                backgroundColor: Colors.deepPurple,
                radius: 35,
                child: Icon(
                  isListening ? Icons.mic : Icons.mic_none,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 30), // 縦の余白
              ],
            ),
          ),
        ));
  }
}
