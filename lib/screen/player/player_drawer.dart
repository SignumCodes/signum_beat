import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../providers/playSong/playSongProvider.dart';
import '../../providers/playSong/universalVariableProvider.dart';
import '../../utils/constants/color_const.dart';
import '../../widgets/tile/songTile.dart';

class StylishMusicDrawer extends StatefulWidget {
  final List<dynamic> data;

  const StylishMusicDrawer({Key? key, required this.data}) : super(key: key);

  @override
  _StylishMusicDrawerState createState() => _StylishMusicDrawerState();
}

class _StylishMusicDrawerState extends State<StylishMusicDrawer> {
  bool _isRepeatMode = false;
  bool _isShuffleMode = false;

  @override
  Widget build(BuildContext context) {
    var playProvider = Provider.of<PlaySongProvider>(context);
    final uniVarProvider = Provider.of<UniVarProvider>(context);

    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepPurple.shade900,
              Colors.black,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drawer Header
              _buildDrawerHeader(context),

              // Toggle Controls
              _buildToggleControls(),

              // Song List
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  itemCount: widget.data.length,
                  itemBuilder: (context, index) {
                    return _buildSongListItem(playProvider, index);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Playlist',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleControls() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildToggleButton(
            icon: Icons.repeat,
            isActive: _isRepeatMode,
            onToggle: () {
              setState(() {
                _isRepeatMode = !_isRepeatMode;
              });
            },
          ),
          _buildToggleButton(
            icon: Icons.shuffle,
            isActive: _isShuffleMode,
            onToggle: () {
              setState(() {
                _isShuffleMode = !_isShuffleMode;
                if (_isShuffleMode) {
                  UniVarProvider.shuffleDataList();
                }
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton({
    required IconData icon,
    required bool isActive,
    required VoidCallback onToggle,
  }) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: isActive ? Colors.deepPurple : Colors.white12,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Icon(
          icon,
          color: isActive ? Colors.white : Colors.white70,
          size: 30,
        ),
      ),
    );
  }

  Widget _buildSongListItem(PlaySongProvider playProvider, int index) {
    var song = widget.data[index];
    bool isCurrentlyPlaying = playProvider.playIndex == index;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: isCurrentlyPlaying
            ? Colors.deepPurple.withOpacity(0.3)
            : Colors.white12,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: NetworkImage(song.image.last.link),
              fit: BoxFit.cover,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 5,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
        title: Text(
          song.name,
          style: TextStyle(
            color: Colors.white,
            fontWeight: isCurrentlyPlaying ? FontWeight.bold : FontWeight.normal,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          song.primaryArtists,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: isCurrentlyPlaying
            ? Icon(Icons.equalizer, color: Colors.deepPurple)
            : null,
        onTap: () {
          playProvider.playSong(song, index);
          Navigator.pop(context); // Close drawer after selection
        },
      ),
    );
  }
}