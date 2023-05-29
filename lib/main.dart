import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:rmusic/logic/AudioPlayerHandler.dart';

import 'routes/MusicCategories.dart';
import 'components/SongList.dart';

class MusicMain extends StatelessWidget
{
	@override
	Widget build(BuildContext context)
	{
		return MaterialApp(
			title: "Music",
			routes: <String, WidgetBuilder>{
                SongList.routeName: (BuildContext buildContext) => SongList(),
            },
			darkTheme: ThemeData(
				brightness: Brightness.dark
			),
			themeMode: ThemeMode.dark,
			home: MusicCategories(),
			theme: ThemeData(
				primaryColor: Colors.black
			)
		);
	}
}

void main() async
{
	AudioPlayerHandler();
	runApp(MusicMain());
}
