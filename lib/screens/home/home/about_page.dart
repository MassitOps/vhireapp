import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'À propos de V-Hire',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "L'application mobile V-hire est une plateforme de location de véhicules qui vise à simplifier le processus de location pour les clients tout en offrant une solution de suivi et de sécurité.Notre application met en lien nos clients et divers entreprises spécialisées dans le domaine.",
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 20.0),
              Text(
                'À propos des développeurs de V-hire',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
              ),
              SizedBox(height: 10.0),
              Text(
                'Membres du groupe N°  \n\n'
                'ADJOVI Ruben\n'
                'AHISSOU Marth-Massit\n'
                'AVALLA Onésime\n'
                'QUENUM Daryl\n'
                'TOHON Aristot\n'
                "WEDJANGNON O'Neil\n"
                'ZIME YERIMA Akiil\n',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 15.0),
              Text(
                'Technologies utilisées',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
              ),
              SizedBox(height: 10.0),
              Text(
                'Front End : Framework Flutter\n'
                'Services Backend : Firebase SDK\n'
                'Base de données et hébergement : CloudFirestore\n',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 15.0),
              ListTile(
                leading: Icon(Icons.mail),
                title: Text('Notre repertoire GitHub'),
                subtitle: Text('https://github.com/Onesimeav/vhireapp'),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
