import 'package:flutter/material.dart';

class SuccessCash extends StatefulWidget {
  const SuccessCash({super.key});

  @override
  State<SuccessCash> createState() => _SuccessCashState();
}

class _SuccessCashState extends State<SuccessCash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF5371E9),
        title: const Text("Payement à la récupération", style: TextStyle(fontSize: 20)),
        centerTitle: true,
        iconTheme: const IconThemeData(size: 32, color: Colors.white),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Réservation effectuée avec succès.'),
          const SizedBox(
            height: 10,
            width: double.infinity,
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF5371E9))
            ),
            child: const Text('Retour au catalogue'),
          ),
        ],
      ),
    );
  }
}
