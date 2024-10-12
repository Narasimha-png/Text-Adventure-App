import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'game_logic.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Text Adventure Game with Dora',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final GameLogic gameLogic = GameLogic();
  final TextEditingController controller = TextEditingController();
  String output = 'Welcome to the game! Type "look" to start.';
  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _voiceCommand = '';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _submitCommand(String command) {
    if (command.isNotEmpty) {
      setState(() {
        output = gameLogic.processCommand(command);
        controller.clear();
      });
    }
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(onResult: (val) => setState(() {
              _voiceCommand = val.recognizedWords;
              if (val.finalResult) {
                _submitCommand(_voiceCommand);
                _isListening = false;
              }
            }));
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Text Adventure Game with Dora')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Image.asset('assets/dora.png', height: 200), // Dora image
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        output,
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            TextField(
              controller: controller,
              onSubmitted: (_) => _submitCommand(controller.text),
              decoration: InputDecoration(
                labelText: 'Enter Command',
                suffixIcon: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _submitCommand(controller.text),
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _listen,
              child: Text(_isListening ? 'Listening...' : 'Voice Command'),
            ),
          ],
        ),
      ),
    );
  }
}
