import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vhireapp/models/comment.dart';
import 'package:vhireapp/models/user.dart';

class NewComment extends StatefulWidget {
  final AuthenticatedUser user;
  final String vehicleId;

  const NewComment({Key? key, required this.user, required this.vehicleId}) : super(key: key);

  @override
  _NewCommentState createState() => _NewCommentState();
}

class _NewCommentState extends State<NewComment> {
  final _formKey = GlobalKey<FormState>();
  String _content = '';
  double _rating = 0.0;

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
        username: (widget.user.firstname ?? '') + ' ' + (widget.user.lastname ?? ''),
        // Concatenate firstname and lastname to create the username
      );
      await Comment.commentCollection.add(comment.toDocument());
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Comment'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'Content'),
              validator: (value) => value!.isEmpty ? 'Please enter some text' : null,
              onSaved: (value) => _content = value!,
            ),
            Slider(
              value: _rating,
              min: 0,
              max: 5,
              divisions: 5,
              label: _rating.round().toString(),
              onChanged: (double value) => setState(() => _rating = value),
            ),
            ElevatedButton(
              onPressed: _submit,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

