import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Vehicle {

  static final CollectionReference vehicleCollection = FirebaseFirestore.instance.collection("vehicles");

  final String id;
  final String agency_id;
  late String brand;
  late String model;
  late String type;
  late int price;
  late String status;
  late Timestamp? limit_date;
  late double note;
  late String img;
  late String? img_url;
  late String? agency_name;

  // Constructor
  Vehicle({
    required this.id,
    required this.agency_id,
    required this.brand,
    required this.model,
    required this.type,
    required this.price,
    required this.status,
    this.limit_date,
    required this.note,
    required this.img,
    this.agency_name
  }) {
    img_url = null;
    getImageURL();
  }

  factory Vehicle.fromDocumentSnapshot(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    Vehicle vehicle = Vehicle(
      id: document.id,
      agency_id: data["agency_id"],
      brand: data["brand"],
      model: data["model"],
      type: data["type"],
      price: data["price"].toInt(),
      status: data["status"],
      note: data["note"].toDouble(),
      img: data["img"],
      limit_date: data["limit_date"]
    );
    vehicle.getImageURL();
    vehicle.getAgencyName();
    return vehicle;
  }

  Future getImageURL() async {
    try {
      img_url = await FirebaseStorage.instance.ref().child("vehicles").child(type).child(img).getDownloadURL();
    } on FirebaseException catch(e) {
      //return CustomError(e.code, e.message!);
      null;
    }
  }

  Future getAgencyName() async {
    try {
      Map<String, dynamic>? data = (await FirebaseFirestore.instance.collection("agencies").doc(agency_id).get()).data();
      agency_name = data?["name"];
    } on FirebaseException catch(e) {
      //return CustomError(e.code, e.message!);
      null;
    }
  }

  static Future getVehiclesByType(String type) async {
    QuerySnapshot querySnapshot = await vehicleCollection.where("type", isEqualTo: type).get();
    List<Vehicle> vehiclesList = querySnapshot.docs.map((QueryDocumentSnapshot document) => Vehicle.fromDocumentSnapshot(document)).toList();
    return vehiclesList;
  }

  static Future toHireOrFreeVehicle(String id, String status) async {
    vehicleCollection.doc(id).update({"status": status});
  }

}
