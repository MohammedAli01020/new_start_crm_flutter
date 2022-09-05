import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/constants.dart';

class DefaultBottomNavigationWidget extends StatelessWidget {

  final bool withDelete;
  final VoidCallback onEditTapCallback;
  final Function omDeleteCallback;

  const DefaultBottomNavigationWidget(
      {Key? key,
      this.withDelete = true,
      required this.onEditTapCallback,
      required this.omDeleteCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            color: AppColors.hint,
            spreadRadius: 0.5,
            blurRadius: 0.5,
            offset: const Offset(-2.0, 0)),
      ]),
      child: Row(
        children: [
          Expanded(
              child: ElevatedButton.icon(
            onPressed: onEditTapCallback,
            label: const Text("تعديل"),
            icon: const Icon(Icons.edit),
          )),
          if (withDelete)
            const SizedBox(
              width: 10.0,
            ),
          if (withDelete)
            Expanded(
                child: ElevatedButton.icon(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      final result = await Constants.showConfirmDialog(
                          context: context, msg: "هل تريد تأكيد الحذف؟");

                      omDeleteCallback(result);
                    },
                    label: const Text("حذف"))),
        ],
      ),
    );
  }
}
