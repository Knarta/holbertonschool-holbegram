import 'package:flutter/material.dart';
import 'package:holbegram/utils/posts.dart';

class Feed extends StatelessWidget {
  const Feed({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text(
              'Holbegram',
              style: TextStyle(
                fontFamily: 'Billabong',
                fontSize: 38,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.camera_alt_outlined, size: 28),
          ],
        ),
        actions: const [
          Icon(Icons.add_box_outlined),
          SizedBox(width: 10),
          Icon(Icons.send_outlined),
          SizedBox(width: 12),
        ],
      ),
      body: const Posts(),
    );
  }
}
