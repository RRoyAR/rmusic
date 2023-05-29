import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:rmusic/components/BasicSeperatedListView.dart';
import 'package:rmusic/components/SongList.dart';

class AlbumList extends StatefulWidget
{
	@override
	State<StatefulWidget> createState() {
		return _AlbumList();
	}
}

class _AlbumList extends State<AlbumList>
{
	final OnAudioQuery _onAudioQuery = OnAudioQuery();
	List<ListTile> ablumTiles = const [ListTile(title: Text("Loading..."),)];
	static const double ARTWORK_SIZE = 50;

	_AlbumList()
	{
		_onAudioQuery.queryAlbums(sortType: AlbumSortType.ALBUM).then((ablums){
			if(ablums.isNotEmpty)
			{
				setAblums(ablums);
			}	
		});
	}

	setAblums(ablums)
	{
		List<ListTile> loadedAblums = [];
		for(AlbumModel currentAblum in ablums)
		{
			loadedAblums.add(ListTile(
				leading: const Icon(Icons.queue_music_rounded, size: ARTWORK_SIZE, ),
				title: Text(currentAblum.album),
				subtitle: Text("Artist: " + (currentAblum.artist ?? "")),
				onTap: () => openSongsList(currentAblum.id),
				key: Key(currentAblum.album),
			));
		}

		loadedAblums.sort((tile1, tile2)=> tile1.key.toString().compareTo(tile2.key.toString()));
		setState(() {
			ablumTiles = loadedAblums;
		});

		setAlbumsWithArtwork(ablums);
	}

	setAlbumsWithArtwork(ablums) async
	{
		List<ListTile> loadedAblums = [];
		for(AlbumModel currentAblum in ablums)
		{
			var artwork = await _onAudioQuery.queryArtwork(currentAblum.id, ArtworkType.ALBUM);
			loadedAblums.add(ListTile(
				leading: artwork != null ? Image.memory(artwork, height: ARTWORK_SIZE, width: ARTWORK_SIZE, fit: BoxFit.cover,) : Icon(Icons.queue_music_rounded, size: ARTWORK_SIZE, ),
				title: Text(currentAblum.album),
				subtitle: Text("Artist: " + (currentAblum.artist ?? "")),
				onTap: () => openSongsList(currentAblum.id),
				key: Key(currentAblum.album),
			));
		}

		loadedAblums.sort((tile1, tile2)=> tile1.key.toString().compareTo(tile2.key.toString()));
		setState(() {
			ablumTiles = loadedAblums;
		});
	}

	openSongsList(albumId) async 
	{
		List<SongModel> songsInAblum = await _onAudioQuery.queryAudiosFrom(AudiosFromType.ALBUM_ID, albumId);
		Navigator.pushNamed(context, SongList.routeName, arguments: songsInAblum);
	}

	@override
	Widget build(BuildContext context) {
		return BasicSeperatedListView(ablumTiles);
	}
	
}
