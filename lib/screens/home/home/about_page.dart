import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutPage extends StatelessWidget {

  const AboutPage({super.key});

  Future _launchURL(String url) async {
    if(await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw "Impossible de lancer $url";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF5371E9),
        title: const Text("À propos de V-Hire", style: TextStyle(fontSize: 26)),
        centerTitle: true,
        iconTheme: const IconThemeData(size: 32, color: Colors.white),
      ),

      body: Container(
        constraints: const BoxConstraints.expand(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset('assets/images/vhiremainlogo.png')
              ),
              const SizedBox(height: 16),
              const Text(
                "\u00a0\u00a0 L'application mobile V-hire est une plateforme de location de véhicules qui vise à simplifier le processus de location pour les clients tout en offrant une solution de suivi et de sécurité. Notre application met en lien nos clients et divers entreprises spécialisées dans le domaine.",
                style: TextStyle(fontSize: 16.0),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 25),
              const Text(
                'À propos des développeurs de V-hire',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
              ),
              const SizedBox(height: 10.0),
              const Text(
                'Membres du groupe N°9:\n\n'
                'ADJOVI Ruben\n'
                'AHISSOU Marth-Massit\n'
                'AVALLA Onésime\n'
                'QUENUM Daryl\n'
                'TOHON Aristot\n'
                "WEDJANGNON O'Neil\n"
                'ZIME YERIMA Akiil\n',
                style: TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 15.0),
              const Text(
                'Technologies utilisées',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
              ),
              const SizedBox(height: 10.0),
              const Text(
                'Front End : Framework Flutter\n'
                'Services Backend : Firebase SDK\n'
                'Base de données et hébergement : CloudFirestore\n',
                style: TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 15.0),
              ListTile(
                leading: Opacity(
                  opacity: 0.6,
                  child: Image.asset("assets/images/icons/github.png", height: 30, width: 30)
                ),
                title: const Text('Notre répertoire GitHub'),
                subtitle: const Text('https://github.com/Onesimeav/vhireapp'),
                onTap: () => _launchURL("https://github.com/Onesimeav/vhireapp.git"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
