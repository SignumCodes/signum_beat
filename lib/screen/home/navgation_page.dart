import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../providers/home/navigation_provider.dart';
import '../../providers/permistion_provider.dart';
import '../../providers/playSong/playSongProvider.dart';




class NavigationPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<NavigationProvider>(
        builder: (context, provider, child) {
          return provider.pages[provider.currentIndex];
        },
      ),
      // bottomNavigationBar: Consumer<NavigationProvider>(
      //   builder: (context, provider, child) {
      //     return bottomNavigationBar(context, provider);
      //   },
      // ),

    );
  }

  bottomNavigationBar(context, NavigationProvider provider) {
    return SizedBox(
      height: 90.h,
      child: NavigationBar(
        onDestinationSelected: (index) => provider.setIndex(index),
        selectedIndex: provider.currentIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(Icons.play_circle),
            label: 'Feed',
          ),
          NavigationDestination(
            icon: Icon(Icons.music_note),
            label: 'My Library',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat),
            label: 'Chat it',
          ),
        ],
      ),
    );
  }
}

