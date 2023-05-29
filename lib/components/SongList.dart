
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:rmusic/components/AutoScrolledText.dart';
import 'package:rmusic/components/BasicSeperatedListView.dart';
import 'package:rmusic/components/MusicControls.dart';
import 'package:rmusic/logic/AudioPlayerHandler.dart';
import 'package:rmusic/utils/AudioQueryConverter.dart';

class SongList extends StatelessWidget
{
	static const routeName = "/songslist";
	List<ListTile> songs = [];
	// MusicPlayer musicPlayer = MusicPlayer();
	AudioPlayerHandler audioPlayerHandler = AudioPlayerHandler();

	extractFromArguments(List<SongModel> iSongs)
	{
		iSongs.sort((song1, song2){
			int num1 = song1.track ?? -1;
			int num2 = song2.track ?? -1;
			return num1 - num2;
		});

		int counter = 1;
		List<MediaItem> mediaItems = [];
		for(SongModel currentSong in iSongs)
		{
			songs.add(ListTile(
				leading: Text(_getSongLength(currentSong)),
				title: AutoScrolledText(currentSong.title, shouldScroll: false,),//Text(currentSong.title),
				onTap: () => OnSongSelected(iSongs, currentSong),
			));

			mediaItems.add(AudioQueryConverter.songModelToMediaItem(currentSong));
		}

		audioPlayerHandler.updateQueue(mediaItems);

		audioPlayerHandler.queueTitle.value = iSongs[0].album ?? "Album Uknown";
		// audioPlayerHandler.songList
		audioPlayerHandler.listId = iSongs[0].albumId.toString();
	}

	OnSongSelected(List<SongModel> queueSongsList, SongModel songSelected) async 
	{
		if(audioPlayerHandler.queue.value[0].id != queueSongsList[0].data)
		{
			List<MediaItem> mediaItems = [];
			for(SongModel currentSong in queueSongsList)
			{
				mediaItems.add(AudioQueryConverter.songModelToMediaItem(currentSong));
			}

			audioPlayerHandler.updateQueue(mediaItems);
		}

		audioPlayerHandler.playMediaItem(AudioQueryConverter.songModelToMediaItem(songSelected));
	}

	String _getSongLength(SongModel iSong)
	{
		const int milisecondsInSeconds = 1000;
		const int secondsInMinute = 60;

		num songSecondsLength = iSong.duration! / milisecondsInSeconds;
		String minutes = (songSecondsLength / secondsInMinute).floor().toString().padLeft(2, "0");
		String seconds = (songSecondsLength % secondsInMinute).floor().toString().padLeft(2, "0");

		return "$minutes:$seconds";
	}

	@override
	Widget build(BuildContext context) {
		final List<SongModel> iSongs = ModalRoute.of(context)!.settings.arguments as List<SongModel>;
		extractFromArguments(iSongs);
		
		SongModel firstSong = iSongs[0];
		return Scaffold(
			appBar: AppBar(
				title: Text(firstSong.album!),
			),
			body: BasicSeperatedListView(songs),
			bottomNavigationBar: MusicControls()
		);
	}
}
