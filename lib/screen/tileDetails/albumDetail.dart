import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:signum_beat/widgets/global_widget/floating_player.dart';

import '../../providers/albumProvider.dart';
import '../../providers/playSong/playSongProvider.dart';
import '../../providers/playSong/universalVariableProvider.dart';
import '../../widgets/tile/songTile.dart';

class AlbumDetails extends StatelessWidget {
  final String albumId;

  const AlbumDetails({Key? key, required this.albumId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingPlayerBody(
      body: ChangeNotifierProvider(
        create: (_) => AlbumProvider(id: albumId)..getAlbumData(),
        child: Consumer<AlbumProvider>(
          builder: (context, albumProvider, child) {
            if (albumProvider.isLoading) {
              return _buildLoadingScreen();
            }

            if (albumProvider.albumDetails == null) {
              return _buildErrorScreen();
            }

            final album = albumProvider.albumDetails!;
            final playSongProvider = Provider.of<PlaySongProvider>(context);

            return Scaffold(
              body: Stack(
                children: [
                  // Background Image with Gradient
                  _buildBackgroundImage(album.image!.last.link),

                  // Main Content
                  SafeArea(
                    child: CustomScrollView(
                      slivers: [
                        // App Bar
                        SliverAppBar(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          leading: _buildBackButton(context),
                          actions: [
                            IconButton(
                              icon: const Icon(Icons.more_vert,
                                  color: Colors.white),
                              onPressed: () {},
                            )
                          ],
                        ),

                        // Album Header
                        SliverToBoxAdapter(
                          child: _buildAlbumHeader(
                              album, context, playSongProvider),
                        ),

                        // Song List
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final song = album.songs[index];
                              return SongTile(
                                song: song,
                                onTap: () {
                                  playSongProvider.playSong(song, index);
                                  UniVarProvider.data = album.songs;
                                },
                                index: index,
                              );

                            },
                            childCount: album.songs.length,
                          ),
                        ),

                        _buildAdditionalSections(albumProvider),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple.shade700),
        ),
      ),
    );
  }

  Widget _buildErrorScreen() {
    return const Scaffold(
      body: Center(
        child: Text(
          'Unable to load album details',
          style: TextStyle(
            fontSize: 18,
            color: Colors.red,
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundImage(String imageUrl) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.7),
            BlendMode.darken,
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: const Icon(CupertinoIcons.back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildAlbumHeader(
      var album, BuildContext context, PlaySongProvider playSongProvider) {
    return Column(
      children: [
        // Album Image
        Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          width: 250,
          height: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 5,
                blurRadius: 20,
                offset: const Offset(0, 10),
              )
            ],
            image: DecorationImage(
              image: NetworkImage(album.image!.last.link),
              fit: BoxFit.cover,
            ),
          ),
        ),

        // Album Details
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Text(
                HtmlUnescape().convert(album.name),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                '${album.year} • ${album.primaryArtists}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),

        // Play Button
        Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple.shade600, Colors.deepPurple.shade800],
            ),
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              )
            ],
          ),
          child: MaterialButton(
            onPressed: () {
              playSongProvider.playSong(album.songs[0], 0);
              UniVarProvider.data = album.songs;
            },
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.play_arrow, color: Colors.white),
                SizedBox(width: 10),
                Text(
                  'Play Album',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStylishSongTile(
      var song, int index, PlaySongProvider playSongProvider, List songs) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: NetworkImage(song.image!.last.link),
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(
          song.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          song.primaryArtists,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.play_circle_outline, color: Colors.white),
          onPressed: () {},
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildAdditionalSections(AlbumProvider albumProvider) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Artists Section
            if (albumProvider.primArtist.isNotEmpty) ...[
              _buildSectionTitle('Artists'),
              _buildHorizontalCardList(
                items: albumProvider.primArtist,
                builder: (artist) => Container(
                  width: 100,
                  margin: const EdgeInsets.only(right: 10),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(artist.image!.last.link),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        artist.name,
                        style: const TextStyle(color: Colors.white),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),
              ),
            ],

            // Recommended Albums
            if (albumProvider.recoAlbum.isNotEmpty) ...[
              _buildSectionTitle('Recommended Albums'),
              _buildHorizontalCardList(
                items: albumProvider.recoAlbum,
                builder: (album) => _buildAlbumCard(album),
              ),
            ],

            // Albums from Same Year
            if (albumProvider.albumFromSameYear.isNotEmpty) ...[
              _buildSectionTitle('Albums From Same Year'),
              _buildHorizontalCardList(
                items: albumProvider.albumFromSameYear,
                builder: (album) => _buildAlbumCard(album),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildHorizontalCardList({
    required List items,
    required Widget Function(dynamic) builder,
  }) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: items.map((item) => builder(item)).toList(),
      ),
    );
  }

  Widget _buildAlbumCard(var album) {
    return GestureDetector(
      onTap: () {
        // Navigate to album details
      },
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: NetworkImage(album.image!.last.link),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              album.name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
