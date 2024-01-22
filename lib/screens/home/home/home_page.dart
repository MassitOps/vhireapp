import 'package:flutter/material.dart';
import 'package:vhireapp/models/user.dart';
import 'package:vhireapp/models/vehicle.dart';
import 'package:vhireapp/screens/home/catalog/catalog_page.dart';
import 'package:vhireapp/screens/home/home/profile_page.dart';
import 'package:vhireapp/screens/home/home/about_page.dart';
import 'package:vhireapp/screens/wrapper.dart';
import 'package:vhireapp/services/authentication.dart';
import 'package:vhireapp/shared/error.dart';

class HomePage extends StatefulWidget {

  late AuthenticatedUser user;
  late Map<String, List<Vehicle>> map;

  HomePage({super.key, required this.user, required this.map});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final AuthService _auth = AuthService();
  int _currentBodyIndex = 0;
  late String _displayedFirstname;
  late String _displayedLastName;
  late String _displayedEmail;

  @override
  void initState() {
    super.initState();
    if(widget.user.firstname == null) {
      _displayedFirstname = "John";
    } else {
      _displayedFirstname = widget.user.firstname!;
    }
    if(widget.user.lastname == null) {
      _displayedLastName = "Doe";
    } else {
      _displayedLastName = widget.user.lastname!;
    }
    if(widget.user.email == null) {
      _displayedEmail = "johndoe@gmail.com";
    } else {
      _displayedEmail = widget.user.email!;
    }
  }

  @override
  Widget build(BuildContext context) {

    Widget buildRoundedButton(String label, String iconPath) {
      return Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: ElevatedButton(
            onPressed: () {
              if(label.trim() == "Voiture") {
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => Catalog(user: widget.user, categorie: "Voiture", list: widget.map["car"]!)));
              } else if(label.trim() == "Moto") {
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => Catalog(user: widget.user, categorie: "Moto", list: widget.map["bike"]!)));
              } else if(label.trim() == "Camion") {
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => Catalog(user: widget.user, categorie: "Camion", list: widget.map["truck"]!)));
              } else {
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => Catalog(user: widget.user, categorie: "Bus", list: widget.map["bus"]!)));
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.only(left: 12, bottom: 12, right: 12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.asset(iconPath, width: 30, height: 40),
                const SizedBox(height: 7),
                Text(
                  label,
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Accueil', style: TextStyle(fontSize: 26)),
        centerTitle: true,
        iconTheme: const IconThemeData(size: 32, color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, size: 32,),
            onPressed: () {},
          ),
          const SizedBox(width: 10)
        ],
        backgroundColor: const Color(0xFF5371E1),
      ),


      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                const SizedBox(height: 25),
                Image.asset("assets/images/home/vhirelogo.png", scale: 1.5),
                const SizedBox(height: 25),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  height: 85,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildRoundedButton('Voiture', 'assets/images/home/car.png'),
                      buildRoundedButton('  Moto  ', 'assets/images/home/motorcycle.png'),
                      buildRoundedButton('Camion', 'assets/images/home/truck.png'),
                      buildRoundedButton('   Bus   ', 'assets/images/home/bus.png'),
                    ],
                  ),
                ),
                Stack(
                  children: [
                    Positioned(
                      left: -80,
                      top: 80,
                      child: Transform.rotate(
                        angle: 334 * 3.141592653589793238462 / 180,
                        child: Image.asset("assets/images/mini_fond.png", width: 560,)
                      )
                    ),
                    Positioned(
                      child: Image.asset("assets/images/home/main_car.png")
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),


      drawer: Drawer(width: MediaQuery.of(context).size.width * 0.65,
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFF5371E9)),
              child: GestureDetector(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ProfilePage(user: widget.user))),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Container(
                        width: 55,
                        height: 55,
                        decoration: BoxDecoration(
                          color: const Color(0xFF5371E9),
                          border: Border.all(style: BorderStyle.solid, width: 2.5, color: Colors.white),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Center(
                          child: const Icon(Icons.person, size: 40, color: Colors.white)
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 45, 0, 0),
                          child: SizedBox(
                            width: 125,
                            child: Text(
                              "$_displayedLastName $_displayedFirstname",
                              style: const TextStyle(color: Colors.white, fontSize: 20),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
                          child: SizedBox(
                            width: 125,
                            child: Text(
                              _displayedEmail,
                              style: const TextStyle(color: Colors.white, fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(
                  top: 15,
                ),
                child: Column(
                  // shows the list of menu drawer
                  children: [
                    menuItem(0, "Accueil", Icons.home, (_currentBodyIndex == 0) ? true : false),
                    menuItem(1, "Réservations", Icons.layers, (_currentBodyIndex == 1) ? true : false),
                    menuItem(2, "Service client", Icons.support_agent, (_currentBodyIndex == 2) ? true : false),
                    menuItem(3, "Déconnexion", Icons.exit_to_app, (_currentBodyIndex == 3) ? true : false),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => AboutPage()));
                      },
                      icon: Icon(Icons.info_outline),
                      iconSize: 33,
                    )
                ),
              ],
            )
          ],
        )
      ),
    );
  }

  Widget menuItem(int id, String title, IconData icon, bool selected) {
    return Material(
      color: selected ? const Color(0xFF419CE1) : Colors.transparent,
      child: InkWell(
        onTap: () async {
          Navigator.pop(context);
          if(id!=3) {
            setState(() {
              _currentBodyIndex = id;
            });
          } else {
            dynamic result = await _auth.signOut();
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => const Wrapper()));
            if(result is CustomError) {
              debugPrint(result.message);
            }
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(10.10),
          child: Row(
            children: [
              Expanded(
                child: Icon(
                  icon,
                  size: 30,
                  color: Colors.black,
                ),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
