import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:test_quest/common/const.dart';

class CommunityCard extends StatelessWidget {
  final String id;
  final String? thumbnailUrl;
  final String title;
  final String author;
  final DateTime startDate;
  final DateTime endDate;
  final int views;
  final String status;
  final VoidCallback? onPressed;
  final VoidCallback? onTap;

  const CommunityCard({
    super.key,
    required this.id,
    this.thumbnailUrl,
    required this.title,
    required this.author,
    required this.startDate,
    required this.endDate,
    required this.views,
    required this.status,
    required this.onPressed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isBeforeDeadline = DateTime.now().isBefore(
      endDate.add(const Duration(days: 1)),
    );
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      label: '$title, 작성자 $author, ${isBeforeDeadline ? "모집 중" : "모집 완료"}',
      hint: '탭하여 자세히 보기',
      button: true,
      child: Card.filled(
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 160,
                  height: 160,
                  child: _buildThumbnailImage(thumbnailUrl),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                            ),
                          ),
                          IconButton.filledTonal(
                            icon: const Icon(Icons.bookmark_add_outlined),
                            onPressed: onPressed,
                            tooltip: '북마크 추가',
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '작성자: $author',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '기간: ${formatToYMD(startDate)} - ${formatToYMD(endDate)}',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.remove_red_eye_outlined,
                            size: 16,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$views 조회수',
                            style: textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Chip(
                            label: Text(
                              isBeforeDeadline ? '모집 중' : '모집 완료',
                              style: textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: isBeforeDeadline
                                    ? colorScheme.onPrimaryContainer
                                    : colorScheme.onSurfaceVariant,
                              ),
                            ),
                            color: WidgetStateProperty.all(
                              isBeforeDeadline
                                  ? colorScheme.primaryContainer
                                  : colorScheme.surfaceContainerHighest,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnailImage(String? thumbnailUrl) {
    return Builder(
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;

        // 썸네일 URL이 유효하지 않은 경우 기본 아이콘 표시
        if (thumbnailUrl == null ||
            thumbnailUrl.isEmpty ||
            thumbnailUrl == "null" ||
            !thumbnailUrl.startsWith('http')) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              color: colorScheme.surfaceContainerHighest,
              child: Icon(
                Icons.image_outlined,
                size: 48,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          );
        }

        return Hero(
          tag: 'post_thumbnail_$id',
          child: Material(
            color: Colors.transparent,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: thumbnailUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: colorScheme.surfaceContainerHighest,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                errorWidget: (context, error, stackTrace) {
                  return Container(
                    color: colorScheme.surfaceContainerHighest,
                    child: Center(
                      child: Icon(
                        Icons.broken_image_outlined,
                        size: 48,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
