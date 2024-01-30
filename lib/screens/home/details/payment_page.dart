import "package:flutter/material.dart";
import "package:vhireapp/models/reservation.dart";
import "package:vhireapp/models/user.dart";
import "package:vhireapp/models/vehicle.dart";
import "package:vhireapp/screens/payments/card_form.dart";
import "package:vhireapp/screens/payments/cash_method_success.dart";

class PaymentPage0 extends StatefulWidget {

  late Reservation reservation;
  late AuthenticatedUser user;

  PaymentPage0({super.key, required this.reservation, required this.user});

  @override
  State<PaymentPage0> createState() => _PaymentPage0State();
}

class _PaymentPage0State extends State<PaymentPage0> {

  bool _isCashMethod = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF5371E9),
        title: const Text("Paiement", style: TextStyle(fontSize: 26)),
        centerTitle: true,
        iconTheme: const IconThemeData(size: 32, color: Colors.white),
      ),

      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          return false;
        },
        child: Container(
          constraints: const BoxConstraints.expand(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Image.asset('assets/images/vhire.png', width: 170, height: 170)
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20, top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 75,
                              height: 75,
                              padding: const EdgeInsets.all(3),
                              margin: const EdgeInsets.only(right: 15),
                              decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(15),
                                color: const Color(0x2257DC90)
                              ),
                              child: Image.asset("assets/images/payments/payement_cash.png"),
                            ),
                            const Flexible(
                              child: SizedBox(
                                child: Text("Payement à la récupération du véhicule",
                                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 15),
                              child: Transform.scale(
                                scale: 1.3,
                                child: Checkbox(
                                  fillColor: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
                                    if(states.contains(MaterialState.selected)) {
                                      return const Color(0xFF419CE1);
                                    }
                                    return Colors.white;
                                  }),
                                  value: _isCashMethod,
                                  onChanged: (bool? value) {
                                    setState(() => _isCashMethod = !_isCashMethod);
                                  }
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 75,
                              height: 75,
                              margin: const EdgeInsets.only(right: 15),
                              decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(15),
                                  color: const Color(0x2257DC90)
                              ),
                              child: Image.asset("assets/images/payments/payement_card.png"),
                            ),
                            const Flexible(
                              child: SizedBox(
                                child: Text("Carte de crédit",
                                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 15),
                              child: Transform.scale(
                                scale: 1.3,
                                child: Checkbox(
                                    fillColor: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
                                      if(states.contains(MaterialState.selected)) {
                                        return const Color(0xFF419CE1);
                                      }
                                      return Colors.white;
                                    }),
                                    value: !_isCashMethod,
                                    onChanged: (bool? value) {
                                      setState(() => _isCashMethod = !_isCashMethod);
                                    }
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 100),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      if(_isCashMethod) {
                        widget.reservation.store();
                        Vehicle.toHireOrFreeVehicle(widget.reservation.vehicle_id, 'hired');
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => SuccessCash()));
                      } else {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => CardScreen(reservation: widget.reservation, user: widget.user)));
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: const Color(0xDD5371E9),
                      ),
                      width: 140,
                      height: 40,
                      child: const Center(
                        child: Text(
                          'Suivant',
                          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
