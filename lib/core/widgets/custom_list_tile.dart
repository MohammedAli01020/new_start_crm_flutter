import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final String title;
  final String? subTitle;
  final Widget? trailing;
  final VoidCallback onTapCallback;
  final bool? isSelected;
  const CustomListTile({Key? key,
    required this.title,
    this.subTitle,
    required this.onTapCallback, this.trailing, this.isSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children:  [
          ListTile(
            title: Text(title),
            onTap: onTapCallback,
            subtitle: subTitle != null ? Text(subTitle!) : null,
            trailing: trailing,
            selected: isSelected ?? false,
          ),
          const Divider(),

        ],
      ),
    );
  }
}
