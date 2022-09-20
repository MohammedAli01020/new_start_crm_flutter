import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../utils/app_colors.dart';

class DefaultUserAvatarWidget extends StatelessWidget {
  final String? imageUrl;
  final String? fullName;
  final double height;
  final VoidCallback? onTap;


  const DefaultUserAvatarWidget({Key? key,
    required  this.imageUrl,
    required this.height,
    required this.fullName,
    this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(5.0),
        alignment: Alignment.center,
        child: ClipOval(
            child: imageUrl != null
                ? CachedNetworkImage(
              height: height,
              width: height,
              fit: BoxFit.cover,
              imageUrl: imageUrl!,
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
                radius: height / 2,
                child: Text(
                  fullName != null ? fullName!.characters.first : "NO",
                  style: const TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ))),
        height: height,
        width: height,
        decoration:  BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(blurRadius: 1.0, color: AppColors.hint)],
        ),
      ),
    );
  }
}
