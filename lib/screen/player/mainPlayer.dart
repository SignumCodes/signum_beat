import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:signum_beat/screen/player/player_drawer.dart';

import '../../providers/playSong/playSongProvider.dart';
import '../../providers/playSong/universalVariableProvider.dart';
import '../../utils/constants/color_const.dart';
import '../../widgets/text_widget/normal_text.dart';
import '../../widgets/tile/songTile.dart';
import 'video_player.dart';

class MainPlayer extends StatefulWidget {
  final List<dynamic> data;

  const MainPlayer({Key? key, required this.data}) : super(key: key);

  @override
  State<MainPlayer> createState() => _MainPlayerState();
}

class _MainPlayerState extends State<MainPlayer> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var playProvider = Provider.of<PlaySongProvider>(context);
    final uniVarProvider = Provider.of<UniVarProvider>(context);

    return Scaffold(
      key: _scaffoldKey, // Add scaffold key
      drawer: StylishMusicDrawer(data: widget.data), // Add the stylish drawer
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Gradient Background
            Container(
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
            ),

            // Main Content
            Column(
              children: [
                // Top Section with Album Art and Controls
                _buildTopSection(playProvider, context),

                // Song List
                // Expanded(
                //   child: Container(
                //     decoration: BoxDecoration(
                //       color: Colors.black.withOpacity(0.5),
                //       borderRadius: const BorderRadius.only(
                //         topLeft: Radius.circular(30),
                //         topRight: Radius.circular(30),
                //       ),
                //     ),
                //     child: ListView.builder(
                //       padding: const EdgeInsets.symmetric(vertical: 20),
                //       itemBuilder: (context, index) {
                //         return Padding(
                //           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                //           child: SongTile(
                //             song: widget.data[index],
                //             onTap: () {
                //               playProvider.playSong(widget.data[index], index);
                //             },
                //           ),
                //         );
                //       },
                //       itemCount: widget.data.length,
                //     ),
                //   ),
                // ),

                // Player Controls
                Spacer(),
                _buildPlayerControls(playProvider, widget.data),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopSection(PlaySongProvider playProvider, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Back Button and Playlist Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                backgroundColor: Colors.white12,
                child: IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () {
                    // Open the drawer
                    _scaffoldKey.currentState?.openDrawer();
                  },
                ),
              ),
              CircleAvatar(
                backgroundColor: Colors.white12,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Album Art
          RotationTransition(
            turns: _animationController,
            child: Container(
              width: 300.w,
              height: 300.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.2),
                    blurRadius: 25,
                    spreadRadius: 5,
                  )
                ],
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(playProvider.playingModSong.image.last.link),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Song Details
          Column(
            children: [
              NormalText(
                text: HtmlUnescape().convert(playProvider.playingModSong.name),
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              NormalText(
                text: HtmlUnescape().convert(playProvider.playingModSong.primaryArtists),
                fontSize: 16,
                color: Colors.white70,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerControls(PlaySongProvider playProvider, List<dynamic> data) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          // Progress Slider
          SliderTheme(
            data: const SliderThemeData(
              trackHeight: 5,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 15),
            ),
            child: Slider(
              activeColor: Colors.deepPurple,
              inactiveColor: Colors.white24,
              min: 0,
              max: playProvider.max,
              value: playProvider.value,
              onChanged: (newValue) {
                playProvider.changeDurationToSecond(newValue.toInt());
              },
            ),
          ),

          // Time Display
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(playProvider.position, style: const TextStyle(color: Colors.white70)),
                Text(playProvider.duration, style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ),

          // Control Buttons
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _controlButton(Icons.shuffle, () => UniVarProvider.shuffleDataList()),
              _controlButton(Icons.skip_previous_rounded, () {
                if (playProvider.playIndex > 0) {
                  playProvider.playSong(
                    data[playProvider.playIndex - 1],
                    playProvider.playIndex - 1,
                  );
                }
              }),
              _playPauseButton(playProvider),
              _controlButton(Icons.skip_next_rounded, () {
                if (playProvider.playIndex < data.length - 1) {
                  playProvider.playSong(
                    data[playProvider.playIndex + 1],
                    playProvider.playIndex + 1,
                  );
                }
              }),
              _controlButton(Icons.lyrics, () {
                // Implement lyrics functionality
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _controlButton(IconData icon, VoidCallback onPressed) {
    return CircleAvatar(
      backgroundColor: Colors.white12,
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }

  Widget _playPauseButton(PlaySongProvider playProvider) {
    return CircleAvatar(
      radius: 35,
      backgroundColor: Colors.deepPurple,
      child: IconButton(
        iconSize: 35,
        icon: Icon(
          playProvider.isPlaying ? Icons.pause : Icons.play_arrow_rounded,
          color: Colors.white,
        ),
        onPressed: () {
          if (playProvider.isPlaying) {
            playProvider.audioPlayer.pause();
            playProvider.isPlaying = false;
          } else {
            playProvider.audioPlayer.play();
            playProvider.isPlaying = true;
          }
        },
      ),
    );
  }
}