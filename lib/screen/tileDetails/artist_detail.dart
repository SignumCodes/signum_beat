import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:provider/provider.dart';

import '../../providers/artist_provider.dart';
import '../../providers/albumProvider.dart';
import '../../providers/playSong/playSongProvider.dart';
import '../../providers/playSong/universalVariableProvider.dart';
import '../../providers/playlist_provider.dart';
import '../../providers/state_provider/app_bar_state_provider.dart';
import '../../utils/constants/const_var.dart';
import '../../widgets/cards/playlistCard.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/global_widget/floating_player.dart';
import '../../widgets/shimmer/custom_card_shimmer.dart';
import '../../widgets/shimmer/title_shimmer.dart';
import '../../widgets/text_widget/normal_text.dart';
import '../../widgets/tile/custom_tile.dart';
import '../../widgets/tile/songTile.dart';
import '../artist/artist_more_detail.dart';
import '../tileDetails/playlist_detail.dart';
import 'albumDetail.dart';

class ArtistDetail extends StatelessWidget {
  final String artistId;

  const ArtistDetail({
    super.key,
    required this.artistId,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingPlayerBody(
      body: ChangeNotifierProvider(
        create: (_) => ArtistProvider()..getArtistDetails(artistId),
        child: Consumer<ArtistProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            if (provider.artistDetail == null) {
              return const Scaffold(
                body: Center(
                  child: Text('No data available'),
                ),
              );
            }

            return Scaffold(
              body: Stack(
                children: [
                  // Background Image
                  Positioned.fill(
                    child: Image.network(
                      provider.artistDetail['image'],
                      fit: BoxFit.cover,
                      colorBlendMode: BlendMode.darken,
                      color: Colors.black54,
                    ),
                  ),

                  // Content
                  SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // App Bar
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.black38,
                                child: IconButton(
                                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ),
                              Text(
                                HtmlUnescape().convert(provider.artistDetail['name']),
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 40), // To center the title
                            ],
                          ),
                        ),

                        // Artist Info
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                HtmlUnescape().convert(provider.artistDetail['type']),
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.white70,
                                ),
                              ),
                              Text(
                                '${provider.artistDetail['follower_count']} Followers',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Scrollable Content
                        Expanded(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Popular Songs Section
                                  _buildSectionTitle(context, 'Popular Songs'),
                                  provider.topSongs.isNotEmpty
                                      ? Column(
                                    children: provider.topSongs.take(6).map((song) {
                                      return SongTile(
                                        song: song,
                                        onTap: () {
                                          Provider.of<PlaySongProvider>(context, listen: false)
                                              .playSong(song, provider.topSongs.indexOf(song));
                                          UniVarProvider.data = provider.topSongs;
                                        },
                                      );
                                    }).toList(),
                                  )
                                      : CustomCardShimmer(size: 140.h),

                                  // Popular Release
                                  if (provider.topAlbums.isNotEmpty) ...[
                                    _buildSectionTitle(context, 'Popular Release'),
                                    ListView.builder(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: provider.topAlbums.length >= 4 ? 4 : provider.topAlbums.length,
                                      itemBuilder: (context, index) {
                                        var album = provider.topAlbums[index];
                                        return CustomTile(
                                          image: album['image'],
                                          title: album['title'],
                                          subTitle: album['subtitle'],
                                          type: album['type'],
                                          artists: album['more_info']['music'],
                                          count: album['more_info']['song_count'],
                                          year: album['year'],
                                          onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ChangeNotifierProvider(
                                                create: (_) => AlbumProvider(id: album['id']),
                                                child: AlbumDetails(albumId: album['id']),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ] else
                                    CustomCardShimmer(size: 100.h),

                                  // Only By Artist
                                  if (provider.singleAlbums.isNotEmpty) ...[
                                    _buildSectionTitle(context, 'Only By ${provider.artistDetail['name']}'),
                                    SizedBox(
                                      height: 140.h,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: provider.singleAlbums.length,
                                        itemBuilder: (context, index) {
                                          var album = provider.singleAlbums[index];
                                          return CustomCard(
                                            size: 150.w,
                                            leading: Image(
                                              image: NetworkImage(album['image']),
                                            ),
                                            title: NormalText(
                                              text: album['title'],
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ChangeNotifierProvider(
                                                  create: (_) => AlbumProvider(id: album['id']),
                                                  child: AlbumDetails(albumId: album['id']),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ] else
                                    CustomCardShimmer(size: 100.h),

                                  // Dedicated Playlist
                                  if (provider.dedicatedArtistPlaylists.isNotEmpty) ...[
                                    _buildSectionTitle(context, 'Dedicated Playlist'),
                                    SizedBox(
                                      height: 140.h,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: provider.dedicatedArtistPlaylists.length,
                                        itemBuilder: (context, index) {
                                          var playlist = provider.dedicatedArtistPlaylists[index];
                                          return PlaylistCard(
                                            title: NormalText(
                                              text: playlist.name.toString(),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            leading: Image(
                                              image: NetworkImage(playlist.image),
                                            ),
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.zero,
                                            ),
                                            onTap: () {
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => ChangeNotifierProvider(
                                                    create: (_) => PlaylistProvider(),
                                                    child: PlayListDetail(
                                                      playlistId: playlist.id!,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ] else
                                    CustomCardShimmer(size: 140.h),

                                  // Featured Playlist
                                  if (provider.featuredArtistPlaylist.isNotEmpty) ...[
                                    _buildSectionTitle(context, 'Featured Playlist'),
                                    SizedBox(
                                      height: 140.h,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        itemCount: provider.featuredArtistPlaylist.length,
                                        itemBuilder: (c, i) {
                                          var playlist = provider.featuredArtistPlaylist[i];
                                          return PlaylistCard(
                                            size: 180,
                                            leading: Image(
                                              image: NetworkImage(playlist['image']),
                                            ),
                                            title: NormalText(
                                              text: playlist['title'],
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            onTap: () => Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ChangeNotifierProvider(
                                                  create: (_) => PlaylistProvider(),
                                                  child: PlayListDetail(
                                                    playlistId: playlist['id']!,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ] else
                                    CustomCardShimmer(size: 100.h),

                                  // Latest Release
                                  if (provider.latestReleaseAlbum.isNotEmpty) ...[
                                    _buildSectionTitle(context, 'Popular Release'),
                                    ListView.builder(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: provider.latestReleaseAlbum.length,
                                      itemBuilder: (context, index) {
                                        var album = provider.latestReleaseAlbum[index];
                                        return CustomTile(
                                          image: album['image'],
                                          title: album['title'],
                                          subTitle: album['subtitle'],
                                          type: album['type'],
                                          artists: album['more_info']['music'] ?? provider.artistDetail['name'],
                                          count: album['more_info']['song_count'],
                                          year: album['year'],
                                          onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ChangeNotifierProvider(
                                                create: (_) => AlbumProvider(id: album['id']),
                                                child: AlbumDetails(albumId: album['id']),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ] else
                                    CustomCardShimmer(size: 100.h),

                                  // More Artist Button
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 20),
                                      child: ElevatedButton(
                                        onPressed: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ArtistMoreDetail(artistId: artistId),
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Theme.of(context).primaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                        ),
                                        child: Text(
                                          'More about ${provider.artistDetail['name']}',
                                          style: const TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 100),
                                ],
                              ),
                            ),
                          ),
                        ),
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

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}