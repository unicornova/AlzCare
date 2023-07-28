import 'package:alzcare/Pages/dashboard.dart';
import 'package:alzcare/Pages/first_detection.dart';
import 'package:alzcare/Pages/invoice.dart';
import 'package:alzcare/Pages/know_alz.dart';
import 'package:alzcare/Pages/map_page.dart';
import 'package:alzcare/Pages/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sass/sass.dart' as sass;
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';





class Sass extends StatelessWidget {
  final String sassCode ='''
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Loading Animation</title>
  <style>
  ${compoileSasstoCss('''

    \$loader-size: 80px;
    \$loader-color: #4caf50;

body {
  display: flex;
  justify-content: center;
  
  height: 100vh;
  margin: 0;
  background-color: #f8f8f8;
}

.loading-container {
  position: relative;
  width: \$loader-size;
  height: \$loader-size;
}

.loading-brain {
  font-size: \$loader-size;
  animation: brain-pulse 1.5s ease-in-out infinite;
  transform-origin: center;
}

@keyframes brain-pulse {
  0% {
    transform: scale(1);
    opacity: 1;
  }
  50% {
    transform: scale(1.2);
    opacity: 0.8;
  }
  100% {
    transform: scale(1);
    opacity: 1;
  }
}


''')}
  </style>
</head>
<body>
  <div class="loading-container">
    <div class="loading-brain" role="img" aria-label="Brain Emoji">🧠</div>
  </div>
</body>
</html> ''';
   Sass({super.key});

  static String compoileSasstoCss(String sassCode){
    // ignore: deprecated_member_use
    final cssCode = sass.compileString(sassCode);
    return cssCode.trim();
  }

  signOutUser(){
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 145, 46, 165),
        actions: [IconButton(onPressed: signOutUser, icon: const Icon(Icons.logout))],
        title: Text('Dashboard'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20,),
          Row(
            children: [
              Container(
                height: 100,
                width: 150,
                child: Expanded(child: InAppWebView(initialData: InAppWebViewInitialData(data: sassCode),))),

                const SizedBox(width: 10,),
                Stack(
                  children: [Container(
                    width: 210,
                    height: 100,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 101, 78, 124),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 30,
                    left: 40,
                    child:GestureDetector(
                      onTap: (){
              // Navigate to another page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FirstDetection(),
                ),
              );
            },
                      child: Container(
                      width: 160,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15)
                          
                        ),
                      ),
                      child: Center(child: Text('Detection',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: Colors.grey[700]),)),
                                      ),
                    ), )
                  ]
                ),
            ],
          ),
          const SizedBox(height: 10,),
          Stack(
                  children: [Container(
                    width: 360,
                    height: 100,
                    decoration: const BoxDecoration(
                      //color: Color.fromARGB(255, 105, 7, 73),
                      color: Colors.black,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(50),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 30,
                    left: 10,
                    child:GestureDetector(
                      onTap: (){
              // Navigate to another page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DashboardPage(),
                ),
              );
            },
                      child: Container(
                      width: 250,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15)
                          
                        ),
                      ),
                      child: Center(child: Text('Connect with Others!',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: Colors.grey[700]),)),
                                      ),
                    ), )
                  ]
                ),
                const SizedBox(height: 10,),
          Stack(
                  children: [Container(
                    width: 360,
                    height: 100,
                    decoration: const BoxDecoration(
                      //color: Color.fromARGB(255, 105, 7, 73),
                      color: Color.fromARGB(255, 101, 78, 124),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 30,
                    left: 100,
                    child:GestureDetector(
                      onTap: (){
              // Navigate to another page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => KnowAlzPage(),
                ),
              );
            },
                      child: Container(
                      width: 250,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15)
                          
                        ),
                      ),
                      child: Center(child: Text("Know Alzheimer's",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: Colors.grey[700]),)),
                                      ),
                    ), )
                  ]
                ),
                const SizedBox(height: 10,),
          Stack(
                  children: [Container(
                    width: 360,
                    height: 100,
                    decoration: const BoxDecoration(
                      //color: Color.fromARGB(255, 105, 7, 73),
                      color: Color.fromARGB(255, 0, 0, 0),
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(50),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 30,
                    left: 10,
                    child:GestureDetector(
                      onTap: (){
              // Navigate to another page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserProfile(),
                ),
              );
            },
                      child: Container(
                      width: 250,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15)
                          
                        ),
                      ),
                      child: Center(child: Text("User Profile",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: Colors.grey[700]),)),
                                      ),
                    ), )
                  ]
                ),
                const SizedBox(height: 10,),
          Stack(
                  children: [Container(
                    width: 360,
                    height: 100,
                    decoration: const BoxDecoration(
                      //color: Color.fromARGB(255, 105, 7, 73),
                      color: Color.fromARGB(255, 101, 78, 124),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 30,
                    right: 10,
                    child:GestureDetector(
                      onTap: (){
              // Navigate to another page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MapPage(),
                ),
              );
            },
                      child: Container(
                      width: 250,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15)
                          
                        ),
                      ),
                      child: Center(child: Text("Map",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: Colors.grey[700]),)),
                                      ),
                    ), )
                  ]
                ),
                const SizedBox(height: 10,),
          Stack(
                  children: [Container(
                    width: 360,
                    height: 100,
                    decoration: const BoxDecoration(
                      //color: Color.fromARGB(255, 105, 7, 73),
                      color: Color.fromARGB(255, 0, 0, 0),
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(50),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 30,
                    left: 10,
                    child:GestureDetector(
                      onTap: (){
              // Navigate to another page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Pdf(),
                ),
              );
            },
                      child: Container(
                      width: 250,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15)
                          
                        ),
                      ),
                      child: Center(child: Text("Invoice",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: Colors.grey[700]),)),
                                      ),
                    ), )
                  ]
                ),
        ],
      ),
    );
  }
}
//align-items: center;