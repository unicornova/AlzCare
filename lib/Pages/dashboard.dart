import 'package:alzcare/components/wall_post.dart';
import 'package:alzcare/helper/helper_method.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/textfield.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final textController = TextEditingController();

  int currentPage = 1;
  int itemsPerPage = 10; // Adjust the number of items per page as needed

  int totalItems = 0; // Variable to store the total number of items

  void postMsg() {
    if (textController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection('user posts').add({
        'UserEmail': currentUser.email,
        'Message': textController.text,
        'TimeStamp': Timestamp.now(),
        'Likes': [],
        'disLikes': [],
      });
      setState(() {
        textController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 241, 216, 230),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("user posts")
                    .orderBy("TimeStamp", descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final querySnapshot = snapshot.data!;
                    final items = querySnapshot.docs;

                    totalItems = items.length;

                    final totalPages = (totalItems / itemsPerPage).ceil();

                    if (currentPage > totalPages) {
                      // Handle going beyond available pages
                      setState(() {
                        currentPage = totalPages;
                      });
                    }

                    final startIndex = (currentPage - 1) * itemsPerPage;
                    final endIndex = startIndex + itemsPerPage;

                    final visibleItems = items.sublist(
                      startIndex,
                      endIndex.clamp(0, totalItems),
                    );

                    return ListView.builder(
                      itemCount: visibleItems.length,
                      itemBuilder: (context, index) {
                        final post = visibleItems[index];
                        return WallPost(
                          message: post['Message'],
                          user: post['UserEmail'],
                          postID: post.id,
                          likes: List<String>.from(post['Likes'] ?? []),
                          dislikes: List<String>.from(post['disLikes'] ?? []),
                          time: formatDate(post['TimeStamp']),
                        );
                      },
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error.toString()}'),
                    );
                  }

                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (currentPage > 1) {
                        currentPage--;
                      }
                    });
                  },
                  icon: Icon(Icons.arrow_back),
                ),
                Text('Page $currentPage'),
                IconButton(
                  onPressed: () {
                    setState(() {
                      final totalPages = (totalItems / itemsPerPage).ceil();

                      if (currentPage < totalPages) {
                        currentPage++;
                      }
                    });
                  },
                  icon: Icon(Icons.arrow_forward),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Expanded(
                    child: MyTextField(
                      controller: textController,
                      hintText: 'Add a Post',
                      obscureText: false,
                    ),
                  ),
                  IconButton(
                    onPressed: postMsg,
                    icon: Icon(Icons.arrow_circle_up),
                  ),
                ],
              ),
            ),
            Text('Logged in as ${currentUser.email}'),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}