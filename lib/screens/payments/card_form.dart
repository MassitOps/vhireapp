import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:vhireapp/models/reservation.dart';
import 'package:vhireapp/models/user.dart';
import 'package:vhireapp/models/vehicle.dart';
import 'package:vhireapp/shared/global.dart';
import 'package:vhireapp/shared/loading.dart';

import '/bloc/bloc.dart';

class CardScreen extends StatefulWidget {

  late Reservation reservation;
  late AuthenticatedUser user;

  CardScreen({super.key, required this.user, required this.reservation});

  @override
  State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: const Color(0xFF5371E9),
        title: const Text("Payement Carte de Crédit", style: TextStyle(fontSize: 20)),
        centerTitle: true,
        iconTheme: const IconThemeData(size: 32, color: Colors.white),
      ),

      body: BlocBuilder<PaymentBloc, PaymentState>(
        builder: (context, state) {
          CardFormEditController controller = CardFormEditController(
            initialDetails: state.cardFieldInputDetails,
          );

          if (state.status == PaymentStatus.initial) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Formulaire de payement',
                      style: TextStyle(fontSize: 26),
                    ),
                    const SizedBox(height: 20),
                    Container(color: Colors.grey[600],child: CardFormField(controller: controller)),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        (controller.details.complete)
                            ? context.read<PaymentBloc>().add(
                          PaymentCreateIntent(
                            billingDetails: const BillingDetails(
                              email: 'avallaonesime@gmail.com',
                            ),
                            items: [
                              {'id': widget.reservation.montant},
                            ],
                          ),
                        )
                            : ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Le formulaire n'est pas rempli."),
                          ),
                        );
                      },
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF5371E9))
                      ),
                      child: const Text('Payer'),
                    ),
                  ],
                ),
              ),
            );
          }
          if (state.status == PaymentStatus.success) {
            String myVarText = "${GlobalVar.myVar}";
            final match = RegExp(r'id: (pi_[^,]+)').firstMatch(myVarText);
            widget.reservation.transaction_id = match?.group(1)!;
            widget.reservation.store();
            Vehicle.toHireOrFreeVehicle(widget.reservation.vehicle_id, 'hired');
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Paiement effectué avec succès.'),
                const SizedBox(
                  height: 10,
                  width: double.infinity,
                ),
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
            );
          }
          if (state.status == PaymentStatus.failure) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Paiement échoué.'),
                const SizedBox(
                  height: 10,
                  width: double.infinity,
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<PaymentBloc>().add(PaymentStart());
                  },
                  style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF5371E9))
                  ),
                  child: const Text('Essayer à nouveau'),
                ),
              ],
            );
          } else {
            return const Center(child: Loading());
          }
        },
      ),
    );
  }
}
