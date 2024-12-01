import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/home/navigation_provider.dart';
import '../../providers/permistion_provider.dart';
import '../../providers/playSong/playSongProvider.dart';




class NavigationPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final permissionProvider = Provider.of<PermissionProvider>(context);
    final playSongProvider = Provider.of<PlaySongProvider>(context);
    return Scaffold(
      body: Consumer<NavigationProvider>(
        builder: (context, provider, child) {
          return provider.pages[provider.currentIndex];
        },
      ),
      /*floatingActionButton: StreamBuilder<ProcessingState>(
        stream: playSongProvider.audioPlayer.processingStateStream,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data == ProcessingState.ready) {
            return PositionedFloatingActionButton(
              top: 15,
              left: 18,
              floatingActionButton: FloatingPlayer(),
            );
          } else {
            return Container(); // Return an empty sized box if processing state is not ready
          }
        },
      ),*/
      bottomNavigationBar: Consumer<NavigationProvider>(
        builder: (context, provider, child) {
          return bottomNavigationBar(context, provider);
        },
      ),

    );
  }

  bottomNavigationBar(context, NavigationProvider provider) {
    return SizedBox(
      height: 70,
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

