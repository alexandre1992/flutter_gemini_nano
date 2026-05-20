import 'package:flutter/material.dart';
import 'package:flutter_gemini_nano/flutter_gemini_nano.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GeminiNanoExample(),
    );
  }
}

class GeminiNanoExample extends StatefulWidget {
  const GeminiNanoExample({super.key});

  @override
  State<GeminiNanoExample> createState() => _GeminiNanoExampleState();
}

class _GeminiNanoExampleState extends State<GeminiNanoExample> {
  final _plugin = FlutterGeminiNano.instance;
  final _controller = TextEditingController();

  bool _loading = false;
  String? _result;
  String? _error;

  Future<void> _runGemini() async {
    setState(() {
      _loading = true;
      _result = null;
      _error = null;
    });

    try {
      final response = await _plugin.generate(
        prompt: _controller.text,
        temperature: 0.7,
        maxOutputTokens: 128,
      );

      setState(() {
        _result = response.result ?? 'Sem resposta';
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Gemini Nano Example')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Prompt',
                border: OutlineInputBorder(),
              ),
              minLines: 2,
              maxLines: 4,
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _runGemini,
                child: _loading
                    ? const CircularProgressIndicator()
                    : const Text('Executar Gemini Nano'),
              ),
            ),
            const SizedBox(height: 16),
            if (_result != null)
              Expanded(
                child: SingleChildScrollView(
                  child: Text(_result!, style: const TextStyle(fontSize: 16)),
                ),
              ),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
