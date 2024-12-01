import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AppBarState with ChangeNotifier {
  final ScrollController _scrollController = ScrollController();
  bool _isAppBarCollapsed = false;
  bool _isScrolling = false;

  AppBarState() {
    _scrollController.addListener(_scrollListener);
  }

  ScrollController get scrollController => _scrollController;
  bool get isAppBarCollapsed => _isAppBarCollapsed;
  bool get isScrolling => _isScrolling;

  double _appBarHeight = 250.0;
  double get appBarHeight => _appBarHeight;

  void _scrollListener() {
    // Update appBar collapse state based on scroll offset
    if (_scrollController.offset > _appBarHeight && !_isAppBarCollapsed) {
      _isAppBarCollapsed = true;
      notifyListeners();
    } else if (_scrollController.offset <= _appBarHeight && _isAppBarCollapsed) {
      _isAppBarCollapsed = false;
      notifyListeners();
    }

    // Check if the user is actively scrolling
    if (_scrollController.position.userScrollDirection != ScrollDirection.idle) {
      if (!_isScrolling) {
        _isScrolling = true;
        notifyListeners();
      }
    } else {
      if (_isScrolling) {
        _isScrolling = false;
        notifyListeners();
      }
    }
  }


  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
