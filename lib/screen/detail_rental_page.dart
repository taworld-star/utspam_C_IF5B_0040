import 'package:car_rental_app/data/db/db_helper.dart';
import 'package:car_rental_app/data/model/rental_model.dart';
import 'package:car_rental_app/data/model/user_model.dart';
import 'package:flutter/material.dart';

class DetailRentalPage extends StatefulWidget {
  final RentalModel rental;
  final UserModel user;

  const DetailRentalPage({
    super.key,
    required this.rental,
    required this.user,
    });

  @override
  State<DetailRentalPage> createState() => _DetailRentalPageState();
}

class _DetailRentalPageState extends State<DetailRentalPage> {
  late RentalModel _rental;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _rental = widget.rental;
  }

  Future<void> _refreshRental()  async {
    try {
      final updated = await DatabaseHelper.instance.getRentalById(_rental.id!);
      if (updated != null) {
        setState(() {
          _rental = updated;
        });
      }
    } catch (e) {
      
    }
  }


  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}