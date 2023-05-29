import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
// import 'package:rmusic/logic/MusicPlayer.dart';

class AudioPlayerHandler extends BaseAudioHandler with QueueHandler, SeekHandler
{
	static final AudioPlayerHandler _instance = AudioPlayerHandler._internal();
	late AudioHandler audioHandler;
	final AudioPlayer _audioPlayer = AudioPlayer();
	String currentSongId = "";

	factory AudioPlayerHandler()
	{
		return _instance;
	}

	//Private constructor named _internal
	AudioPlayerHandler._internal()
	{
		_audioPlayer.playbackEventStream.map(_transformEvent).pipe(playbackState);
		_audioPlayer.currentIndexStream.listen(indexStreamListener);
		AudioService.init(
			builder: () => AudioPlayerHandler(),
			config: const AudioServiceConfig(
			androidNotificationChannelId: 'com.ryanheise.myapp.channel.audio',
			androidNotificationChannelName: 'Audio playback',
			androidNotificationOngoing: true,
			),
		).then((value) => audioHandler = value);
	}

	Stream<bool> get playingStream
	{
		return _audioPlayer.playingStream;
	}

	Stream<Duration> get positionStream
	{
		return _audioPlayer.positionStream;
	}

	setSongList(List<MediaItem> items, {initIndex = 0})
	{
		_audioPlayer.setAudioSource(ConcatenatingAudioSource(children: items.map((MediaItem item) => 
				AudioSource.uri(
					Uri.parse(item.id)
				)).toList()
			),
			initialIndex: initIndex,
			preload: true
		);
	}

	set listId(String id)
	{
	}

	@override
	Future<void> playMediaItem(MediaItem iMediaItem)
	{
		int indexToPlay = queue.value.indexOf(iMediaItem);
		mediaItem.value = iMediaItem;

		if(isSameAlbum(iMediaItem) == false)
		{
			setSongList(queue.value, initIndex: indexToPlay);
		}
		else
		{
			_audioPlayer.seek(
				Duration.zero, 
				index: indexToPlay != -1 ? indexToPlay : 0
			);
		}

		return play();
	}

	isSameAlbum(MediaItem iMediaItem)
	{
		Uri currentMediaItemUri = Uri.parse(iMediaItem.id);
		bool sameAblum = false;
		for(var currentElemnt in _audioPlayer.sequence!)
		{
			if(currentMediaItemUri == (currentElemnt as ProgressiveAudioSource).uri)
			{
				sameAblum = true;
			}
		}

		return sameAblum;
	}

	@override
	Future<void> updateQueue(List<MediaItem> newQueue)
	{
		if(_audioPlayer.audioSource == null)
		{
			setSongList(newQueue, initIndex: 0);
			mediaItem.value = newQueue[0];
		}

		return super.updateQueue(newQueue);
	}

	@override
  	Future<void> play() 
	{
		return _audioPlayer.play();
	}

	@override
	Future<void> pause()
	{
		return _audioPlayer.pause();
	}

	@override
	Future<void> seek(Duration position)
	{
		return _audioPlayer.seek(position);
	}

	@override
	Future<void> skipToPrevious() {
		return _audioPlayer.seekToPrevious();
	}

	@override
	Future<void> skipToNext() {
		return _audioPlayer.seekToNext();
	}

	void indexStreamListener(int? index)
	{
		if(index != null)
		{
			mediaItem.value = queue.value[index];
		}
	}

	@override
	Future<void> stop()
	{
		return _audioPlayer.stop();
	}	

	PlaybackState _transformEvent(PlaybackEvent event)
	{
		return PlaybackState(
			controls: [
				MediaControl.skipToPrevious,
				if (_audioPlayer.playing) MediaControl.pause else MediaControl.play,
				MediaControl.skipToNext,
			],
			systemActions: const {
				MediaAction.seek,
				MediaAction.skipToPrevious,
				MediaAction.skipToNext
			},
			androidCompactActionIndices: const [0, 1, 2],
			processingState: const {
				ProcessingState.idle: AudioProcessingState.idle,
				ProcessingState.loading: AudioProcessingState.loading,
				ProcessingState.buffering: AudioProcessingState.buffering,
				ProcessingState.ready: AudioProcessingState.ready,
				ProcessingState.completed: AudioProcessingState.completed,
			}[_audioPlayer.processingState]!,
			playing: _audioPlayer.playing,
			updatePosition: _audioPlayer.position,
			bufferedPosition: _audioPlayer.bufferedPosition,
			speed: _audioPlayer.speed,
			queueIndex: event.currentIndex,
		);
	}
}
