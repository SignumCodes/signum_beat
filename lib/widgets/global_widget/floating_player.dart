import 'package:signum_beat/utils/constants/color_const.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import '../../providers/playSong/playSongProvider.dart';
import '../fab_position.dart';
import '../../screen/player/floating_player_widget.dart';

class FloatingPlayerBody extends StatelessWidget {
  final Widget? body;

  const FloatingPlayerBody({super.key, this.body});

  @override
  Widget build(BuildContext context) {
    final playSongProvider = Provider.of<PlaySongProvider>(context);
    return Scaffold(
        backgroundColor:  Theme.of(context).scaffoldBackgroundColor,
        body: body,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: StreamBuilder<ProcessingState>(
          stream: playSongProvider.audioPlayer.processingStateStream,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data == ProcessingState.ready) {
              return const FloatingPlayer();
            } else {
              return Container(); // Return an empty sized box if processing state is not ready
            }
          },
        ));
  }
}
