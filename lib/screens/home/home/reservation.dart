import 'package:flutter/material.dart';
import 'package:vhireapp/models/reservation.dart';
import 'package:vhireapp/models/user.dart';
import 'package:vhireapp/screens/home/home/reservation_box.dart';
import 'package:vhireapp/shared/loading.dart';
import 'dart:async';

class ReservationHistory extends StatefulWidget {
  final AuthenticatedUser user;
  const ReservationHistory({Key? key, required this.user}) : super(key: key);

  @override
  State<ReservationHistory> createState() => _ReservationHistoryState();
}

class _ReservationHistoryState extends State<ReservationHistory> {

  List<Reservation> reservations = [];
  bool _isLoading = true;

  Future<void> loadReservations() async {
    setState(() => _isLoading = true );
    reservations = await Reservation.getUserReservationHistory(widget.user.id);
    reservations.sort((Reservation a, Reservation b) => b.begin_at.compareTo(a.begin_at));
    reservations.sort((Reservation a, Reservation b) => b.finish_at.compareTo(a.finish_at));
    Future.delayed(const Duration(seconds: 3), () {
      setState(() => _isLoading = false );
    });
  }

  @override
  void initState() {
    super.initState();
    loadReservations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? const Loading()
            : SingleChildScrollView(
              child: Column(
                children: reservations.map((reservation) => ReservationBox(reservation: reservation,)).toList(),
              ),
            ),
          ),
    );
  }
}
