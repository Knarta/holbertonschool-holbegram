import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:holbegram/screens/login_screen.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => LoginScreen(
          emailController: TextEditingController(),
          passwordController: TextEditingController(),
        ),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final String? uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            fontFamily: 'Billabong',
            fontSize: 40,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: uid == null
          ? const Center(child: Text('Please login'))
          : StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .snapshots(),
              builder: (context, userSnapshot) {
                if (userSnapshot.hasError) {
                  return Center(
                    child: Text('Error ${userSnapshot.error}'),
                  );
                }
                if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                  return const Center(child: CircularProgressIndicator());
                }

                final Map<String, dynamic> userData =
                    userSnapshot.data!.data() ?? {};
                final List<dynamic> followers =
                    (userData['followers'] as List<dynamic>?) ?? [];
                final List<dynamic> following =
                    (userData['following'] as List<dynamic>?) ?? [];
                final String username = (userData['username'] ?? '').toString();
                final String bio = (userData['bio'] ?? '').toString();
                final String photoUrl = (userData['photoUrl'] ?? '').toString();

                return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .where('uid', isEqualTo: uid)
                      .snapshots(),
                  builder: (context, postSnapshot) {
                    if (postSnapshot.hasError) {
                      return Center(
                        child: Text('Error ${postSnapshot.error}'),
                      );
                    }
                    if (!postSnapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final posts = postSnapshot.data!.docs;

                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 42,
                                  backgroundImage: photoUrl.isNotEmpty
                                      ? NetworkImage(photoUrl)
                                      : null,
                                  child: photoUrl.isEmpty
                                      ? const Icon(Icons.person, size: 42)
                                      : null,
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      _buildStat(posts.length.toString(), 'Posts'),
                                      _buildStat(
                                        followers.length.toString(),
                                        'Followers',
                                      ),
                                      _buildStat(
                                        following.length.toString(),
                                        'Following',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                username,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(bio),
                            ),
                            const SizedBox(height: 16),
                            const Divider(),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: posts.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 6,
                                mainAxisSpacing: 6,
                                childAspectRatio: 1,
                              ),
                              itemBuilder: (context, index) {
                                final data = posts[index].data();
                                final String postUrl =
                                    (data['postUrl'] ?? '').toString();

                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: postUrl.isNotEmpty
                                      ? Image.network(postUrl, fit: BoxFit.cover)
                                      : Container(
                                          color: Colors.grey.shade300,
                                          child: const Icon(Icons.image),
                                        ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(label),
      ],
    );
  }
}
