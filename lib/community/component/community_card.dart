import 'package:flutter/material.dart';

class CommunityCard extends StatelessWidget {
  final String? thumbnailUrl;
  final String title;
  final String author;
  final String startDate;
  final String endDate;
  final int views;
  final String status;

  const CommunityCard({
    super.key,
    this.thumbnailUrl,
    required this.title,
    required this.author,
    required this.startDate,
    required this.endDate,
    required this.views,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
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
              child: Image.network(
                thumbnailUrl ?? "",
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image,
                        size: 40, color: Colors.grey),
                  );
                },
              ),
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
                        onPressed: () {},
                      )
                    ],
                  ),
                  Text('작성자: $author'),
                  const SizedBox(height: 4),
                  Text('기간: $startDate - $endDate'),
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
                          color: status == '모집중'
                              ? Colors.green[100]
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          status == '모집중' ? '모집 중' : '모집 완료',
                          style: TextStyle(
                            color: status == '모집중'
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
}
