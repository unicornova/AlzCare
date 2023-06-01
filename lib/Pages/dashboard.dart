import 'package:alzcare/components/wall_post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/textfield.dart';


class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  final currentuser= FirebaseAuth.instance.currentUser!;

  final textController = TextEditingController();

  void postMsg(){
    
    if(textController.text.isNotEmpty)
    {
      FirebaseFirestore.instance.collection('user posts').add({
        'UserEmail':currentuser.email,
        'Message': textController.text,
        'TimeStamp': Timestamp.now(),
        'Likes':[],
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
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("user posts").orderBy("TimeStamp",descending: false).snapshots(),
           builder: (context, snapshot) {
             if(snapshot.hasData)
             {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: 
                (context,index){
                  final post = snapshot.data!.docs[index];
                  return WallPost(
                    message: post['Message'],
                    user:post['UserEmail'], 
                    postID: post.id,
                    likes: List<String>.from(post['Likes'] ?? []),
                   );

              });
             }
             else if (snapshot.hasError)
             {
              return Center(child: Text('Error '+snapshot.error.toString()),
              );
             };
             return const Center(child: CircularProgressIndicator(),);
           },
           )
           ),

        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
        
              //const SizedBox(height: 50),
              Expanded(
                child: MyTextField(
                  controller: textController,
                  hintText: 'Add a Post',
                  obscureText: false,)
                ),
            IconButton(
              onPressed: postMsg, 
              icon: const Icon(Icons.arrow_circle_up)
              ),
          
          
        
        
        
        
        
         ]),
        ),
          //const SizedBox(height: 10),
          Text('Logged in as '+ currentuser.email!)
       ,
       const SizedBox(height: 50,)
      
   ] )
    )
    );
  }
}