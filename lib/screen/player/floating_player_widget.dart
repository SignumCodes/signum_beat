import 'dart:math';

import 'package:signum_beat/screen/player/mainPlayer.dart';
import 'package:signum_beat/utils/constants/color_const.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../api/jiosaavn/models/song.dart';
import '../../providers/playSong/playSongProvider.dart';
import '../../providers/playSong/universalVariableProvider.dart';
import '../../utils/constants/const_var.dart';

class FloatingPlayer extends StatefulWidget {
  FloatingPlayer({super.key});

  @override
  _FloatingPlayerState createState() => _FloatingPlayerState();
}

class _FloatingPlayerState extends State<FloatingPlayer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(); // Continuously repeat the animation
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final playSongProvider = Provider.of<PlaySongProvider>(context);

    return playSongProvider.playingModSong is SongResponse
        ? songResponseWidget(context, playSongProvider)
        : const SizedBox();
  }

  Widget songResponseWidget(
      BuildContext context, PlaySongProvider playSongProvider) {
    var w = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        /*if (playSongProvider.isPlaying)
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Stack(
                  children: [
                    // Apply rotations to the blobs
                    Blob(
                      color: Color(0xff0092ff),
                      scale: 0.85,
                      rotation: _animationController.value * 2 * pi,
                    ),
                    Blob(
                      color: Color(0xff4ac7b7),
                      scale: 0.85,
                      rotation:
                      (_animationController.value * 2 * pi) - 30,
                    ),
                    Blob(
                      color: Color(0xffa4a6f6),
                      scale: 0.85,
                      rotation:
                      (_animationController.value * 2 * pi) - 45,
                    ),
                  ],
                );
              },
            ),
          ),*/
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Container(
            height: 50,
            width: w,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(25),
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainPlayer(data: UniVarProvider.data),
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(
                          playSongProvider.playingModSong.image.last.link ??
                              appImage),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          playSongProvider.playingModSong?.name ?? "SongName",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Text(
                          "${playSongProvider.playingModSong?.primaryArtists ?? "ArtistName"}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (playSongProvider.playIndex > 0) {
                            playSongProvider.playSong(
                              UniVarProvider.data[
                              playSongProvider.playIndex - 1],
                              playSongProvider.playIndex - 1,
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('No previous song available'),
                              ),
                            );
                          }
                        },
                        icon: const Icon(
                          Icons.skip_previous_rounded,
                          size: 40,
                        ),
                      ),
                      CircleAvatar(
                        radius: 20,
                        child: Transform.scale(
                          scale: 1.5,
                          child: IconButton(
                            onPressed: () {
                              if (playSongProvider.isPlaying) {
                                playSongProvider.audioPlayer.pause();
                                playSongProvider.isPlaying = false;
                                _animationController.stop(); // Stop animation
                              } else {
                                playSongProvider.audioPlayer.play();
                                playSongProvider.isPlaying = true;
                                _animationController.repeat(); // Start animation
                              }
                            },
                            icon: playSongProvider.isPlaying
                                ? const Icon(Icons.pause)
                                : const Icon(Icons.play_arrow_rounded),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (playSongProvider.playIndex <
                              UniVarProvider.data.length - 1) {
                            playSongProvider.playSong(
                              UniVarProvider.data[
                              playSongProvider.playIndex + 1],
                              playSongProvider.playIndex + 1,
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('No next song available'),
                              ),
                            );
                          }
                        },
                        icon: const Icon(
                          Icons.skip_next_rounded,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}



class PlayButton extends StatefulWidget {
  final bool initialIsPlaying;
  final Icon playIcon;
  final Icon pauseIcon;
  final VoidCallback onPressed;

  PlayButton({
    required this.onPressed,
    this.initialIsPlaying = false,
    this.playIcon = const Icon(Icons.play_arrow),
    this.pauseIcon = const Icon(Icons.pause),
  }) : assert(onPressed != null);

  @override
  _PlayButtonState createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> with TickerProviderStateMixin {
  static const _kToggleDuration = Duration(milliseconds: 300);
  static const _kRotationDuration = Duration(seconds: 5);

  bool isPlaying = false;

  // rotation and scale animations
  late AnimationController _rotationController;
  late AnimationController _scaleController;
  double _rotation = 0;
  double _scale = 0.85;

  bool get _showWaves => !_scaleController.isDismissed;

  void _updateRotation() => _rotation = _rotationController.value * 2 * pi;
  void _updateScale() => _scale = (_scaleController.value * 0.2) + 0.85;

  @override
  void initState() {
    isPlaying = widget.initialIsPlaying;
    _rotationController =
    AnimationController(vsync: this, duration: _kRotationDuration)
      ..addListener(() => setState(_updateRotation))
      ..repeat();

    _scaleController =
    AnimationController(vsync: this, duration: _kToggleDuration)
      ..addListener(() => setState(_updateScale));

    super.initState();
  }

  void _onToggle() {
    setState(() => isPlaying = !isPlaying);

    if (_scaleController.isCompleted) {
      _scaleController.reverse();
    } else {
      _scaleController.forward();
    }

    widget.onPressed();
  }

  Widget _buildIcon(bool isPlaying) {
    return SizedBox.expand(
      key: ValueKey<bool>(isPlaying),
      child: IconButton(
        icon: isPlaying ? widget.pauseIcon : widget.playIcon,
        onPressed: _onToggle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: 48, minHeight: 48),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (_showWaves) ...[
            Blob(color: Color(0xff0092ff), scale: _scale, rotation: _rotation),
            Blob(color: Color(0xff4ac7b7), scale: _scale, rotation: _rotation * 2 - 30),
            Blob(color: Color(0xffa4a6f6), scale: _scale, rotation: _rotation * 3 - 45),
          ],
          Container(
            constraints: BoxConstraints.expand(),
            child: AnimatedSwitcher(
              child: _buildIcon(isPlaying),
              duration: _kToggleDuration,
            ),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rotationController.dispose();
    super.dispose();
  }
}

class Blob extends StatelessWidget {
  final double rotation;
  final double scale;
  final Color? color;

  const Blob({this.color, this.rotation = 0, this.scale = 1});

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: Transform.rotate(
        angle: rotation,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(150),
              topRight: Radius.circular(240),
              bottomLeft: Radius.circular(220),
              bottomRight: Radius.circular(180),
            ),
          ),
        ),
      ),
    );
  }
}