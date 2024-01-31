import 'package:cloud_firestore/cloud_firestore.dart';

class Reservation {

  static final CollectionReference reservationCollection = FirebaseFirestore.instance.collection("reservations");

  final String? id;
  final String user_id;
  final String vehicle_id;
  final Timestamp begin_at;
  late Timestamp finish_at;
  late String status;
  late int montant;
  late String? transaction_id;
  final int vehicle_price;

  // Constructor
  Reservation({
    this.id,
    required this.user_id,
    required this.vehicle_id,
    required this.begin_at,
    required this.finish_at,
    this.transaction_id,
    required this.vehicle_price
  }) {
    montant = finish_at.toDate().difference(begin_at.toDate()).inDays * vehicle_price;
    setStatus();
  }

  // to determine the actual status of the reservation
  void setStatus() {
    int compareBegin = begin_at.compareTo(Timestamp.fromDate(DateTime.now()));
    int compareFinish = Timestamp.fromDate(DateTime.now()).compareTo(finish_at);
    if(compareBegin > 0) {
      status = "waiting";
    } else if(compareFinish < 0) {
      status = "started";
    } else {
      status = "finished";
    }
  }

  // store a reservation
  Future store() async {
    Map<String, dynamic> data = {};
    data["user_id"] = user_id;
    data["vehicle_id"] = vehicle_id;
    data["begin_at"] = begin_at;
    data["finish_at"] = finish_at;
    data["transaction_id"] = transaction_id;
    data["vehicle_price"] = vehicle_price;
    await reservationCollection.add(data);
  }
  factory Reservation.fromDocument(DocumentSnapshot doc) {
    return Reservation(
      id: doc.id,
      user_id: doc['user_id'],
      vehicle_id: doc['vehicle_id'],
      begin_at: doc['begin_at'],
      finish_at: doc['finish_at'],
      transaction_id: doc['transaction_id'],
      vehicle_price: doc['vehicle_price'],
    );
  }
  static Future<List<Reservation>> getUserReservationHistory(String userId) async {
    QuerySnapshot querySnapshot = await reservationCollection.where('user_id', isEqualTo: userId).get();
    return querySnapshot.docs.map((doc) => Reservation.fromDocument(doc)).toList();
  }
}
