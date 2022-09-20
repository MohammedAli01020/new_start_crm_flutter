import 'package:flutter/material.dart';

import '../../../../core/utils/enums.dart';


class UnitTypesAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Function onSearchChangeCallback;
  final Function onCancelTapCallback;
  final Function onDoneTapCallback;
  final VoidCallback onNewTapCallback;

  final String sourceType;

  const UnitTypesAppBar({Key? key,
    required this.onSearchChangeCallback,
    required this.onCancelTapCallback,
    required this.onNewTapCallback,
    required this.sourceType,
    required this.onDoneTapCallback}) : super(key: key);

  @override
  _UnitTypesAppBarState createState() => _UnitTypesAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _UnitTypesAppBarState extends State<UnitTypesAppBar> {
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
          : const Text("مفضلات العميل"),
      actions: [
        IconButton(
            onPressed: () {
              setState(() {
                isSearch = !isSearch;
              });

              widget.onCancelTapCallback(isSearch);
            },
            icon: Icon(isSearch ? Icons.cancel : Icons.search)),

        if (widget.sourceType == UnitTypesType.SELECT_UNIT_TYPES.name)
          IconButton(
              onPressed: () {
                widget.onDoneTapCallback();
              },
              icon: const Icon(Icons.done)),


        if (widget.sourceType == UnitTypesType.VIEW_UNIT_TYPES.name)
        IconButton(onPressed: widget.onNewTapCallback,
            icon: const Icon(Icons.add))

      ],
    );
  }
}