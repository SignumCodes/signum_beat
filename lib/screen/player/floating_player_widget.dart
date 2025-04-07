import 'dart:math';
import 'dart:ui';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:signum_beat/screen/player/mainPlayer.dart';
import 'package:signum_beat/utils/constants/color_const.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';

import '../../api/jiosaavn/models/song.dart';
import '../../providers/playSong/playSongProvider.dart';
import '../../providers/playSong/universalVariableProvider.dart';
import '../../utils/constants/const_var.dart';

class FloatingPlayer extends StatefulWidget {
  const FloatingPlayer({super.key});

  @override
  _FloatingPlayerState createState() => _FloatingPlayerState();
}

class _FloatingPlayerState extends State<FloatingPlayer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.repeat(reverse: true);
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
    var theme = Theme.of(context);

    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 5.w, vertical: 0),
      child: Container(
        width: w,
        height: 50.h,
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(
            color: theme.primaryColor.withOpacity(0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: theme.primaryColor.withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 5,
              offset: const Offset(0, 5),
            ),
          ],
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
              AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Hero(
                      tag: 'albumArt',
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: theme.primaryColor.withOpacity(0.3),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: theme.primaryColor.withOpacity(0.2),
                              blurRadius: 15,
                              spreadRadius: 3,
                            )
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 28,
                          backgroundImage: NetworkImage(
                            playSongProvider.playingModSong.image.last.link ?? appImage,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        playSongProvider.playingModSong?.name ?? "SongName",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                          color: theme.textTheme.bodyLarge?.color,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      FadeInLeft(
                        delay: const Duration(milliseconds: 200),
                        duration: const Duration(milliseconds: 500),
                        child: Text(
                          "${playSongProvider.playingModSong?.primaryArtists ?? "ArtistName"}",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.textTheme.bodyLarge?.color?.withOpacity(0.7),
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ZoomIn(
                    duration: const Duration(milliseconds: 300),
                    child: IconButton(
                      onPressed: () {
                        if (playSongProvider.playIndex > 0) {
                          playSongProvider.playSong(
                            UniVarProvider.data[playSongProvider.playIndex - 1],
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
                      icon: Icon(
                        Icons.skip_previous_rounded,
                        size: 35,
                        color: theme.iconTheme.color?.withOpacity(0.7),
                      ),
                    ),
                  ),
                  Pulse(
                    duration: const Duration(milliseconds: 500),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            theme.primaryColor.withOpacity(0.8),
                            theme.primaryColor.withOpacity(0.5),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: theme.primaryColor.withOpacity(0.4),
                            blurRadius: 15,
                            spreadRadius: 3,
                            offset: const Offset(0, 5),
                          )
                        ],
                      ),
                      child: IconButton(
                        iconSize: 40,
                        onPressed: () {
                          if (playSongProvider.isPlaying) {
                            playSongProvider.audioPlayer.pause();
                            playSongProvider.isPlaying = false;
                            _animationController.stop();
                          } else {
                            playSongProvider.audioPlayer.play();
                            playSongProvider.isPlaying = true;
                            _animationController.repeat(reverse: true);
                          }
                        },
                        icon: playSongProvider.isPlaying
                            ? const Icon(Icons.pause, color: Colors.white)
                            : const Icon(Icons.play_arrow_rounded, color: Colors.white),
                      ),
                    ),
                  ),
                  ZoomIn(
                    duration: const Duration(milliseconds: 300),
                    child: IconButton(
                      onPressed: () {
                        if (playSongProvider.playIndex <
                            UniVarProvider.data.length - 1) {
                          playSongProvider.playSong(
                            UniVarProvider.data[playSongProvider.playIndex + 1],
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
                      icon: Icon(
                        Icons.skip_next_rounded,
                        size: 35,
                        color: theme.iconTheme.color?.withOpacity(0.7),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// class PlayButton extends StatefulWidget {
//   final bool initialIsPlaying;
//   final Icon playIcon;
//   final Icon pauseIcon;
//   final VoidCallback onPressed;
//
//   PlayButton({
//     required this.onPressed,
//     this.initialIsPlaying = false,
//     this.playIcon = const Icon(Icons.play_arrow),
//     this.pauseIcon = const Icon(Icons.pause),
//   }) : assert(onPressed != null);
//
//   @override
//   _PlayButtonState createState() => _PlayButtonState();
// }
//
// class _PlayButtonState extends State<PlayButton> with TickerProviderStateMixin {
//   static const _kToggleDuration = Duration(milliseconds: 300);
//   static const _kRotationDuration = Duration(seconds: 5);
//
//   bool isPlaying = false;
//
//   // rotation and scale animations
//   late AnimationController _rotationController;
//   late AnimationController _scaleController;
//   double _rotation = 0;
//   double _scale = 0.85;
//
//   bool get _showWaves => !_scaleController.isDismissed;
//
//   void _updateRotation() => _rotation = _rotationController.value * 2 * pi;
//   void _updateScale() => _scale = (_scaleController.value * 0.2) + 0.85;
//
//   @override
//   void initState() {
//     isPlaying = widget.initialIsPlaying;
//     _rotationController =
//     AnimationController(vsync: this, duration: _kRotationDuration)
//       ..addListener(() => setState(_updateRotation))
//       ..repeat();
//
//     _scaleController =
//     AnimationController(vsync: this, duration: _kToggleDuration)
//       ..addListener(() => setState(_updateScale));
//
//     super.initState();
//   }
//
//   void _onToggle() {
//     setState(() => isPlaying = !isPlaying);
//
//     if (_scaleController.isCompleted) {
//       _scaleController.reverse();
//     } else {
//       _scaleController.forward();
//     }
//
//     widget.onPressed();
//   }
//
//   Widget _buildIcon(bool isPlaying) {
//     return SizedBox.expand(
//       key: ValueKey<bool>(isPlaying),
//       child: IconButton(
//         icon: isPlaying ? widget.pauseIcon : widget.playIcon,
//         onPressed: _onToggle,
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ConstrainedBox(
//       constraints: BoxConstraints(minWidth: 48, minHeight: 48),
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           if (_showWaves) ...[
//             Blob(color: Color(0xff0092ff), scale: _scale, rotation: _rotation),
//             Blob(color: Color(0xff4ac7b7), scale: _scale, rotation: _rotation * 2 - 30),
//             Blob(color: Color(0xffa4a6f6), scale: _scale, rotation: _rotation * 3 - 45),
//           ],
//           Container(
//             constraints: BoxConstraints.expand(),
//             child: AnimatedSwitcher(
//               child: _buildIcon(isPlaying),
//               duration: _kToggleDuration,
//             ),
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: Colors.white,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _scaleController.dispose();
//     _rotationController.dispose();
//     super.dispose();
//   }
// }
//
// class Blob extends StatelessWidget {
//   final double rotation;
//   final double scale;
//   final Color? color;
//
//   const Blob({this.color, this.rotation = 0, this.scale = 1});
//
//   @override
//   Widget build(BuildContext context) {
//     return Transform.scale(
//       scale: scale,
//       child: Transform.rotate(
//         angle: rotation,
//         child: Container(
//           decoration: BoxDecoration(
//             color: color,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(150),
//               topRight: Radius.circular(240),
//               bottomLeft: Radius.circular(220),
//               bottomRight: Radius.circular(180),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }