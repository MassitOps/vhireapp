import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vhireapp/models/reservation.dart';
import 'package:vhireapp/models/vehicle.dart';


class ReservationBox extends StatefulWidget {
  ReservationBox({Key? key, required this.reservation}) : super(key: key);

  final Reservation reservation;

  @override
  State<ReservationBox> createState() => _ReservationBoxState();
}

class _ReservationBoxState extends State<ReservationBox> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 25, left: 20, right: 20),
            child: Container(
              padding: EdgeInsets.zero,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF419CE1),
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 5),
                  Text("${widget.reservation.vehicle_name}",
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  Text("Du ${DateFormat("dd/MM/yy").format(widget.reservation.begin_at!.toDate())} Au ${DateFormat("dd/MM/yy").format(widget.reservation.finish_at!.toDate())}",
                    style: const TextStyle(color: Colors.white, fontSize: 17),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  Text(
                    "${NumberFormat.decimalPattern('fr').format(widget.reservation.montant)} FCFA", // Access reservation's price
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text("ID Payement: ${widget.reservation.transaction_id}",
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      if(widget.reservation.status == "finished") {
                        debugPrint("Réservation ${widget.reservation.id} déja terminée");
                      } else {
                        Vehicle.toHireOrFreeVehicle(widget.reservation.vehicle_id, 'free');
                        widget.reservation.finish_at = Timestamp.fromDate((widget.reservation.finish_at.toDate()).subtract(Duration(days: 1)));
                        widget.reservation.status = "finished";
                        FirebaseFirestore.instance.collection("reservations").doc(widget.reservation.id).update({'finish_at': widget.reservation.finish_at});
                        setState(() {});
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: (widget.reservation.status != "finished") ? const Color(0xFFDC5757) : Colors.grey[600],
                      ),
                      width: 100,
                      height: 25,
                      child: Center(
                        child: Text(
                          (widget.reservation.status != "finished") ? 'Annuler' : "Terminée",
                          style: const TextStyle(color: Colors.white, fontSize: 15),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
