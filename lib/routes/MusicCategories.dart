import 'package:flutter/material.dart';
import 'package:rmusic/components/Lists/AlbumList.dart';

import 'package:rmusic/components/Lists/FolderList.dart';

class MusicCategories extends StatefulWidget 
{
  	const MusicCategories({Key? key}) : super(key: key);

	@override
	State<StatefulWidget> createState() {
		return _MusicCategories();
	}
}

class _MusicCategories extends State<MusicCategories>
{
	int _selectedItemIndex = 0;
	List<Widget> options = [AlbumList(), FolderList(), FolderList()]; 

	void _onItemSelected(int index)
	{
		setState(() {
		  _selectedItemIndex = index;
		});
	}

	void fetchInfo()
	{

	}

	@override
    Widget build(BuildContext context)
    {
		return DefaultTabController(
			length: 3, 
			child: Scaffold(
				body: options[_selectedItemIndex],
				appBar: AppBar(
					toolbarHeight: 0,
					bottom: TabBar(
						tabs: const [
							Tab(icon: Icon(Icons.library_music_rounded, ), text: "Albums"),
							Tab(icon: Icon(Icons.folder), text: "Folders"),
							Tab(icon: Icon(Icons.person), text: "Artists"),
						],
						onTap: _onItemSelected,
						indicatorSize: TabBarIndicatorSize.tab,
					),
				),
			)
		);
	}
}
