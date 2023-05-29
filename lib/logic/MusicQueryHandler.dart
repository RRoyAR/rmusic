import 'package:on_audio_query/on_audio_query.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class MusicQueryHandler
{
	static final MusicQueryHandler _instance = MusicQueryHandler._internal();
	final OnAudioQuery _onAudioQuery = OnAudioQuery();
	

	factory MusicQueryHandler()
	{
		return _instance;
	}

	MusicQueryHandler._internal(); //Private constructor named _internal

	// List<AlbumModel> get Albums{
		
	// }

}
