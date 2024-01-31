import 'package:flutter/material.dart';
import 'package:vhireapp/models/reservation.dart';
import 'package:vhireapp/models/user.dart';

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
    setState(() => _isLoading = false );
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
        child: Center(
          child: _isLoading
              ? CircularProgressIndicator()
              : SingleChildScrollView(
            child: Column(
              children: reservations.map((reservation) => ListTile(
                title: Text('Vehicle ID: ${reservation.vehicle_id}'),
                subtitle: Text('Status: ${reservation.status}'),
              )).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
