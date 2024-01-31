import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vhireapp/models/reservation.dart';
import 'package:vhireapp/models/user.dart';
import 'package:vhireapp/screens/home/catalog/product_box.dart';
import 'package:vhireapp/models/vehicle.dart';
import 'package:vhireapp/screens/home/details/comments.dart';
import 'package:vhireapp/screens/home/details/confirm_reservation_page.dart';
import 'package:vhireapp/screens/home/details/geolocation.dart';
import 'package:vhireapp/screens/home/home/profile_page.dart';
import 'package:vhireapp/screens/home/home/about_page.dart';
import 'package:vhireapp/screens/wrapper.dart';
import 'package:vhireapp/services/authentication.dart';
import 'package:vhireapp/shared/error.dart';
import 'package:vhireapp/screens/home/home/reservation.dart';


class ReservationScreen extends StatefulWidget {

  late Vehicle vehicle;
  late AuthenticatedUser user;

  ReservationScreen({super.key, required this.vehicle, required this.user});

  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {

  final AuthService _auth = AuthService();
  late String _displayedFirstname;
  late String _displayedLastName;
  late String _displayedEmail;
  int _currentBodyIndex = 0;
  late String limitDateShown;
  String error = " ";
  int _currentIndex = 1;
  DateTime now = DateTime.now();
  late DateTime startDate;
  late DateTime endDate;

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: (widget.vehicle.limit_date == null) ? DateTime(2050) : widget.vehicle.limit_date!.toDate(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xFF5371E9),
            colorScheme: const ColorScheme.light(primary: Color(0xFF5371E9)),
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
      cancelText: "ANNULER",
      confirmText: "VALIDER",
    );

    if (picked != null && picked != startDate) {
      setState(() {
        startDate = picked;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate.add(const Duration(days: 1)),
      firstDate: startDate.add(const Duration(days: 1)),
      lastDate: (widget.vehicle.limit_date == null) ? DateTime(2050) : widget.vehicle.limit_date!.toDate(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xFF5371E9),
            colorScheme: const ColorScheme.light(primary: Color(0xFF5371E9)),
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
      cancelText: "ANNULER",
      confirmText: "VALIDER",
    );

    if (picked != null && picked != endDate) {
      setState(() {
        endDate = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    limitDateShown = (widget.vehicle.limit_date == null) ? "\u221E" : DateFormat("dd/MM/yy").format(widget.vehicle.limit_date!.toDate());
    startDate = DateTime(now.year, now.month, now.day);
    endDate = startDate.add(const Duration(days: 1));
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

  void _onButtonPressed() {
    setState(() {
      _currentIndex = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF5371E9),
        title: const Text("Réservation", style: TextStyle(fontSize: 26)),
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

      body: (_currentBodyIndex == 0) ? (_currentIndex==0) ? WillPopScope(
        onWillPop: () async {
          setState(() => _currentIndex = 1);
          return false;
        },
        child: Column(
          children: [
            /*Row(
              children: [
                const SizedBox(width: 12),
                IconButton(
                  onPressed: () => setState(() => _currentIndex = 1),
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  iconSize: 35,
                )
              ],
            ),*/
            Expanded(
              child: Geolocation(agency_id: widget.vehicle.agency_id)
            ),
          ],
        ),
      ) :
      (_currentIndex==1) ? Stack(
        children: [
          ColorFiltered(
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.65), BlendMode.darken),
            child: Image.asset(
              "assets/images/background.png",
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            )
          ),
          Positioned(
            child: SingleChildScrollView(
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(25),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(Icons.arrow_back),
                            iconSize: 35,
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(right: 45),
                              child: Text(
                                "${widget.vehicle.agency_name}",
                                style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "${widget.vehicle.brand} ${widget.vehicle.model}",
                        style: const TextStyle(fontSize: 18, color: Color(0xFF419CE1)),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 5),
                      Stack(
                        children: [
                          Image.asset(
                            "assets/images/mini_fond.png",
                            scale: 1,
                          ),
                          Positioned(
                            top: 5,
                            left: 35,
                            child: (widget.vehicle.img_url==null) ? Image.asset(
                              "assets/images/default.png",
                              height: 135,
                              width: 215,
                            ) : Image.network(
                              widget.vehicle.img_url!,
                              height: 135,
                              width: 215,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 5),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ProductStarsRow(note: widget.vehicle.note, size: 24)
                        ],
                      ),
                      const SizedBox(height: 20),

                      Column(
                        children: [
                          Text(
                            "${NumberFormat.decimalPattern('fr').format(widget.vehicle.price)} FCFA",
                            style: const TextStyle(
                              fontSize: 24,
                              color: Colors.black,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'Journalier',
                            style: TextStyle(
                              fontSize: 22,
                              color: Color(0xFF419CE1),
                            ),
                          ),
                          const SizedBox(height: 10),
                          RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                  text: "Disponible jusqu'au: ",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: limitDateShown,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF419CE1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),

                      Text(error, style: const TextStyle(fontSize: 10, color: Color(0xFFDC5757))),
                      const SizedBox(height: 3),

                      SizedBox(
                        width: 250,
                        child: TextField(
                          readOnly: true,
                          onTap: () async => await _selectStartDate(context),
                          decoration: InputDecoration(
                            hintText: startDate != DateTime.now()
                                ? "Début de location: ${DateFormat('dd/MM/yy').format(startDate)}"
                                : 'Début de location',
                            contentPadding: const EdgeInsets.all(15),
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      SizedBox(
                        width: 250,
                        child: TextField(
                          readOnly: true,
                          onTap: () async => await _selectEndDate(context),
                          decoration: InputDecoration(
                            hintText: endDate != DateTime.now()
                                ? "Fin de location: ${DateFormat('dd/MM/yy').format(endDate)}"
                                : 'Fin de location',
                            contentPadding: const EdgeInsets.all(15),
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              if(startDate.isAfter(endDate)) {
                                setState(() {
                                  error = "Le date de fin ne peut pas être antérieure à celle de début";
                                });
                              } else {
                                setState(() => error = "");
                                Reservation reservation = Reservation(
                                  user_id: widget.user.id,
                                  vehicle_id: widget.vehicle.id,
                                  begin_at: Timestamp.fromDate(startDate),
                                  finish_at: Timestamp.fromDate(endDate.add(const Duration(seconds: 1))),
                                  vehicle_price: widget.vehicle.price
                                );
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => ConfirmReservation(reservation: reservation, user: widget.user, vehicle: widget.vehicle)));
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: const Color(0xFF57DC90),
                              ),
                              width: 140,
                              height: 40,
                              child: const Center(
                                child: Text(
                                  'Réserver',
                                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          )
                        ]
                      ),

                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ) :
      (_currentIndex==2) ?  WillPopScope(
        onWillPop: () async {
          setState(() => _currentIndex = 1);
          return false;
        },
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(width: 12),
                IconButton(
                  onPressed: () => setState(() => _currentIndex = 1),
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  iconSize: 35,
                )
              ],
            ),
            Expanded(
              child: CommentsPage(vehicle_id: widget.vehicle.id, user: widget.user, onButtonPressed: _onButtonPressed)
            ),
          ],
        ),
      ) : const SizedBox() : WillPopScope(
        onWillPop: () async {
          setState(() => _currentBodyIndex = 0);
          return false;
        },
        child: ReservationHistory(user: widget.user)
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

      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.location_on),
              label: "Géolocalisation"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.layers),
              label: "Reservation"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.comment),
              label: "Avis et Commentaires"
          )
        ],
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF5371E9),
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
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
