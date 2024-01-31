import 'package:flutter/material.dart';
import 'package:vhireapp/models/user.dart';
import 'package:vhireapp/models/vehicle.dart';
import 'package:vhireapp/screens/home/catalog/product_box.dart';
import 'package:vhireapp/screens/home/home/profile_page.dart';
import 'package:vhireapp/screens/home/home/about_page.dart';
import 'package:vhireapp/screens/home/home/await_get_user.dart';
import 'package:vhireapp/screens/home/home/home_page.dart';
import 'package:vhireapp/screens/wrapper.dart';
import 'package:vhireapp/services/authentication.dart';
import 'package:vhireapp/shared/error.dart';
import 'package:vhireapp/screens/home/home/reservation.dart';


class Catalog extends StatefulWidget {

  final AuthenticatedUser user;
  final String categorie;
  late final String catPic;
  late List<Vehicle> list;

  Catalog({super.key, required this.categorie, required this.list, required this.user}) {
    if(categorie == "Voiture") {
      catPic = "lexus.png";
    } else if(categorie == "Moto") {
      catPic = "scooter.png";
    } else if(categorie == "Camion") {
      catPic = "dutro.png";
    } else {
      catPic = "volvo.png";
    }
  }

  @override
  State<Catalog> createState() => _CatalogState();
}

class _CatalogState extends State<Catalog> {

  final AuthService _auth = AuthService();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _minFilterController = TextEditingController();
  final TextEditingController _maxFilterController = TextEditingController();
  late List<Vehicle> filteredList;
  bool _hideFilter = true;
  double _searchBarWidth = 205;
  int _currentBodyIndex = 0;
  late String _displayedFirstname;
  late String _displayedLastName;
  late String _displayedEmail;

  @override
  void initState() {
    super.initState();
    filteredList = widget.list;
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

  List<Vehicle> search() {
    return widget.list.where((Vehicle vehicle) {
      bool nameMatches = (_searchController.text.isEmpty) ||
          (("${vehicle.brand} ${vehicle.model}").toLowerCase().contains(_searchController.text.toLowerCase())) ||
          (("${vehicle.model} ${vehicle.brand}").toLowerCase().contains(_searchController.text.toLowerCase()));
      return nameMatches;
    }).toList();
  }

  List<Vehicle> filter() {
    return widget.list.where((Vehicle vehicle) {
      int? minimum = int.tryParse(_minFilterController.text);
      int min = 0;
      (minimum == null) ? null : min = minimum;
      int? maximum = int.tryParse(_maxFilterController.text);
      int max = 100000000;
      (maximum == null) ? null : max = maximum;
      bool priceInRange = (vehicle.price >= min) && (vehicle.price <= max);
      return priceInRange;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
       backgroundColor: const Color(0xFF5371E9),
        title: const Text("Catalogue", style: TextStyle(fontSize: 26)),
        centerTitle: true,
        iconTheme: const IconThemeData(size: 32, color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, size: 32,),
            onPressed: () {},
          ),
          const SizedBox(width: 10)
        ],
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
                      //menuItem(2, "Service client", Icons.support_agent, (_currentBodyIndex == 2) ? true : false),
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

      body: (_currentBodyIndex == 0) ? WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => HomePage(user: widget.user, map: GetUpdateUserBeforeHome.map)));
          return false;
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child:  Padding(
              padding: const EdgeInsets.symmetric(vertical: 50.0),
              child: Column(
                children: [
                  // Image du véhicule
                  Image.asset("assets/images/${widget.catPic}", width: 120),
                  // Nom catégorie
                  Padding(
                    padding: const EdgeInsets.fromLTRB(70, 0, 0, 0),
                    child:Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => HomePage(user: widget.user, map: GetUpdateUserBeforeHome.map))),
                          icon: const Icon(Icons.arrow_back,color: Colors.black,size: 35,)
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30,5,0,0),
                          child: Text(
                            widget.categorie,
                            style: const TextStyle(fontSize: 25)),
                        ),
                      ],
                    )
                  ),

                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(60, 10, 0, 0),
                        child:  Container(
                          padding:  EdgeInsets.zero,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          width: _searchBarWidth,
                          height: 45,
                          child: SearchBar(
                            controller: _searchController,
                            elevation: MaterialStateProperty.all(0.0),
                            hintText: "Rechercher par marque",
                            hintStyle: MaterialStateProperty.all(const TextStyle(color: Colors.grey)),
                            constraints: BoxConstraints.tight(const Size(190, 50)),
                            onSubmitted: (String value) => setState(() => filteredList = search()),
                            onChanged: (String value) => setState(() => filteredList = search()),
                            trailing: [
                              IconButton(
                                onPressed: () => setState(() => filteredList = search()),
                                icon: const Icon(Icons.search, color: Color(0xFF57DC90)),
                              ),
                            ],
                          ),
                        )
                      ),

                      _hideFilter ? GestureDetector(
                        onTap: () => setState(() {
                          _hideFilter = false;
                          _searchBarWidth += 30;
                        }),
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                            child: Container(
                              padding:  EdgeInsets.zero,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black, // Set the border color
                                  width: 2.0, // Set the border width
                                ),
                                borderRadius: BorderRadius.circular(50.0), // Set the border radius
                              ),
                              width: 35,
                              height: 35,
                              child: const Icon(Icons.filter_list, size: 28),
                            )
                        ),
                      ) : const SizedBox(),
                    ],
                  ),

                  _hideFilter ? const SizedBox() : Row(
                    children: [
                      Padding(
                          padding: const EdgeInsets.fromLTRB(29, 10, 0, 0),
                          child:  Container(
                            padding:  EdgeInsets.zero,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            width: 146,
                            height: 45,
                            child: TextField(
                              controller: _minFilterController,
                              keyboardType: TextInputType.number, // Utilise un clavier numérique
                              decoration: const InputDecoration(
                                hintText: "Prix Minimum",
                                hintStyle: TextStyle(color: Colors.grey),
                                suffixIcon: Icon(Icons.filter_list, color: Color(0xFF57DC90)),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(left: 14, top: 8)
                              ),
                              onChanged: (String value) {
                                int? val = int.tryParse(value);
                                if((val == null) || (val < 0)) {
                                  setState(() => _minFilterController.text = "0");
                                }
                                setState(() => filteredList = filter());
                              },
                            )
                          )
                      ),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                          child:  Container(
                              padding:  EdgeInsets.zero,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              width: 146,
                              height: 45,
                              child: TextField(
                                controller: _maxFilterController,
                                keyboardType: TextInputType.number, // Utilise un clavier numérique
                                decoration: const InputDecoration(
                                    hintText: "Prix Maximum",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    suffixIcon: Icon(Icons.filter_list, color: Color(0xFF57DC90)),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(left: 14, top: 8)
                                ),
                                onChanged: (String value) {
                                  int? val = int.tryParse(value);
                                  if((val == null) || (val < 0)) {
                                    setState(() => _maxFilterController.text = "0");
                                  }
                                  setState(() => filteredList = filter());
                                },
                              )
                          )
                      ),
                    ],
                  ),


                  Column(
                    children: filteredList.map((Vehicle vehicule) {
                      return (vehicule.status == "free") ? ProductBox(vehicle: vehicule, user: widget.user) : const SizedBox();
                    }).toList(),
                  ),

                ],

              ),

            ),
          ),
        ),
      ) : WillPopScope(
        onWillPop: () async {
          setState(() => _currentBodyIndex = 0);
          return false;
        },
        child: ReservationHistory(user: widget.user)
      )
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
