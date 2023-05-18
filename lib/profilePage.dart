import 'package:flutter/material.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import './homeMenu.dart';
import './QuizPage.dart';
import './settingPage.dart';
import './flashcardpage.dart';



class profile extends StatefulWidget {
  const profile({Key? key}) : super(key: key);

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  int _currentIndex = 2;

  void _onItemTapped(int index){
    setState(() {
      _currentIndex = index;
    });
    if(_currentIndex == 0){
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeMenu())
      );
    }else if(_currentIndex == 1){
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => CreateQuizPage())
      );
    }else if(_currentIndex == 2){
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => profile()));
    }

  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        extendBody: true,
        bottomNavigationBar: Container(
            decoration: BoxDecoration(),
            child: SizedBox(
              height: 100,
              child: FloatingNavbar(
                backgroundColor: Colors.white,

                selectedItemColor: Colors.blue.shade700,
                // new line
                borderRadius: 40,
                onTap: _onItemTapped,
                currentIndex: _currentIndex,
                unselectedItemColor: Colors.grey,
                iconSize: 33,
                fontSize: 15,
                items: [
                  FloatingNavbarItem(icon: Icons.home, title: 'Home'),
                  FloatingNavbarItem(icon: Icons.menu_book, title: 'Quiz'),
                  FloatingNavbarItem(icon: Icons.person, title: 'Profile'),
                ],
              ),
            )),

        // start of the app
        //let me die please

        backgroundColor: Colors.blue.shade100,
        body: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 75,
              ),

              Stack(
                children: <Widget>[
                     Container(
                      height: 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(25 )),
                          // image: DecorationImage(
                          //     image: NetworkImage(
                          //       'https://i.pinimg.com/564x/8f/54/e8/8f54e830cd9e28ad73d51cf5f6901c80.jpg',
                          //     ),
                          //     fit: BoxFit.fill)

                        color: Colors.blue
                      ),
                  ),


                  
                  Container(
                    height: 50,
                    alignment: Alignment.bottomCenter,
                    child: Text('Profile',
                    style: TextStyle(
                      fontSize: 20
                    ),),
                  ),

                  Container(
                    height: 60,
                    width: 350,
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      icon: Icon(Icons.settings) ,
                      onPressed: (){
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) => setting()));
                      },
                    ),
                  ),

                  Container(
                    height: 210,
                    alignment: Alignment.bottomCenter,
                    child: CircleAvatar(

                      backgroundColor: Colors.blue,
                      radius: 53,

                      child: CircleAvatar(
                        backgroundImage: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQY6g_gUCSBFSeGKgDyeQC9DZ4pbJZbN2rk7CzJ-0CD62oCZz2_WlZBXPSyZg904cGqXYM&usqp=CAU'
                        ),

                        radius: 50,
                      ),

                    ),
                  )



                ],
              ),
            SizedBox(height: 20,),

            Container(
                width:  MediaQuery.of(context).size.width,
                height: 350,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25)
                ),
                child:Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(

                        children: [
                          Icon(Icons.email_outlined),
                          SizedBox(width: 5,),
                          Text('Email')
                        ],
                      ),

                      Padding(padding: EdgeInsets.all(10),
                        child: Text(
                            'usernam123@gmail.com'
                        ),),

                      Divider(
                        thickness: 2,
                      ),

                      //mobile
                      Row(

                        children: [
                          Icon(Icons.phone),
                          SizedBox(width: 5,),
                          Text('Cellphone')
                        ],
                      ),

                      Padding(padding: EdgeInsets.all(10),
                        child: Text(
                            '1 123 456 7890'
                        ),),

                      Divider(
                        thickness: 2,
                      ),

                      //School
                      Row(

                        children: [
                          Icon(Icons.home_filled),
                          SizedBox(width: 5,),
                          Text('School')
                        ],
                      ),

                      Padding(padding: EdgeInsets.all(10),
                        child: Text(
                            'College Vanier'
                        ),),

                      Divider(
                        thickness: 2,
                      ),

                      //program
                      Row(

                        children: [
                          Icon(Icons.school_outlined),
                          SizedBox(width: 5,),
                          Text('Major')
                        ],
                      ),

                      Padding(padding: EdgeInsets.all(10),
                        child: Text(
                            'Computer Science And Technology'
                        ),),

                      Divider(
                        thickness: 2,
                      ),

                    ],
                  ),
                )

                ),



              //email


            ],
          ),
        ),
    );
  }
}
