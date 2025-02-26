import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _seconds = 1500; // 25 دقيقة (25 × 60 ثانية)
  bool _isRunning = false;

  void _startTimer() {
    setState(() {
      _isRunning = true;
    });
    Future.delayed(const Duration(seconds: 1), _tick);
  }

  void _tick() {
    if (_seconds > 0 && _isRunning) {
      setState(() {
        _seconds--;
      });
      Future.delayed(const Duration(seconds: 1), _tick);
    } else {
      setState(() {
        _isRunning = false;
      });
      // يمكنك هنا إضافة إشعار بانتهاء الجلسة
    }
  }

  void _resetTimer() {
    setState(() {
      _seconds = 1500;
      _isRunning = false;
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Focus Tracker')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularPercentIndicator(
              radius: 100.0,
              lineWidth: 10.0,
              percent: _seconds / 1500,
              center: Text(
                _formatTime(_seconds),
                style: const TextStyle(fontSize: 24),
              ),
              progressColor: Colors.blue,
            ),
            const SizedBox(height: 20),
            _isRunning
                ? ElevatedButton(
                  onPressed: _resetTimer,
                  child: const Text("إيقاف"),
                )
                : ElevatedButton(
                  onPressed: _startTimer,
                  child: const Text("ابدأ التركيز"),
                ),
          ],
        ),
      ),
    );
  }
}
