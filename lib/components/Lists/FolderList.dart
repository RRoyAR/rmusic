import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:rmusic/components/BasicSeperatedListView.dart';
import 'package:rmusic/components/SongList.dart';

class FolderList extends StatefulWidget
{
	@override
	State<StatefulWidget> createState() {
		return _FolderList();
	}
}

class _FolderList extends State<FolderList>
{
	final OnAudioQuery _onAudioQuery = OnAudioQuery();
	List<ListTile> ablumTiles = const [ListTile(title: Text("Loading..."),)];
	static const double ARTWORK_SIZE = 50;
	static String mainFolderPath = "/storage/emulated/0/Music/";

	_FolderList()
	{
		_onAudioQuery.queryAllPath().then((paths){
			if(paths.isNotEmpty)
			{
				setAblums(paths);
			}	
		});
	}

	setAblums(List<String> paths)
	{
		List<ListTile> loadedAblums = [];
		for(String currentPath in paths)
		{
			if(currentPath.indexOf(mainFolderPath) < 0)
			{
				continue;
			}

			String albumName = currentPath.substring(currentPath.lastIndexOf("/") + 1);
			loadedAblums.add(ListTile(
				leading: const Icon(Icons.queue_music_rounded, size: ARTWORK_SIZE, ),
				title: Text(albumName),
				// subtitle: Text("Artist: " + (currentAblum)),
				onTap: () => openSongsList(currentPath),
				key: Key(albumName),
			));
		}

		loadedAblums.sort((tile1, tile2)=> tile1.key.toString().compareTo(tile2.key.toString()));
		setState(() {
			ablumTiles = loadedAblums;
		});

		// setAlbumsWithArtwork(ablums);
	}
	
	openSongsList(folderPath) async
	{
		List<SongModel> songsInFolder = await _onAudioQuery.querySongs(path: folderPath);
		// List<SongModel> songsInAblum = await _onAudioQuery.queryAudiosFrom(AudiosFromType.ALBUM_ID, albumId);
		Navigator.pushNamed(context, SongList.routeName, arguments: songsInFolder);
	}

	@override
	Widget build(BuildContext context) {
		return BasicSeperatedListView(ablumTiles);
	}
}


