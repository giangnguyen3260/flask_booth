import 'dart:async';

import 'package:flutter/material.dart';

class BlinkText extends StatefulWidget {
  final String text;
  final int duration;
  final TextStyle textStyle;
  const BlinkText({super.key, this.duration = 500, required this.text, required this.textStyle});

  @override
  _BlinkTextState createState() => _BlinkTextState();
}

class _BlinkTextState extends State<BlinkText> {
  bool _show = true;
  Timer? _timer;

  @override
  void initState() {
    _timer = Timer.periodic(Duration(milliseconds: widget.duration), (_) {
      setState(() => _show = !_show);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Text(widget.text,
      style: _show
          ? widget.textStyle
          : widget.textStyle.copyWith(color: Colors.transparent));

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
