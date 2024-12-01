import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import '../providers/home/navigation_provider.dart';
import '../providers/playSong/playSongProvider.dart';
import '../widgets/fab_position.dart';
import 'player/floating_player_widget.dart';

class FabFrame extends StatelessWidget {
  final Widget body;
  const FabFrame({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    final playSongProvider =Provider.of<PlaySongProvider>(context);
    return  Scaffold(
      body:body,
      floatingActionButton: StreamBuilder<ProcessingState>(
        stream: playSongProvider.audioPlayer.processingStateStream,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data == ProcessingState.ready) {
            return PositionedFloatingActionButton(
              top: 15,
              left: 15,
              floatingActionButton: FloatingPlayer(),
            );
          } else {
            return Container();// Return an empty sized box if processing state is not ready
          }
        },
      ),
    );
  }
}
