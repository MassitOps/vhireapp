import 'package:cloud_firestore/cloud_firestore.dart';

class Agency {

  static final CollectionReference agencyCollection = FirebaseFirestore.instance.collection("agencies");

  final String id;
  late String name;
  late GeoPoint localisation;
  late double? note;

  // Constructor
  Agency({
    required this.id,
    required this.name,
    required this.localisation,
    this.note,
  });


  static Future getLocationFromID(String agencyID) async {
    GeoPoint location = const GeoPoint(0, 0);
    DocumentSnapshot documentSnapshot = await agencyCollection.doc(agencyID).get();
    if(documentSnapshot.exists) {
      dynamic data = documentSnapshot.data();
      location = (data==null) ? const GeoPoint(0, 0) : data["localisation"];
    }
    return location;
  }

}
