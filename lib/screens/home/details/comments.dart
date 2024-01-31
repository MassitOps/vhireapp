import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vhireapp/models/comment.dart';
import 'package:vhireapp/models/reservation.dart';
import 'package:vhireapp/models/user.dart';
import 'package:vhireapp/screens/home/catalog/product_box.dart';
import 'package:vhireapp/screens/home/details/add_comment.dart';
import 'package:vhireapp/shared/loading.dart';


class CommentsPage extends StatefulWidget {

  final String vehicle_id;
  final AuthenticatedUser user;
  final VoidCallback onButtonPressed;
  const CommentsPage({super.key, required this.user, required this.vehicle_id, required this.onButtonPressed});

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {

  List<Comment> comments = [];
  bool _isLoading = true;
  bool _canComment = true;

  Future<void> loadComments() async {
    setState(() => _isLoading = true );
    comments = await Comment.getCommentByVehicleID(widget.vehicle_id);
    comments.sort((Comment a, Comment b) => b.created_at.compareTo(a.created_at));
    _canComment = await Reservation.haveOnceAtLeastHiredThisVehicle(widget.vehicle_id, widget.user.id);
    setState(() => _isLoading = false );
  }

  @override
  void initState() {
    super.initState();
    loadComments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (!_isLoading) ? comments.isNotEmpty ? Stack(
        children: [
          const Center(),
          Positioned(
            top: 0,
            bottom: kBottomNavigationBarHeight - 1,
            left: 0,
            right: 0,
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Column(
                          children: comments.map((Comment comment) {
                            return (comment.deleted_at == null) ? Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: const Color(0x55419CE1),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            CircleAvatar(
                                              radius: 25,
                                              backgroundColor: Color(0xFF57DC90),
                                            ),
                                            const SizedBox(width: 5,),
                                            Expanded(
                                              child: Container(
                                                alignment: Alignment.centerLeft,
                                                padding: const EdgeInsets.only(top: 14),
                                                child: Text(
                                                  comment.username,
                                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                                  textAlign: TextAlign.center,
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 4,),
                                        Text(
                                          comment.content!,
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                        const SizedBox(height: 4,),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              ProductStarsRow(note: comment.note!),
                                              Text(DateFormat("dd/MM/yy HH:mm").format(comment.created_at.toDate()), style: TextStyle(color: Colors.black45, fontSize: 12),),
                                            ]
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10,), // Add space between each comment widget
                              ],
                            ) : const SizedBox();
                          }).toList(),
                        )
                    ),

                  ],
                ),
              ),
            ),
          ),
          _canComment ? Positioned(
            bottom: 5,
            left: 0,
            right: 0,
            child: NewComment(user: widget.user, vehicleId: widget.vehicle_id, onButtonPressed: widget.onButtonPressed,),
          ) : const Positioned(
              bottom: 5,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text("Seules les personnes ayant loué ce véhicule peuvent laisser un commentaire.",
                  style: TextStyle(color: Color(0xFFDC5757), fontSize: 15),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
              )
          ),
        ],
      )
        : Stack(
          children: [
            const Center(child: Text("Aucun Commentaire\n\n\n\n", style: TextStyle(fontSize: 20))),
            _canComment ? Positioned(
              bottom: 5,
              left: 0,
              right: 0,
              child: NewComment(user: widget.user, vehicleId: widget.vehicle_id, onButtonPressed: widget.onButtonPressed,),
            ) : const Positioned(
                  bottom: 5,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text("Seules les personnes ayant loué ce véhicule peuvent laisser un commentaire.",
                      style: TextStyle(color: Color(0xFFDC5757), fontSize: 15),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  )
            ),
          ],
        )
          : const Loading(),
    );
  }
}
