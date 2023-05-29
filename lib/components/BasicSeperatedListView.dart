

import 'package:flutter/material.dart';

class BasicSeperatedListView extends StatelessWidget
{
	List items = [];

	BasicSeperatedListView(this.items);

	Widget itemBuilder(BuildContext context, int index)
	{
		return items[index];
	}

	Widget separatorBuilder(BuildContext context, int index)
	{
		const double deviderStartIdent = 20;
		const double deviderEndIdent = 20;
		
		return const Divider(
			indent: deviderStartIdent,
			endIndent: deviderEndIdent,
			height: 0,
		);
	}

	@override
	Widget build(BuildContext context) {
		return ListView.separated(itemBuilder: itemBuilder, separatorBuilder: separatorBuilder, itemCount: items.length);
	}

}
