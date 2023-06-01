
import 'package:alzcare/components/comment_button.dart';
import 'package:alzcare/components/like_button.dart';
import 'package:alzcare/helper/helper_method.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'comment.dart';
import 'dislike_button.dart';


class WallPost extends StatefulWidget {
  final String message;
  final String user;
  final String postID;
  final String time;
  final List<String> likes;
  final List<String> dislikes;

  const WallPost({
    super.key,
    required this.message,
    required this.user,
    required this. postID,
    required this.likes,
    required this.dislikes,
    required this.time,
    });

  @override
  State<WallPost> createState() => _WallPostState();
}

 class _WallPostState extends State<WallPost> {

   final user = FirebaseAuth.instance.currentUser!;

   bool isLiked=false;
   bool isdisLiked=false;

   final _commentTextController = TextEditingController();

   @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(user.email);
    isdisLiked = widget.dislikes.contains(user.email);
  }

  

  void toggleLike(){
    setState(() {
      isLiked=!isLiked;

      if(isLiked){
          isdisLiked= false;
      }
    });

   DocumentReference postRef = FirebaseFirestore.instance.collection('user posts').doc(widget.postID);

   if (isLiked) {
  postRef.update({
    'Likes': FieldValue.arrayUnion([user.email]),
    'disLikes': FieldValue.arrayRemove([user.email])
  });
} 
else if (isdisLiked) {
  postRef.update({
    'Likes': FieldValue.arrayRemove([user.email]),
    'disLikes': FieldValue.arrayUnion([user.email])
  });
} else {
  postRef.update({
    'Likes': FieldValue.arrayRemove([user.email]),
    'disLikes': FieldValue.arrayRemove([user.email])
  });
}

    }

  void toggledisLike(){
    setState(() {
      isdisLiked=!isdisLiked;

      if(isdisLiked){
          isLiked= false;
      }
    });

    DocumentReference postRef = FirebaseFirestore.instance.collection('user posts').doc(widget.postID);

    /*if(isLiked)
    {
      postRef.update({
        'Likes': FieldValue.arrayUnion([user.email])
      });
    }
    else{
      postRef.update({
        'Likes': FieldValue.arrayRemove([user.email])
      });
    }
     if(isdisLiked)
    {
      postRef.update({
        'disLikes': FieldValue.arrayUnion([user.email])
      });
    }
    
    else{
      postRef.update({
        'disLikes': FieldValue.arrayRemove([user.email])
      });
    */
  

if (isLiked) {
  postRef.update({
    'Likes': FieldValue.arrayUnion([user.email]),
    'disLikes': FieldValue.arrayRemove([user.email])
  });
} 
else if (isdisLiked) {
  postRef.update({
    'Likes': FieldValue.arrayRemove([user.email]),
    'disLikes': FieldValue.arrayUnion([user.email])
  });
} else {
  postRef.update({
    'Likes': FieldValue.arrayRemove([user.email]),
    'disLikes': FieldValue.arrayRemove([user.email])
  });
}
 }
  // add a comment
  void addComment(String commentText){
    FirebaseFirestore.instance.collection('user posts').doc(widget.postID).collection('comments').add({
      'CommentText': commentText,
      'CommentedBy': user.email,
      'CommentTime': Timestamp.now(),
    });
  }
  

 //DateTime date = DateTime.now();
  //show dialog for comment

  void showCommentDialog(){
   showDialog(
   context: context, 
   builder: (context)=>AlertDialog(
    title: Text('Add Comment'),
    content: TextField(
      controller: _commentTextController,
      decoration: InputDecoration(
        hintText: 'Write a Comment',
      ),
    ),
    actions: [

      //post button
      TextButton(
        onPressed: (){
        addComment(_commentTextController.text);
        Navigator.pop(context);
        _commentTextController.clear();
        } ,
        child: Text('Post')),
      //cancel button

      TextButton(
        onPressed: (){
         Navigator.pop(context);
        _commentTextController.clear();
        }, 
        child: Text('Cancel'))

    ],
   ));
  }






  // ignore: unused_element
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.only(top: 25,left: 25,right: 25),
      padding: EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
      
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
              children: [
                Text(widget.user,style: TextStyle(color: Colors.grey[500]),),
                Text(' . ',style: TextStyle(color: Colors.grey[500]),),
                Text(widget.time,style: TextStyle(color: Colors.grey[500]),),
              ],
            ),
              const SizedBox(height: 5,),
              Text(widget.message),
            ],
          ),

          const SizedBox(height: 20,),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Column(
                children: [
                  LikeButton(
                    isLiked: isLiked
                  , onTap: toggleLike
                  ),
                  const SizedBox(height: 5),
                  Text(widget.likes.length.toString(),
                  style: TextStyle(color: Color.fromARGB(255, 117, 116, 116)),),

            ]),
            const SizedBox(width: 10),

            Column(
                children: [
                  disLikeButton(
                    isdisLiked: isdisLiked
                  , onTap: toggledisLike
                  ),
                  const SizedBox(height: 5),
                  Text(widget.dislikes.length.toString(),
                  style: TextStyle(color: Color.fromARGB(255, 117, 116, 116)),),

            ]),
            const SizedBox(width: 10),
                

           Column(
              children: [
                CommentButton(
                        onTap: showCommentDialog),
                        const SizedBox(height: 5),
                     const Text('0',
                     style: TextStyle(
                    color: Color.fromARGB(255, 117, 116, 116)),),
                    ],
                  ),
                  
                ],
        
              ),
           
          const SizedBox(height: 10),

        //comments
       StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore
          .instance
          .collection('user posts')
          .doc(widget.postID)
          .collection('comments')
          .orderBy('CommentTime',descending: true)
          .snapshots(),
          builder: (context,snapshot){
          //show loading if there is no data

          if(!snapshot.hasData)
          {
            return const Center(child: CircularProgressIndicator(),);
          }

          return ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: snapshot.data!.docs.map((doc) {
              final commentData = doc.data() as Map<String, dynamic>;

              return Comment(
                text: commentData['CommentText'],
                user: commentData['CommentedBy'],
                time: formatDate(commentData['CommentTime']),
              );

            }).toList(),
          );

          })
        

      ],
          ),

    );
  }
  }
  
  
 