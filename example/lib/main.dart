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
  final _plugin = FlutterGeminiNano();
  final _controller = TextEditingController();

  bool _loading = false;
  bool? _isAvailable;
  String? _result;
  String? _error;

  @override
  void initState() {
    super.initState();
    _checkAvailability();
  }

  Future<void> _checkAvailability() async {
    try {
      final available = await _plugin.isAvailable();
      setState(() {
        _isAvailable = available;
      });
    } catch (_) {
      setState(() {
        _isAvailable = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _runGemini() async {
    if (_isAvailable != true) {
      setState(() {
        _error = 'Gemini Nano no available on this device.';
      });
      return;
    }

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
        _result = response.result ?? 'No resposta';
      });
    } on UnsupportedError catch (e) {
      setState(() {
        _error = e.message;
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

  Widget _availabilityStatus() {
    if (_isAvailable == null) {
      return const Row(
        children: [
          SizedBox(
            height: 16,
            width: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 8),
          Text('Checking Gemini Nano...'),
        ],
      );
    }

    return Row(
      children: [
        Icon(
          _isAvailable! ? Icons.check_circle : Icons.cancel,
          color: _isAvailable! ? Colors.green : Colors.red,
          size: 18,
        ),
        const SizedBox(width: 8),
        Text(
          _isAvailable! ? 'Gemini Nano available' : 'Gemini Nano unavailable',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Gemini Nano Example')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _availabilityStatus(),
            const SizedBox(height: 12),
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
                onPressed: (_loading || _isAvailable != true)
                    ? null
                    : _runGemini,
                child: _loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Run Gemini Nano'),
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
