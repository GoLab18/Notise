import 'package:flutter/material.dart';

class CustomFloatingActionButton extends StatefulWidget {
  final VoidCallback onPressed;

  const CustomFloatingActionButton({
    super.key,
    required this.onPressed
  });

  @override
  State<CustomFloatingActionButton> createState() => _CustomFloatingActionButtonState();
}

class _CustomFloatingActionButtonState extends State<CustomFloatingActionButton> {
  final double _scaleDefault = 1.0;
  final double _scalePressed = 0.9;
  final int _durationMs = 120;

  late double _currentScale;


  @override
  void initState() {
    super.initState();

    _currentScale = _scaleDefault;
  }

  void handlePressed() {
    setState(() {
      _currentScale = _scalePressed;
    });

    Future.delayed(Duration(milliseconds: _durationMs), () {
      setState(() {
        _currentScale = _scaleDefault;
      });

      widget.onPressed();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _currentScale,
      duration: Duration(milliseconds: _durationMs),
      child: FloatingActionButton(
        onPressed: handlePressed,
        shape: const CircleBorder(),
        backgroundColor: Colors.blue.shade900,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add)
      ),
    );
  }
}