import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:rmusic/components/AutoScrolledText.dart';
import 'package:rmusic/logic/AudioPlayerHandler.dart';

class MusicControls extends StatefulWidget {
	const MusicControls({ Key? key }) : super(key: key);

	@override
	_MusicControlsState createState() => _MusicControlsState();
}

class _MusicControlsState extends State<MusicControls> {
	AudioPlayerHandler audioPlayerHandler = AudioPlayerHandler();
	AudioHandler audioHandler = AudioPlayerHandler().audioHandler;
	bool isPlaying = false;
	double sliderValue = 0;
	String sliderLabel = "00:00";

	List<StreamSubscription> subscriptions = [];

	_MusicControlsState()
	{
		subscriptions.add(audioPlayerHandler.playingStream.listen(setIsPlaying));
		subscriptions.add(audioPlayerHandler.positionStream.listen(durationChanged));

		sliderLabel = getLabelText();
	}

	@override
  	void dispose()
	{
		for (StreamSubscription subscription in subscriptions) 
		{
			subscription.cancel();
		}

		super.dispose();
	}

	playOrPause()
	{
		if(isPlaying)
		{
			audioHandler.pause();
		}
		else
		{
			audioHandler.play();
		}
	}

	stopMusic()
	{
		audioHandler.stop();
	}

	setIsPlaying(bool iIsPlaying)
	{
		setState(() {
			isPlaying = iIsPlaying;
		});
	}

	durationChanged(Duration currentDuration)
	{
		num songSecondsLength = currentDuration.inSeconds;
		setState(() {
			sliderValue = songSecondsLength.toDouble();
		});
		setSliderLabel();
	}

	sliderFinalValue(double value)
	{
		audioHandler.seek(Duration(
			seconds: value.floor()
		));

		playOrPause();
	}

	sliderChanged(double value)
	{
		setState(() {
			sliderValue = value;
		});

		audioHandler.pause();
		setSliderLabel();
	}

	getLabelText()
	{
		const int secondsInMinute = 60;

		String minutes = (sliderValue / secondsInMinute).floor().toString().padLeft(2, "0");
		String seconds = (sliderValue % secondsInMinute).floor().toString().padLeft(2, "0");

		return "$minutes:$seconds";
	}

	setSliderLabel()
	{
		setState(() {
			sliderLabel = getLabelText();
		});
	}

	@override
	Widget build(BuildContext context) {
		double maxSliderValue = (audioHandler.mediaItem.value?.duration?.inSeconds)?.floor().toDouble() ?? 0;
		return Container(
			color: Colors.blueGrey[800],
			child: Column(
				mainAxisSize: MainAxisSize.min,
				children: [
					Container(
						child: AutoScrolledText("${audioHandler.mediaItem.value?.title} - ${audioHandler.mediaItem.value?.artist}"),
						padding: const EdgeInsets.fromLTRB(20, 10, 20, 0)
					),
					Row(
						children: [
							Container(
								child: Text(sliderLabel),
								padding: const EdgeInsets.fromLTRB(20, 0, 0, 0)
							),
							Expanded(
								child: Slider.adaptive(
									value: sliderValue > maxSliderValue ? 0 : sliderValue, 
									min: 0,
									max: maxSliderValue + 1,
									onChanged: sliderChanged,
									onChangeEnd: sliderFinalValue,
								),
							)
						],
						crossAxisAlignment: CrossAxisAlignment.center,
						mainAxisAlignment: MainAxisAlignment.center,
					),
					Row(
						children: [
							IconButton(
								onPressed: () => audioHandler.skipToPrevious(),
								icon: const Icon(Icons.fast_rewind_rounded), 
								iconSize: 40,
							),
							IconButton(
								onPressed: playOrPause, 
								icon: Icon(isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded), 
								iconSize: 40,
							),
							IconButton(
								onPressed: audioHandler.skipToNext,
								icon: const Icon(Icons.fast_forward_rounded), 
								iconSize: 40,
							),
						],
						mainAxisAlignment: MainAxisAlignment.center,
						crossAxisAlignment: CrossAxisAlignment.center,
					)
				],
			),
		);
	}
}
