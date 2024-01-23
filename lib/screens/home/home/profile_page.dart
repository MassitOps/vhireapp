import 'package:flutter/material.dart';
import 'package:vhireapp/models/user.dart';
import 'package:vhireapp/screens/home/home/about_page.dart';
import 'package:vhireapp/screens/wrapper.dart';
import 'package:vhireapp/services/authentication.dart';
import 'package:vhireapp/shared/error.dart';


class ProfilePage extends StatefulWidget {

  final AuthenticatedUser user;

  const ProfilePage({super.key, required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  final AuthService _auth = AuthService();
  late String _displayedFirstname;
  late String _displayedLastName;
  late String _displayedEmail;
  int _currentBodyIndex = 0;
  bool isModifying = false;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController _lastnameController = TextEditingController();
  TextEditingController _firstnameController = TextEditingController();
  TextEditingController _idcardController = TextEditingController();
  TextEditingController _licenseIDController = TextEditingController();
  RegExp _regex = RegExp(r'^[0-9A-Z]{10,14}$');
  String? _gender;
  Map<String, String?> _vals = {};

  @override
  void initState() {
    super.initState();
    if(widget.user.firstname == null) {
      _displayedFirstname = "John";
    } else {
      _displayedFirstname = widget.user.firstname!;
      _firstnameController = TextEditingController(text: widget.user.firstname);
    }
    if(widget.user.lastname == null) {
      _displayedLastName = "Doe";
    } else {
      _displayedLastName = widget.user.lastname!;
      _lastnameController = TextEditingController(text: widget.user.lastname);
    }
    if(widget.user.email == null) {
      _displayedEmail = "johndoe@gmail.com";
    } else {
      _displayedEmail = widget.user.email!;
    }
    if(widget.user.idcard != null) {
      _idcardController = TextEditingController(text: widget.user.idcard);
    }
    if(widget.user.license_id != null) {
      _licenseIDController = TextEditingController(text: widget.user.license_id);
    }
    if(widget.user.gender != null) {
      if(widget.user.gender == "M") {
        _gender = "Masculin";
      } else {
        _gender = "Féminin";
      }
    }
  }

  void fillVals() {
    _vals["lastname"] = _lastnameController.text;
    _vals["firstname"] = _firstnameController.text;
    if(_idcardController.text=="") {
      _vals["idcard"] = null;
    } else {
      _vals["idcard"] = _idcardController.text;
    }
    if(_licenseIDController.text=="") {
      _vals["licenseidcard"] = null;
    } else {
      _vals["licenseidcard"] = _licenseIDController.text;
    }
    if(_gender=="Masculin") {
      _vals["gender"] = "M";
    } else if(_gender=="Féminin") {
      _vals["gender"] = "F";
    } else {
      _vals["gender"] = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF5371E9),
          title: const Text("Mon Profil", style: TextStyle(fontSize: 26)),
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


        body: Padding(
            padding: const   EdgeInsets.fromLTRB(0,10,0,0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const   EdgeInsets.fromLTRB(10, 0, 30, 0),
                        child: IconButton(
                          onPressed: () => {Navigator.pop(context)},
                          icon: const Icon(Icons.arrow_back),
                          iconSize: 35,
                        ),
                      )
                    ],
                  ),
                  Container(
                    width: 115,
                    height: 115,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(style: BorderStyle.solid, width: 2.5, color: Colors.black),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Center(
                        child: const Icon(Icons.person, size: 100, color: Colors.black)
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Text(_displayedLastName, style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 50),)
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Text(_displayedFirstname, style: const TextStyle(fontSize: 25),)
                  ),
                  !isModifying ? ElevatedButton.icon(
                    onPressed: () => setState(() => isModifying = true),
                    icon: const Icon(Icons.edit_note, color: Color(0x77000000)),
                    label: const Text("Modifier vos informations", style: TextStyle(color: Color(0x77000000))),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD3D3D3)),
                  ) : const SizedBox(),

                  isModifying ? Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Padding(
                            padding: const EdgeInsets.fromLTRB(25, 20, 25, 0),
                            child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: TextFormField(
                                      controller: _lastnameController,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Nom',
                                        fillColor: Colors.grey[200],
                                        filled: true,
                                      ),
                                      validator: (String? value) {
                                        return (value == null || value == "") ? "Ce champ est obligatoire": null;
                                      },
                                    )
                                )
                            )
                        ),
                        const SizedBox(height: 15),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: TextFormField(
                                controller: _firstnameController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Prénom',
                                  fillColor: Colors.grey[200],
                                  filled: true,
                                ),
                                validator: (String? value) {
                                  return (value == null || value == "") ? "Ce champ est obligatoire": null;
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: TextFormField(
                                  controller: _idcardController,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Numéro de carte d'identité",
                                      fillColor: Colors.grey[200],
                                      filled: true
                                  ),
                                  validator: (String? value){
                                    if((value!=null) && (value!="") && (!_regex.hasMatch(value))) {
                                      return "Ce champ ne respecte pas le format adapté";
                                    } else {
                                      return null;
                                    }
                                  }
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15,),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: TextFormField(
                                  controller: _licenseIDController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Numéro de permis de conduire",
                                    fillColor: Colors.grey[200],
                                    filled: true,
                                  ),
                                  validator: (String? value){
                                    if((value!=null) && (value!="") && (!_regex.hasMatch(value))) {
                                      return "Ce champ ne respecte pas le format adapté";
                                    } else {
                                      return null;
                                    }
                                  }
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15,),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 24.0),
                              child: DropdownButtonFormField(
                                style :const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Quel est votre sexe ?',
                                ),
                                value: _gender,
                                onChanged: (String? g) {
                                  setState(() {
                                    _gender = g;
                                  });
                                },
                                items: ['Masculin','Féminin'].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value, style: const TextStyle(color: Colors.black),),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30,),
                      ],
                    ),
                  ) : const SizedBox(),

                  isModifying ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: GestureDetector(
                      onTap: () {
                        if(formKey.currentState!.validate()) {
                          fillVals();
                          widget.user.update(
                              lastname: _vals["lastname"],
                              firstname: _vals["firstname"],
                              idcard: _vals["idcard"],
                              license_id: _vals["licenseidcard"],
                              gender: _vals["gender"]
                          );
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => ProfilePage(user: widget.user)));
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration( color: const Color(0xFF5371E9),
                            borderRadius: BorderRadius.circular(12)),
                        child: const Center(
                          child: Text(
                            "Modifier",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,),
                          ),
                        ),
                      ),
                    ),
                  ) : const SizedBox(),
                ],
              ),
            )
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









