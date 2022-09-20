import 'package:flutter/material.dart';

import '../../../../core/utils/enums.dart';


class SourcesAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Function onSearchChangeCallback;
  final Function onCancelTapCallback;
  final Function onDoneTapCallback;
  final VoidCallback onNewTapCallback;

  final String sourceType;

  const SourcesAppBar({Key? key,
    required this.onSearchChangeCallback,
    required this.onCancelTapCallback,
    required this.onNewTapCallback,
    required this.sourceType,
    required this.onDoneTapCallback}) : super(key: key);

  @override
  _SourcesAppBarState createState() => _SourcesAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SourcesAppBarState extends State<SourcesAppBar> {
  bool isSearch = false;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: isSearch
          ? TextField(
        textInputAction: TextInputAction.go,
        decoration: const InputDecoration(
          hintText: "اسم المصدر",
        ),
        onChanged: (search) {
          widget.onSearchChangeCallback(search);
        },
      )
          : const Text("المصادر"),
      actions: [
        IconButton(
            onPressed: () {
              setState(() {
                isSearch = !isSearch;
              });

              widget.onCancelTapCallback(isSearch);
            },
            icon: Icon(isSearch ? Icons.cancel : Icons.search)),

        if (widget.sourceType == SourceType.SELECT_SOURCES.name)
          IconButton(
              onPressed: () {
                widget.onDoneTapCallback();
              },
              icon: const Icon(Icons.done)),


        if (widget.sourceType == SourceType.VIEW_SOURCES.name)
        IconButton(onPressed: widget.onNewTapCallback,
            icon: const Icon(Icons.add))

      ],
    );
  }
}