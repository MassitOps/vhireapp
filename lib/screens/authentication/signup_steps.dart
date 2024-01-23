import 'package:flutter/material.dart';
import 'package:vhireapp/models/user.dart';
import 'package:vhireapp/screens/home/home/await_get_user.dart';

class SignupSteps extends StatefulWidget {

  late AuthenticatedUser user;

  SignupSteps({super.key, required this.user});

  @override
  State<SignupSteps> createState() => _SignupStepsState();
}

class _SignupStepsState extends State<SignupSteps> {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _idcardController = TextEditingController();
  final TextEditingController _licenseIDController = TextEditingController();
  final RegExp _regex = RegExp(r'^[0-9A-Z]{10,14}$');
  String? _gender;
  Map<String, String?> _vals = {};
  
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
      backgroundColor: Colors.grey[300],

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center ,
            children: [
              const SizedBox(height: 22,),
              Image.asset("assets/images/vhire.png", scale: 5),
              const SizedBox(height: 16,),
              //Welcome section
              const Text("Inscription", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 36)),
              const SizedBox(height:10,),
              const Text('Entrez vos informations', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 30,),
              Form(
                key: formKey,
                child: Column(
                children: [
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
              ),

              Padding(
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
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (BuildContext context) => GetUpdateUserBeforeHome(user: widget.user)));
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration( color: const Color(0xFF5371E9),
                        borderRadius: BorderRadius.circular(12)),
                    child: const Center(
                      child: Text(
                        "Suivant",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,),
                      ),
                    ),
                  ),
                ),
              ),

          ]
        )
      ),
      ),

    );
  }
}
