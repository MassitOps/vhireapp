import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:vhireapp/models/comment.dart';
import 'package:vhireapp/models/user.dart';

class NewComment extends StatefulWidget {
  final AuthenticatedUser user;
  final String vehicleId;
  final VoidCallback onButtonPressed;

  const NewComment({Key? key, required this.user, required this.vehicleId, required this.onButtonPressed}) : super(key: key);

  @override
  _NewCommentState createState() => _NewCommentState();
}

class _NewCommentState extends State<NewComment> {
  final _formKey = GlobalKey<FormState>();
  String _content = '';
  double _rating = 4;

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Comment comment = Comment(
        id: '', // Firestore will automatically generate an ID
        user_id: widget.user.id,
        vehicle_id: widget.vehicleId,
        content: _content,
        created_at: Timestamp.now(),
        deleted_at: null,
        note: _rating,
        username: '${widget.user.lastname ?? ''} ${widget.user.firstname ?? ''}',
        // Concatenate firstname and lastname to create the username
      );
      await Comment.commentCollection.add(comment.toDocument());
      widget.onButtonPressed();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withOpacity(0.8),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                    decoration: InputDecoration(
                    labelText: 'Vôtre commentaire ici...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                      validator: (value) => value!.isEmpty ? "Entrez votre commentaire d'abord." : null,
                      onSaved: (value) => _content = value!,
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: _submit,
                    iconSize: 35,
                    color: const Color(0xFF5371E9),
                    icon: const Icon(Icons.send),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Row(
              children: [
                Text(
                  "                                  Vôtre note sur 5",
                  style: TextStyle(color: Colors.black, fontSize: 12),
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 20),
              child: Row(
                children: [
                  RatingBar.builder(
                    initialRating: _rating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 1),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      _rating = rating;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

