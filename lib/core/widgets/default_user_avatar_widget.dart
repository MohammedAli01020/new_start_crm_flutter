import 'package:flutter/material.dart';

class DefaultUserAvatarWidget extends StatelessWidget {
  final String? imageUrl;
  final int height;
  final int width;

  const DefaultUserAvatarWidget({Key? key,required  this.imageUrl, required this.height, required this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5.0),
      alignment: Alignment.center,
      child: ClipOval(
          child: currentEmployee.imageUrl != null
              ? CachedNetworkImage(
            height: 40.0,
            width: 40.0,
            fit: BoxFit.cover,
            imageUrl: currentEmployee.imageUrl!,
            placeholder: (context, url) =>
                Container(
                  decoration: BoxDecoration(
                    color:
                    AppColors.hint.withOpacity(0.2),
                  ),
                ),
            errorWidget: (context, url, error) =>
            const Icon(Icons.error),
          )
              : CircleAvatar(
              backgroundColor: Colors.grey,
              radius: 20.0,
              child: Text(
                currentEmployee.fullName.characters.first,
                style: const TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ))),
      height: 40.0,
      width: 40.0,
      decoration:  BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(blurRadius: 1.0, color: AppColors.hint)],
      ),
    );
  }
}
