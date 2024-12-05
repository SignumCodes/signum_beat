import 'package:signum_beat/providers/artist_provider.dart';
import 'package:signum_beat/providers/auth/auth_provider.dart';
import 'package:signum_beat/providers/download/download_provider.dart';
import 'package:signum_beat/providers/home/navigation_provider.dart';
import 'package:signum_beat/providers/playSong/playSongProvider.dart';
import 'package:signum_beat/providers/playlist_provider.dart';
import 'package:signum_beat/providers/search_provider.dart';
import 'package:signum_beat/providers/song_detail_provider.dart';
import 'package:signum_beat/providers/state_provider/app_bar_state_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:signum_beat/screen/artist/artist_more_detail.dart';

import 'firebase_options.dart';
import 'providers/albumProvider.dart';
import 'providers/counter_provider.dart';
import 'providers/permistion_provider.dart';
import 'providers/playSong/animation_provider.dart';
import 'providers/playSong/universalVariableProvider.dart';
import 'providers/saavan/feed_provider.dart';
import 'screen/auth/auth_state.dart';
import 'screen/home/navgation_page.dart';
import 'utils/constants/color_const.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => PermissionProvider()),
      ChangeNotifierProvider(create: (_) => CounterProvider()),
      ChangeNotifierProvider(create: (_) => NavigationProvider()),
      ChangeNotifierProvider(create: (_)=>AuthenticationProvider()),
      ChangeNotifierProvider(create: (_) => FeedProvider()..loadModules()),
      ChangeNotifierProvider(create: (_) => UniVarProvider()),
      ChangeNotifierProvider(create: (_) => PlaySongProvider()),
      ChangeNotifierProvider(create: (_) => AlbumProvider()),
      ChangeNotifierProvider(create: (_) => AppBarState()),
      ChangeNotifierProvider(create: (_) => SongProvider()),
      ChangeNotifierProvider(create: (_) => DownloadProvider()),
      ChangeNotifierProvider(create: (_) => PlaylistProvider()),
      ChangeNotifierProvider(create: (_) => ArtistProvider()),
      ChangeNotifierProvider(create: (_) => ArtistMoreDetailProvider()),
      ChangeNotifierProvider(create: (_) => SearchMusicProvider()),

    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColor.mainColor,
          ),
        ),
        darkTheme: ThemeData.dark(),
        // home: AuthState(),
        home: NavigationPage(),
      ),
    );
  }
}
