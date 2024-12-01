import 'package:dio/dio.dart';
import '../client.dart';
import '../collection/endpoints.dart';
import '../models/lyrics.dart';
import '../utils/link.dart';

class LyricsEndpoint extends BaseClient {
  LyricsEndpoint([super.options]);

  Future<LyricsResponse> get(String songId) async {
    final response = await request(
      call: endpoints.lyrics,
      isAPIv4: true,
      queryParameters: {"lyrics_id": songId},
    );

    final lyricReq = LyricsRequest.fromJson(response);

    if (lyricReq.lyrics == null) {
      throw DioException(
        type: DioExceptionType.badResponse,
        error: "Lyrics not found for this song",
        requestOptions: RequestOptions(
          baseUrl: options?.baseUrl,
          queryParameters: options?.queryParameters,
          path: endpoints.lyrics,
        ),
      );
    }

    return LyricsResponse(
      copyright: lyricReq.lyricsCopyRight,
      snippet: lyricReq.snippet,
      lyrics: lyricReq.lyrics == null ? null : sanitizeLyrics(lyricReq.lyrics!),
    );
  }
}
