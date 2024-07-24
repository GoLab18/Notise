import 'package:flutter/material.dart';

class ButtonTemplate extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;


  const ButtonTemplate({
    super.key,
    required this.text,
    required this.onPressed
  });

  @override
  State<ButtonTemplate> createState() => _ButtonTemplateState();
}

class _ButtonTemplateState extends State<ButtonTemplate> {
  final double _scaleDefault = 1.0;
  final double _scalePressed = 0.9;
  final int _durationMs = 120;

  late double _currentScale;


  @override
  void initState() {
    super.initState();

    _currentScale = _scaleDefault;
  }

  void onButtonPressed() {
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
    return GestureDetector(
      onTap: onButtonPressed,
      child: AnimatedScale(
        scale: _currentScale,
        duration: Duration(milliseconds: _durationMs),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10)
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              widget.text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white
              )
            ),
          )
        ),
      ),
    );
  }
}