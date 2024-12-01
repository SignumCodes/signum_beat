import 'package:flutter/material.dart';

import '../../screen/download/downloads_page.dart';
import '../../screen/home/home_screen.dart';
import '../../screen/home/my_library.dart';
import '../../screen/search/search_screen.dart';

class NavigationProvider with ChangeNotifier {


  final List<Widget> pages = [

    const HomeScreen(),
    const SearchScreen(),
    const Scaffold(body: Center(child: Text('3rd'),),),
    LibrarySong(),
    DownloadPage(),

  ];

  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
