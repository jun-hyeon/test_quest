import 'package:flutter/material.dart';

class CircleNetworkImage extends StatelessWidget {
  const CircleNetworkImage({
    super.key,
    required this.imageUrl,
  });

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    // 이미지 URL이 유효하지 않은 경우 기본 아이콘 표시
    if (imageUrl.isEmpty ||
        imageUrl == "null" ||
        !imageUrl.startsWith('http')) {
      return Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            width: 0.5,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        child: const Icon(
          Icons.person,
          size: 100,
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          width: 0.5,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Image.network(
          imageUrl,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(
              Icons.person,
              size: 100,
            );
          },
        ),
      ),
    );
  }
}
