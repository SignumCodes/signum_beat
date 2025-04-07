import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:signum_beat/providers/saavan/feed_provider.dart';
import 'package:signum_beat/widgets/text_widget/normal_text.dart';
import '../../widgets/global_widget/floating_player.dart';
import '../search/search_screen.dart';
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
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor.withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).primaryColor.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  'Listen It',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 22.sp,
                    letterSpacing: 1.5,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            _buildAnimatedIconButton(
              context,
              icon: Icons.search_rounded,
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: Duration(milliseconds: 500),
                    pageBuilder: (context, animation, secondaryAnimation) => const SearchScreen(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: Offset(0.0, 1.0), // Start from bottom
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      );
                    },
                  ),
                );              },
            ),
            _buildAnimatedIconButton(
              context,
              icon: Icons.settings_rounded,
              onPressed: () {
                // TODO: Implement settings
              },
            ),
            SizedBox(width: 8.w),
          ],
        ),
        body: Consumer<FeedProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return _buildLoadingState(context);
            } else if (provider.module.newTrending == null ||
                provider.module.newTrending!.isEmpty) {
              return _buildEmptyState(context);
            } else {
              var newTrending = provider.module.newTrending;
              var artist = provider.recoArist;
              return Container(
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
                child: RefreshIndicator(
                  color: Theme.of(context).primaryColor,
                  backgroundColor: Colors.white,
                  onRefresh: () async {
                    // TODO: Implement refresh logic
                  },
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(top: 100.h, bottom: 20.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionWithHeader(
                          context,
                          'Top Trending',
                          child: newTrending!.isNotEmpty
                              ? NewTrending(newTrending: newTrending)
                              : const SizedBox(),
                        ),

                        _buildSectionWithHeader(
                          context,
                          'Recommended Artists',
                          child: artist.isNotEmpty
                              ? RecommendedArtist(artist: artist)
                              : const SizedBox(),
                        ),

                        _buildSectionWithHeader(
                          context,
                          'Top Charts',
                          child: provider.module.charts!.isNotEmpty
                              ? TopCharts(chart: provider.module.charts!)
                              : const SizedBox(),
                        ),

                        _buildSectionWithHeader(
                          context,
                          'New Release Albums',
                          child: provider.module.newAlbums!.isNotEmpty
                              ? NewAlbum(album: provider.module.newAlbums!)
                              : const SizedBox(),
                        ),

                        _buildSectionWithHeader(
                          context,
                          'Top Playlists',
                          child: provider.module.topPlaylists!.isNotEmpty
                              ? TopPlaylist(playlists: provider.module.topPlaylists!)
                              : const SizedBox(),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  // Animated icon button with hover effect
  Widget _buildAnimatedIconButton(
      BuildContext context, {
        required IconData icon,
        required VoidCallback onPressed,
      }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor.withOpacity(0.2),
            Theme.of(context).primaryColor.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          splashColor: Theme.of(context).primaryColor.withOpacity(0.1),
          highlightColor: Theme.of(context).primaryColor.withOpacity(0.2),
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Icon(
              icon,
              size: 24.sp,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
    );
  }

  // Section with enhanced header and content
  Widget _buildSectionWithHeader(BuildContext context, String title, {required Widget child}) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: _buildSectionHeader(context, title),
          ),
          SizedBox(height: 8.h),
          child,
        ],
      ),
    );
  }

  // Enhanced section header with a more modern design
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 6.w,
            height: 30.h,
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
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).primaryColor.withOpacity(0.2),
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            margin: EdgeInsets.only(right: 12.w),
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
          const Spacer(),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor.withOpacity(0.1),
                  Theme.of(context).primaryColor.withOpacity(0.2),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withOpacity(0.1),
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  // TODO: Implement view all functionality
                },
                borderRadius: BorderRadius.circular(16),
                splashColor: Theme.of(context).primaryColor.withOpacity(0.1),
                highlightColor: Theme.of(context).primaryColor.withOpacity(0.2),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'View All',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 10.sp,
                        color: Theme.of(context).primaryColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Loading state with animation
  Widget _buildLoadingState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 100.w,
            width: 100.w,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColor,
              ),
              strokeWidth: 6,
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'Loading your music...',
            style: TextStyle(
              fontSize: 16.sp,
              color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Empty state with animation
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120.w,
            height: 120.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).disabledColor.withOpacity(0.1),
            ),
            child: Icon(
              Icons.music_off_rounded,
              size: 80.sp,
              color: Theme.of(context).disabledColor.withOpacity(0.7),
            ),
          ),
          SizedBox(height: 24.h),
          NormalText(
            text: 'No music found',
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).disabledColor,
          ),
          SizedBox(height: 16.h),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 32.w),
            child: NormalText(
              text: 'Try refreshing or check your connection',
              fontSize: 16.sp,
              textAlign: TextAlign.center,
              color: Theme.of(context).disabledColor.withOpacity(0.7),
            ),
          ),
          SizedBox(height: 32.h),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement retry logic
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 3,
            ),
            child: Text(
              'Refresh',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}