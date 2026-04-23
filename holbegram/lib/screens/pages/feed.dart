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
            const Icon(
              Icons.blur_circular,
              size: 22,
              color: Color.fromARGB(218, 226, 37, 24),
            ),
          ],
        ),
        actions: const [
          Icon(Icons.add),
          SizedBox(width: 10),
          Icon(Icons.chat_bubble_outline),
          SizedBox(width: 12),
        ],
      ),
      body: const Posts(),
    );
  }
}
