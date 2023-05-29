import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'package:rmusic/logic/MusicQueryHandler.dart';

import 'package:path_provider/path_provider.dart';


void main() {
	testWidgets('Dir Test', (WidgetTester tester) async {
		

		OnAudioQuery _queryAudio = OnAudioQuery();
		List<AlbumModel> albums = await _queryAudio.queryAlbums();

		int counter = 0;
		int counter2 = 0;

		for(AlbumModel currentAlbum in albums)
		{
			counter++;
			List<SongModel> songsInAblum = await _queryAudio.queryAudiosFrom(AudiosFromType.ALBUM_ID, currentAlbum.id);
			for(SongModel currentSong in songsInAblum)
			{
				counter2++;
				print("song: ${currentSong.displayName} \nAlbum: ${currentAlbum.album}\n");
			}
		}

		print(albums.length);
		print("counter: $counter");
		print("counter2: $counter2");

		String musicFolderPath = "/storage/emulated/0/Music";
		Directory musicDir = Directory(musicFolderPath);
		for(FileSystemEntity currentDirectoryInMusic in musicDir.listSync(recursive: true, followLinks: false)) 
		{
			if (currentDirectoryInMusic is File) 
			{
				print(currentDirectoryInMusic.path);
			}
		}

	});
}
