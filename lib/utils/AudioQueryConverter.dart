

import 'package:audio_service/audio_service.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AudioQueryConverter
{
	static MediaItem songModelToMediaItem(SongModel song)
	{
		return MediaItem(
			id: song.data, 
			title: song.title,
			artist: song.artist ?? "",
			duration: Duration(milliseconds: song.duration ?? 0),
			album: song.albumId.toString()
		);
	}
}
