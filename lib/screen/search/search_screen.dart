import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:signum_beat/screen/tileDetails/albumDetail.dart';
import 'package:signum_beat/screen/tileDetails/artist_detail.dart';
import 'package:signum_beat/screen/tileDetails/playlist_detail.dart';
import 'package:signum_beat/screen/tileDetails/song_detail.dart';
import 'package:signum_beat/utils/constants/const_var.dart';
import 'package:signum_beat/widgets/cards/playlistCard.dart';
import 'package:signum_beat/widgets/global_widget/floating_player.dart';
import 'package:signum_beat/widgets/text_widget/normal_text.dart';
import 'package:signum_beat/providers/playSong/playSongProvider.dart';
import 'package:signum_beat/providers/search_provider.dart';
import 'package:signum_beat/widgets/custom_card.dart';
import 'package:signum_beat/widgets/tile/custom_tile.dart';
import 'package:signum_beat/widgets/tile/songTile.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Setup animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();

    // Fetch top search once when the widget is initialized
    Future.microtask(() {
      Provider.of<SearchMusicProvider>(context, listen: false).getTopSearch();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final playSongProvider = Provider.of<PlaySongProvider>(context);
    final searchProvider = Provider.of<SearchMusicProvider>(context, listen: true);

    return FloatingPlayerBody(
      body: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: _buildSearchField(searchProvider),
          centerTitle: true,
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).scaffoldBackgroundColor,
                Theme.of(context).primaryColor.withOpacity(0.05),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: searchProvider.autoComplete.isEmpty ||
                searchProvider.searchTextController.text.isEmpty
                ? searchProvider.topSearchResponse.isNotEmpty
                ? _buildTopSearch(searchProvider, playSongProvider)
                : _buildEmptyState()
                : _buildSearchResult(searchProvider, playSongProvider),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField(SearchMusicProvider searchProvider) {
    return Container(
      height: 50.h,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: searchProvider.searchTextController,
        onChanged: (value) {
          if (value.isNotEmpty) {
            searchProvider.getSearchModule(value);
          }
        },
        onSubmitted: (value) {
          searchProvider.getSearchModule(value);
        },
        style: TextStyle(
          fontSize: 16.sp,
          color: Theme.of(context).textTheme.bodyLarge?.color,
        ),
        decoration: InputDecoration(
          filled: false,
          border: InputBorder.none,
          hintText: "Search for music...",
          hintStyle: TextStyle(
            color: Theme.of(context).hintColor,
            fontSize: 16.sp,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: Theme.of(context).primaryColor,
            size: 22.sp,
          ),
          suffixIcon: searchProvider.searchTextController.text.isNotEmpty
              ? IconButton(
            icon: Icon(
              Icons.clear_rounded,
              color: Theme.of(context).hintColor,
              size: 20.sp,
            ),
            onPressed: () {
              searchProvider.searchTextController.clear();
              setState(() {});
            },
          )
              : null,
          contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        ),
        textInputAction: TextInputAction.search,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120.w,
            height: 120.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).primaryColor.withOpacity(0.1),
            ),
            child: Icon(
              Icons.music_note_rounded,
              size: 60.sp,
              color: Theme.of(context).primaryColor.withOpacity(0.7),
            ),
          ),
          SizedBox(height: 24.h),
          NormalText(
            text: 'Discover Your Rhythm',
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(height: 16.h),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 40.w),
            child: NormalText(
              text: 'Search for artists, songs, albums or playlists',
              fontSize: 16.sp,
              textAlign: TextAlign.center,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopSearch(SearchMusicProvider searchProvider, PlaySongProvider playSongProvider) {
    return Padding(
      padding: EdgeInsets.only(top: 16.h),
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: EdgeInsets.only(top: 70.h, left: 16.w, right: 16.w, bottom: 16.h),
            sliver: SliverToBoxAdapter(
              child: _buildSectionHeader(context, 'Popular Searches'),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.85,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 16.h,
              ),
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  var item = searchProvider.topSearchResponse[index];
                  return GestureDetector(
                    onTap: () async {
                      if (item.type == 'album') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AlbumDetails(albumId: item.id)),
                        );
                      }
                      if (item.type == 'song') {
                        var song = await searchProvider.jio.songs.detailsById(item.id);
                        playSongProvider.playSong(song, 0);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).shadowColor.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16.r),
                              topRight: Radius.circular(16.r),
                            ),
                            child: Container(
                              height: 130.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor.withOpacity(0.1),
                              ),
                              child: Image.network(
                                item.image,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                    child: Icon(
                                      Icons.image_not_supported_rounded,
                                      size: 40.sp,
                                      color: Theme.of(context).disabledColor,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                NormalText(
                                  text: item.title,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4.h),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(4.r),
                                      ),
                                      child: NormalText(
                                        text: item.type.toUpperCase(),
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: searchProvider.topSearchResponse.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResult(SearchMusicProvider searchProvider, PlaySongProvider playSongProvider) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(top: 100.h, bottom: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionWithContent(
            context,
            'Top Result',
            child: Container(
              height: 200.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: searchProvider.autoComplete.first.topQuery.results.length,
                itemBuilder: (context, index) {
                  var topResult = searchProvider.autoComplete.first.topQuery.results;
                  var data = topResult[index];

                  return Container(
                    margin: EdgeInsets.only(right: 16.w),
                    width: 150.w,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).shadowColor.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16.r),
                      onTap: () async {
                        if (data.type == 'song') {
                          var song = await searchProvider.jio.songs.detailsById(data.id);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SongDetails(song: song)),
                          );
                        } else if (data.type == 'artist') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ArtistDetail(artistId: data.id)),
                          );
                        }
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16.r),
                              topRight: Radius.circular(16.r),
                            ),
                            child: Container(
                              height: 150.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor.withOpacity(0.1),
                              ),
                              child: Image.network(
                                data.image!.last.link.toString(),
                                fit: data.type == 'artist' ? BoxFit.cover : BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                    child: Icon(
                                      Icons.image_not_supported_rounded,
                                      size: 40.sp,
                                      color: Theme.of(context).disabledColor,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.w),
                            child: NormalText(
                              text: data.title,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Top Songs Section
          if (searchProvider.autoCompleteSongs.isNotEmpty)
            _buildSectionWithContent(
              context,
              'Top Songs',
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: searchProvider.autoCompleteSongs.length > 5
                    ? 5
                    : searchProvider.autoCompleteSongs.length,
                itemBuilder: (context, index) {
                  var song = searchProvider.autoCompleteSongs[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 10.h),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).shadowColor.withOpacity(0.05),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: SongTile(
                      song: song,
                      onTap: () {
                        playSongProvider.playSong(song, 0);
                      },
                    ),
                  );
                },
              ),
            ),

          // Top Albums Section
          _buildSectionWithContent(
            context,
            'Top Albums',
            child: Container(
              height: 180.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: searchProvider.autoComplete.first.albums.results.length,
                itemBuilder: (context, index) {
                  var album = searchProvider.autoComplete.first.albums.results[index];
                  return Container(
                    margin: EdgeInsets.only(right: 16.w),
                    width: 150.w,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).shadowColor.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16.r),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AlbumDetails(albumId: album.id)),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16.r),
                              topRight: Radius.circular(16.r),
                            ),
                            child: Container(
                              height: 120.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor.withOpacity(0.1),
                              ),
                              child: Image.network(
                                album.image!.last.link.toString().startsWith('http')
                                    ? album.image!.last.link.toString()
                                    : appImage,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                    child: Icon(
                                      Icons.album_rounded,
                                      size: 40.sp,
                                      color: Theme.of(context).disabledColor,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                NormalText(
                                  text: album.title.toString(),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4.h),
                                NormalText(
                                  text: album.artist.toString(),
                                  fontSize: 12.sp,
                                  color: Theme.of(context).textTheme.bodySmall?.color,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Top Playlists Section
          _buildSectionWithContent(
            context,
            'Top Playlists',
            child: Container(
              height: 180.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: searchProvider.autoCompletePlaylist.length,
                itemBuilder: (context, index) {
                  var playlist = searchProvider.autoCompletePlaylist[index];
                  return Container(
                    margin: EdgeInsets.only(right: 16.w),
                    width: 150.w,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).shadowColor.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16.r),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PlayListDetail(playlistId: playlist.id!)),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16.r),
                              topRight: Radius.circular(16.r),
                            ),
                            child: Container(
                              height: 120.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor.withOpacity(0.1),
                              ),
                              child: Image.network(
                                playlist.image.toString().startsWith('http')
                                    ? playlist.image.toString()
                                    : appImage,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                    child: Icon(
                                      Icons.queue_music_rounded,
                                      size: 40.sp,
                                      color: Theme.of(context).disabledColor,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.w),
                            child: NormalText(
                              text: playlist.name.toString(),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Top Artists Section
          _buildSectionWithContent(
            context,
            'Top Artists',
            child: Container(
              height: 160.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: searchProvider.autoComplete.first.artists.results.length,
                itemBuilder: (context, index) {
                  var artist = searchProvider.autoComplete.first.artists.results[index];
                  return Container(
                    margin: EdgeInsets.only(right: 16.w),
                    width: 120.w,
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ArtistDetail(artistId: artist.id)),
                            );
                          },
                          borderRadius: BorderRadius.circular(60.r),
                          child: Container(
                            height: 120.w,
                            width: 120.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).primaryColor.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(60.r),
                              child: Image.network(
                                artist.image!.last.link.toString(),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                                    child: Center(
                                      child: Icon(
                                        Icons.person_rounded,
                                        size: 50.sp,
                                        color: Theme.of(context).disabledColor,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        NormalText(
                          text: artist.title,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h, left: 4.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 4.w,
            height: 24.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withOpacity(0.5),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            margin: EdgeInsets.only(right: 8.w),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
              foreground: Paint()
                ..shader = LinearGradient(
                  colors: [
                    Theme.of(context).textTheme.headlineSmall?.color ?? Colors.black,
                    Theme.of(context).primaryColor,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(Rect.fromLTWH(0.0, 0.0, 200.w, 70.h)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionWithContent(BuildContext context, String title, {required Widget child}) {
    return Container(
      margin: EdgeInsets.only(bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: _buildSectionHeader(context, title),
          ),
          child,
        ],
      ),
    );
  }
}