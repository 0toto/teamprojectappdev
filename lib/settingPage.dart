import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';

// import './main.dart';

void main() {
  runApp(setting());
}

class setting extends StatefulWidget {
  const setting({Key? key}) : super(key: key);

  @override
  State<setting> createState() => _settingState();
}

class _settingState extends State<setting> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // start of the  bar
        extendBody: true,
        bottomNavigationBar: Container(
            decoration: BoxDecoration(
            ),
            child: SizedBox(
              height: 100,
              child: FloatingNavbar(
                backgroundColor: Colors.white,

                selectedItemColor: Colors.blue.shade700,
                // new line
                borderRadius: 40,
                onTap: (int val) {
                  setState(() {
                    _currentIndex = val;
                  });
                },
                currentIndex: _currentIndex,
                unselectedItemColor: Colors.grey,
                iconSize: 33,
                fontSize: 15,
                items: [
                  FloatingNavbarItem(icon: Icons.home, title: 'Home'),
                  FloatingNavbarItem(icon: Icons.person, title: 'Profile'),
                  FloatingNavbarItem(icon: Icons.settings, title: 'Setting'),
                ],
              ),
            )),

        // start of the app
        //let me die please

        backgroundColor: Colors.blue.shade100,
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                children: [

                  SizedBox(height: 60,),

                  Text('Settings', style: TextStyle(fontSize: 20),),

                  SizedBox(height: 20,),

                  //notifation
                  Container(
                    width: double.infinity, // This will make the container take up the full width of the screen
                    height: 40, // Set the height to 40
                    child: MaterialButton(
                      onPressed: () {
                        // Add your button logic here
                      },
                      child: _buildOneRow(Icons.notifications_none_sharp, "Notifications")
                    ),
                  ),

                  Divider(
                    thickness: 2, // Set the thickness of the line
                    color: Colors.grey, // Set the color of the line
                  ),

                  //time spend
                  Container(
                    width: double.infinity, // This will make the container take up the full width of the screen
                    height: 40, // Set the height to 40
                    child: MaterialButton(
                        onPressed: () {
                          // Add your button logic here
                        },
                        child: _buildOneRow(Icons.timer_outlined, "Time Spend")
                    ),
                  ),

                  Divider(
                    thickness: 2, // Set the thickness of the line
                    color: Colors.grey, // Set the color of the line
                  ),



                ],
              ),
            ),

          ),
        ),
      ),
    );
  }
}


_buildOneRow(IconData icon, String s){
  return
  Row(
    children: [
      Icon(icon, size: 30,),

      SizedBox(width: 10,),

      Text(s,
        style: TextStyle(
            fontSize: 22
        ),
      ),

      Spacer(),

      Icon(Icons.arrow_forward_ios_sharp, size: 22, ),


    ],
  );
}

