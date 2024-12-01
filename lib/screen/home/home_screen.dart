import 'package:signum_beat/providers/saavan/feed_provider.dart';
import 'package:signum_beat/widgets/text_widget/normal_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/global_widget/floating_player.dart';
import 'feedScreen/new_album.dart';
import 'feedScreen/reco_artist.dart';
import 'feedScreen/top_charts.dart';
import 'feedScreen/top_playlist.dart';
import 'feedScreen/trending.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingPlayerBody(
      body: Scaffold(
        appBar: AppBar(
          title: const Text('Listen It'), // Color of the bottom line
        ),
        body: Consumer<FeedProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (provider.module.newTrending == null ||
                provider.module.newTrending!.isEmpty) {

              return const Center(
                child: NormalText(
                  text: 'No data found',
                ),
              );
            } else {
              var newTrending = provider.module.newTrending;
              var artist = provider.recoArist;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const NormalText(
                      text: 'Top Trending',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    newTrending!.isNotEmpty?NewTrending(newTrending: newTrending,):const SizedBox(),
                    const NormalText(
                      text: 'Recomonded Artist',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    artist.isNotEmpty
                        ? RecommendedArtist(artist: artist,)
                        : const SizedBox(),
                    const NormalText(
                      text: 'Top Charts',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    provider.module.charts!.isNotEmpty?TopCharts(chart: provider.module.charts!,):const SizedBox(),
                    const NormalText(
                      text: 'New Release Album',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    provider.module.newAlbums!.isNotEmpty?NewAlbum(album: provider.module.newAlbums!,):const SizedBox(),
                    const NormalText(
                      text: 'Top Playlist',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    provider.module.topPlaylists!.isNotEmpty?TopPlaylist(playlists: provider.module.topPlaylists!,):const SizedBox(),
                  ],
                ),
              );
            }


          },
        ),
      ),
    );
  }
}
