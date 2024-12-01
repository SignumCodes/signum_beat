import 'package:flutter/material.dart';

class BlinkingShadowProvider extends ChangeNotifier {
  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation;
  bool _isPlaying = false;
  int _currentColorIndex = 0;
  final List<Color> _colors = [Colors.blue, Colors.red, Colors.green]; // Customize colors

  BlinkingShadowProvider(TickerProvider vsync) {
    _animationController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 500),
    );_colorAnimation = ColorTween(
      begin: _colors[_currentColorIndex],
      end: _colors[(_currentColorIndex + 1) % _colors.length],
    ).animate(_animationController);

    _animationController.addListener(() {
      if (_animationController.status == AnimationStatus.completed) {
        _currentColorIndex = (_currentColorIndex + 1) % _colors.length;
        _colorAnimation = ColorTween(
          begin: _colors[_currentColorIndex],
          end: _colors[(_currentColorIndex + 1) % _colors.length],
        ).animate(_animationController);
        _animationController.forward(from: 0.0);
      }
    });
  }

  Animation<Color?> get colorAnimation => _colorAnimation;

  bool get isPlaying => _isPlaying;

  void startAnimation() {
    if (!_isPlaying) {
      _isPlaying = true;
      _animationController.repeat(reverse: true);
      notifyListeners();
    }
  }

  void stopAnimation() {
    if (_isPlaying) {
      _isPlaying = false;
      _animationController.stop();notifyListeners();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}