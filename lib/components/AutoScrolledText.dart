

import 'dart:async';

import 'package:flutter/material.dart';

class AutoScrolledText extends StatefulWidget {
	final String textToScroll;
	final bool shouldScroll;

	const AutoScrolledText(this.textToScroll, { this.shouldScroll = true, Key? key}) : super(key: key);

	@override
	_AutoScrolledTextState createState() => _AutoScrolledTextState();
}

class _AutoScrolledTextState extends State<AutoScrolledText> {
	static const Duration scrollingInterval = Duration(seconds: 10);
	static const Duration animationDuation = Duration(seconds: 5);

	final ScrollController _scrollController = ScrollController();

	Timer? _scrollTimer;

	@override
	void dispose()
	{
		_scrollTimer?.cancel();
		super.dispose();
	}

	handleTimer(Timer timer)
	{
		if(_scrollController.hasClients)
		{
			ScrollPosition position = _scrollController.position;
			double animateTo; 
			
			if(position.pixels != position.maxScrollExtent)
			{
				animateTo = _scrollController.position.maxScrollExtent;
			}
			else
			{
				animateTo = _scrollController.position.minScrollExtent;
			}

			_scrollController.animateTo(animateTo, duration: animationDuation, curve: Curves.ease);
		}
	}
	
	@override
	Widget build(BuildContext context)
	{
		if(widget.shouldScroll)
		{
			_scrollTimer = Timer.periodic(scrollingInterval, handleTimer);
		}

		return SingleChildScrollView(
			child: Text(widget.textToScroll),
			scrollDirection: Axis.horizontal,
			physics: BouncingScrollPhysics(),
			controller: _scrollController,
		);
	}
}

