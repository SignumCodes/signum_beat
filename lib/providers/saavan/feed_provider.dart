import 'package:flutter/material.dart';
import '../../api/jiosaavn/jiosaavn.dart';
import '../../api/jiosaavn/models/module.dart';

class FeedProvider with ChangeNotifier {
  final JioSaavnClient jio = JioSaavnClient();

  ModuleResponse _module = ModuleResponse();
  List<dynamic> _recoArtist =[];

  ModuleResponse get module => _module;
  List<dynamic> get recoArist=> _recoArtist;

  bool _isLoading = false;
  bool _hasLoaded = false;

  bool get isLoading => _isLoading;
  bool get hasLoaded => _hasLoaded;

  Future<void> loadModules() async {
    if (_hasLoaded) return;

    _isLoading = true;
    notifyListeners();


    try {
      _module = await jio.module.getModules();
      _recoArtist = await jio.module.getArtist()??[];
      _hasLoaded = true;
    } catch (e) {
      print('Error loading modules: $e');

    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
