import 'package:flutter/material.dart';

import 'package:shared/env.dart';

import 'spinning_basketball.dart';

void main() => runApp(App());

class App extends StatefulWidget {
  static String _pkg = "basketball_ptr";
  static String? get pkg => Env.getPackage(_pkg);

  final double maxHeight;

  App({
    this.maxHeight = 180,
  });

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(seconds: 2, milliseconds: 500));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SpinningBasketball(
      controller: _controller,
      maxHeight: widget.maxHeight,
    );
  }
}
