import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:provider/provider.dart';

import '../../providers/playSong/playSongProvider.dart';
import '../../providers/playSong/universalVariableProvider.dart';
import '../../providers/playlist_provider.dart';
import '../../widgets/global_widget/floating_player.dart';
import '../../widgets/popup/song_detail_popup.dart';
import '../../widgets/tile/songTile.dart';

class PlayListDetail extends StatelessWidget {
  final String playlistId;

  const PlayListDetail({super.key, required this.playlistId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PlaylistProvider()..getPlaylistDetails(playlistId),
      child: Scaffold(
        body: Consumer<PlaylistProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return _buildLoadingState();
            }
            if (provider.playlistDetails == null) {
              return _buildErrorState();
            }
            return _PlaylistDetailBody(provider: provider);
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
      ),
    );
  }

  Widget _buildErrorState() {
    return const Center(
      child: Text(
        'No playlist data available',
        style: TextStyle(
          color: Colors.deepPurple,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _PlaylistDetailBody extends StatelessWidget {
  final PlaylistProvider provider;

  const _PlaylistDetailBody({required this.provider});

  @override
  Widget build(BuildContext context) {
    final playSongProvider = Provider.of<PlaySongProvider>(context);
    final playlistDetails = provider.playlistDetails!;

    return FloatingPlayerBody(
      body: Scaffold(
        body: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.network(
                playlistDetails.image!,
                fit: BoxFit.cover,
                color: Colors.black45,
                colorBlendMode: BlendMode.darken,
              ),
            ),
        
            // Main Content
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back Button and Playlist Info
                    _buildTopSection(context, playlistDetails),
                
                    // Playlist Action Buttons
                    _buildActionButtons(context),
                
                    // Songs List
                    _buildSongsList(context, playSongProvider),
                
                    // Recommended Sections
                    _buildRecommendedSections(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopSection(BuildContext context, var playlistDetails) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back Button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),

          SizedBox(height: 16.h),

          // Playlist Title and Details
          Text(
            HtmlUnescape().convert(playlistDetails.name.toString()),
            style: TextStyle(
              color: Colors.white,
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  blurRadius: 10.0,
                  color: Colors.black.withOpacity(0.5),
                  offset: const Offset(2, 2),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            '${playlistDetails.songCount} Songs • ${playlistDetails.fanCount} Fans',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          // Play All Button
          ElevatedButton.icon(
            onPressed: () {
              // Implement play all functionality
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            icon: const Icon(Icons.play_arrow_rounded, color: Colors.white),
            label: const Text(
              'Play All',
              style: TextStyle(color: Colors.white),
            ),
          ),

          SizedBox(width: 12.w),

          // Shuffle Button
          ElevatedButton.icon(
            onPressed: () {
              // Implement shuffle functionality
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white24,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            icon: const Icon(Icons.shuffle_rounded, color: Colors.white),
            label: const Text(
              'Shuffle',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSongsList(BuildContext context, PlaySongProvider playSongProvider) {
    return provider.playlistSong.isEmpty
        ? const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
      ),
    )
        : ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      itemCount: provider.playlistSong.length,
      separatorBuilder: (context, index) => SizedBox(height: 8.h),
      itemBuilder: (context, index) {
        final song = provider.playlistSong[index];
        return SongTile(song: song, onTap: () {
          playSongProvider.playSong(song, index);
          UniVarProvider.data = provider.playlistSong;
        },);
      },
    );
  }

  Widget _buildRecommendedSections(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Recommended Playlists
        if (provider.recoPlaylist.isNotEmpty)
          _buildHorizontalSection(
            title: 'Recommended Playlists',
            items: provider.recoPlaylist,
            itemBuilder: (playlist) => _buildRecommendedCard(
              context,
              title: playlist.name,
              imageUrl: playlist.image,
              onTap: () {
                // Navigate to playlist details
              },
            ),
          ),

        // Trending Songs
        if (provider.trendingSong.isNotEmpty)
          _buildHorizontalSection(
            title: 'Trending Songs',
            items: provider.trendingSong,
            itemBuilder: (song) => _buildRecommendedCard(
              context,
              title: song.name,
              imageUrl: song.image!.last.link,
              onTap: () {
                // Play song or navigate to song details
              },
            ),
          ),
      ],
    );
  }

  Widget _buildHorizontalSection<T>({
    required String title,
    required List<T> items,
    required Widget Function(T) itemBuilder,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                  left: index == 0 ? 16.w : 8.w,
                  right: 8.w,
                ),
                child: itemBuilder(items[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendedCard(
      BuildContext context, {
        required String? title,
        required String? imageUrl,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        decoration: BoxDecoration(
          color: Colors.white12,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(15),
              ),
              child: Image.network(
                imageUrl ?? '',
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title ?? 'Unknown',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}