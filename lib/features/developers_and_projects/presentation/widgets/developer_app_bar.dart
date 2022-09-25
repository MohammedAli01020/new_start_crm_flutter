import 'package:flutter/material.dart';

import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/enums.dart';


class DevelopersAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Function onSearchChangeCallback;
  final Function onCancelTapCallback;
  final Function onDoneTapCallback;
  final VoidCallback onNewTapCallback;

  final String developerType;

  const DevelopersAppBar({Key? key,
    required this.onSearchChangeCallback,
    required this.onCancelTapCallback,
    required this.onNewTapCallback,
    required this.developerType,
    required this.onDoneTapCallback}) : super(key: key);

  @override
  _DevelopersAppBarState createState() => _DevelopersAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _DevelopersAppBarState extends State<DevelopersAppBar> {
  bool isSearch = false;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: isSearch
          ? TextField(
        textInputAction: TextInputAction.go,
        decoration: const InputDecoration(
          hintText: "اسم المطور",
        ),
        onChanged: (search) {
          widget.onSearchChangeCallback(search);
        },
      )
          : const Text("المطورين"),
      actions: [
        IconButton(
            onPressed: () {
              setState(() {
                isSearch = !isSearch;
              });

              widget.onCancelTapCallback(isSearch);
            },
            icon: Icon(isSearch ? Icons.cancel : Icons.search)),

        if (widget.developerType == DevelopersType.SELECT_DEVELOPERS.name)
          IconButton(
              onPressed: () {
                widget.onDoneTapCallback();
              },
              icon: const Icon(Icons.done)),


          if (Constants.currentEmployee!.permissions.contains(AppStrings.createDevelopers))
            if (widget.developerType == DevelopersType.VIEW_DEVELOPERS.name)
        IconButton(onPressed: widget.onNewTapCallback,
            icon: const Icon(Icons.add))

      ],
    );
  }
}