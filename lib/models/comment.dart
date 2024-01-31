import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {

  static final CollectionReference commentCollection = FirebaseFirestore.instance.collection("comments");

  final String id;
  final String user_id;
  final String vehicle_id;
  late String? content;
  final Timestamp created_at;
  late Timestamp? deleted_at;
  late double? note;
  late String username;

  // Constructor
  Comment({
    required this.id,
    required this.user_id,
    required this.vehicle_id,
    this.content,
    required this.created_at,
    this.deleted_at,
    this.note,
    required this.username
  });


  factory Comment.fromDocumentSnapshot(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    Comment comment = Comment(
        id: document.id,
        user_id: data["user_id"],
        vehicle_id: data["vehicle_id"],
        content: data["content"],
        created_at: data["created_at"],
        deleted_at: data["deleted_at"],
        note: data["note"].toDouble(),
        username: data["username"]
    );
    return comment;
  }

  Map<String, dynamic> toDocument() {
    return {
      'user_id': user_id,
      'vehicle_id': vehicle_id,
      'content': content,
      'created_at': created_at,
      'deleted_at': deleted_at,
      'note': note,
      'username': username,
    };
  }

  // get
  static Future getCommentByVehicleID(String vehicleID) async {
    QuerySnapshot querySnapshot = await commentCollection.where("vehicle_id", isEqualTo: vehicleID).get();
    List<Comment> commentList = querySnapshot.docs.map((QueryDocumentSnapshot document) => Comment.fromDocumentSnapshot(document)).toList();
    return commentList;
  }

}
