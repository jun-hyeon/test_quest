import 'package:flutter/material.dart';
import 'package:test_quest/common/const.dart';

class CommunityCard extends StatelessWidget {
  final String? thumbnailUrl;
  final String title;
  final String author;
  final DateTime startDate;
  final DateTime endDate;
  final int views;
  final String status;
  final VoidCallback? onPressed;

  const CommunityCard({
    super.key,
    this.thumbnailUrl,
    required this.title,
    required this.author,
    required this.startDate,
    required this.endDate,
    required this.views,
    required this.status,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isBeforeDeadline = DateTime.now().isBefore(
      endDate.add(const Duration(days: 1)),
    );
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 80,
              height: 80,
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
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.bookmark_add),
                        onPressed: onPressed,
                      )
                    ],
                  ),
                  Text('작성자: $author'),
                  const SizedBox(height: 4),
                  Text(
                      '기간: ${formatToYMD(startDate)} - ${formatToYMD(endDate)}'),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.remove_red_eye,
                          size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text('$views 조회수'),
                      const SizedBox(width: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: isBeforeDeadline
                              ? Colors.green[100]
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          isBeforeDeadline ? '모집 중' : '모집 완료',
                          style: TextStyle(
                            color: isBeforeDeadline
                                ? Colors.green[800]
                                : Colors.grey[600],
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnailImage(String? thumbnailUrl) {
    // 썸네일 URL이 유효하지 않은 경우 기본 아이콘 표시
    if (thumbnailUrl == null ||
        thumbnailUrl.isEmpty ||
        thumbnailUrl == "null" ||
        !thumbnailUrl.startsWith('http')) {
      return Container(
        color: Colors.grey[300],
        child: const Icon(Icons.broken_image, size: 40, color: Colors.grey),
      );
    }

    return Image.network(
      thumbnailUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey[300],
          child: const Icon(Icons.broken_image, size: 40, color: Colors.grey),
        );
      },
    );
  }
}
