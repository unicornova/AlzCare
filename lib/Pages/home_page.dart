import 'package:alzcare/Pages/rating.dart';
import 'package:alzcare/Pages/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'my_drawer_header.dart';

import 'dashboard.dart';
import 'detection.dart';
import 'know_alz.dart';

import 'map_page.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var currentPage = DrawerSections.dashboard;

  signOutUser(){
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {

  var container;

    if (currentPage == DrawerSections.user_profile) {
      container = const UserProfile();
    } 
    else if (currentPage == DrawerSections.dashboard) {
      container = const DashboardPage();
    } else if (currentPage == DrawerSections.detect_alzheimer) {
      container = const Home();
    } else if (currentPage == DrawerSections.know_alzheimer) {
      container = KnowAlzPage();
    }else if (currentPage == DrawerSections.rating) {
      container = const RatingPage();
    }else if (currentPage == DrawerSections.map) {
      container = const MapPage();
    }else if (currentPage == DrawerSections.signout) {
      container = signOutUser();
    }

    return Scaffold(
      
      appBar: AppBar(backgroundColor: Color.fromARGB(255, 145, 46, 165),
        actions: [IconButton(onPressed: signOutUser, icon: const Icon(Icons.logout))]),

      body: container,

      drawer: Drawer(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                const MyHeaderDrawer(),
                MyDrawerList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

Widget MyDrawerList() {
    return Container(
        padding: const EdgeInsets.only(
        top: 15,
      ),
      child: Column(
        children: [
          menuItem(1, "Profile", Icons.person_2,
              currentPage == DrawerSections.user_profile ? true : false),
          menuItem(2, "Dashboard", Icons.dashboard_outlined,
              currentPage == DrawerSections.dashboard ? true : false),
          menuItem(3, "Detect Alzheimer", Icons.search,
              currentPage == DrawerSections.detect_alzheimer ? true : false),
          menuItem(4, "Know Alzheimer", Icons.event,
              currentPage == DrawerSections.know_alzheimer ? true : false),
          menuItem(5, "Rate this App", Icons.star,
              currentPage == DrawerSections.know_alzheimer ? true : false),
          menuItem(6, "Map", Icons.map,
              currentPage == DrawerSections.map ? true : false),
          menuItem(7, "Logout", Icons.logout,
              currentPage == DrawerSections.signout ? true : false),
        ],
      )
    );
    }

Widget menuItem(int id, String title, IconData icon, bool selected){
  return Material(
   color: selected ? Colors.grey[300] : Colors.transparent,
   child: InkWell(
    onTap: () {
      Navigator.pop(context);
          setState(() {
            if (id == 1) {
              currentPage = DrawerSections.user_profile;}
            else if (id == 2) {
              currentPage = DrawerSections.dashboard;
            } else if (id == 3) {
              currentPage = DrawerSections.detect_alzheimer;
            } else if (id == 4) {
              currentPage = DrawerSections.know_alzheimer;
            }
            else if (id == 5) {
              currentPage = DrawerSections.rating;
            } else if (id == 6) {
              currentPage = DrawerSections.map;
            }else if (id == 7) {
              currentPage = DrawerSections.signout;
            }
          },); 
          },
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children:[
           Expanded(
            child: Icon(
              icon,
              size: 20,
              color: Colors.black,)
              ),
          Expanded(
            flex: 3,
            child: Text(
              title, 
              style: TextStyle(
                color: Colors.black,
                 fontSize: 16),
                    ),
          ),
        ],
      ),
      ),
   ),
  );
}
}

enum DrawerSections{
  // ignore: constant_identifier_names
  user_profile,
  dashboard,
  // ignore: constant_identifier_names
  detect_alzheimer,
  // ignore: constant_identifier_names
  know_alzheimer,
  rating,
  map,
  signout
}