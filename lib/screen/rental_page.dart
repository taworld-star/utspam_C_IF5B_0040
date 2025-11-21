import 'package:car_rental_app/data/db/rental_dao.dart';
import 'package:car_rental_app/data/model/car_model.dart';
import 'package:car_rental_app/data/model/rental_model.dart';
import 'package:car_rental_app/data/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RentFormPage extends StatefulWidget {
  final CarModel car;
  final UserModel user;

  const RentFormPage({
    super.key,
    required this.car,
    required this.user,
  });

  @override
  State<RentFormPage> createState() => _RentFormPageState();
}

class _RentFormPageState extends State<RentFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _rentalDao = RentalDao();
  final _renterNameController = TextEditingController();
  final _rentalDaysController = TextEditingController();
  
  DateTime? _startDate;
  DateTime? _endDate;
  int _totalPrice = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _renterNameController.text = widget.user.name;
  }

  @override
  void dispose() {
    _renterNameController.dispose();
    _rentalDaysController.dispose();
    super.dispose();
  }

  void _calculateTotal() {
    if (_rentalDaysController.text.isNotEmpty) {
      final days = int.tryParse(_rentalDaysController.text) ?? 0;
      setState(() {
        _totalPrice = days * widget.car.pricePerDay;
        
        // Calculate end date
        if (_startDate != null) {
          _endDate = _startDate!.add(Duration(days: days));
        }
      });
    }
  }

  Future<void> _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xff605EA1),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked;
        _calculateTotal();
      });
    }
  }

  Future<void> _submitRental() async {
    if (_formKey.currentState!.validate()) {
      if (_startDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pilih tanggal mulai sewa!'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (_endDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tentukan lama sewa!'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      //Null check to user.id and car.id
      if (widget.user.id == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User ID tidak valid'),
            backgroundColor: Colors.red,
          ),
        );
      }

      if (widget.car.id == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Car ID tidak valid'),
            backgroundColor: Colors.red,
          )
        );
      }


       // Konfirmasi sebelum submit
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Konfirmasi Penyewaan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Mobil: ${widget.car.name}'),
              Text('Penyewa: ${_renterNameController.text}'),
              Text('Lama Sewa: ${_rentalDaysController.text} hari'),
              Text(
                'Total: Rp ${NumberFormat('#,###', 'id_ID').format(_totalPrice)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Apakah data sudah benar?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff605EA1),
                foregroundColor: Colors.white,
              ),
              child: const Text('Ya, Konfirmasi'),
            ),
          ],
        ),
      );

      if (confirm != true) return;

      setState(() => _isLoading = true);

      try {
        final rental = RentalModel(
          userId: widget.user.id!,
          carId: widget.car.id!,
          carName: widget.car.name,
          renterName: _renterNameController.text,
          rentalDays: int.parse(_rentalDaysController.text),
          startDate: _startDate!,
          endDate: _endDate!,
          totalPrice: _totalPrice,
        );

        await _rentalDao.insert(rental);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Penyewaan berhasil dibuat!'),
              backgroundColor: Colors.green,
            ),
          );

          Navigator.pop(context, true); // Return true to refresh homepage
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal membuat penyewaan: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Form Penyewaan'),
        backgroundColor: const Color(0xff605EA1),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Car Info Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xff605EA1),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: widget.car.image.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              widget.car.image,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.directions_car,
                                  size: 80,
                                  color: Colors.white,
                                );
                              },
                            ),
                          )
                        : const Icon(
                            Icons.directions_car,
                            size: 80,
                            color: Colors.white,
                          ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.car.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildCarSpec(Icons.calendar_today, '${widget.car.year}'),
                      const SizedBox(width: 16),
                      _buildCarSpec(Icons.airline_seat_recline_normal, '${widget.car.seats} Kursi'),
                      const SizedBox(width: 16),
                      _buildCarSpec(Icons.settings, widget.car.transmission),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Rp ${NumberFormat('#,###', 'id_ID').format(widget.car.pricePerDay)} / hari',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff605EA1),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Form
            Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Detail Penyewaan',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Renter Name
                    TextFormField(
                      controller: _renterNameController,
                      enabled: !_isLoading,
                      decoration: InputDecoration(
                        labelText: 'Nama Penyewa',
                        hintText: 'Masukkan nama penyewa',
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama penyewa tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Start Date
                    InkWell(
                      onTap: _isLoading ? null : _selectStartDate,
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Tanggal Mulai Sewa',
                          hintText: 'Pilih tanggal',
                          prefixIcon: const Icon(Icons.calendar_today),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: _isLoading ? Colors.grey[200] :Colors.white,
                        ),
                        child: Text(
                          _startDate != null
                              ? DateFormat('dd MMMM yyyy', 'id_ID').format(_startDate!)
                              : 'Pilih tanggal mulai',
                          style: TextStyle(
                            color: _startDate != null ? Colors.black : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Rental Days
                    TextFormField(
                      controller: _rentalDaysController,
                      enabled: !_isLoading,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Lama Sewa (hari)',
                        hintText: 'Masukkan jumlah hari',
                        prefixIcon: const Icon(Icons.event),
                        suffixText: 'hari',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onChanged: (value) => _calculateTotal(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Lama sewa tidak boleh kosong';
                        }
                        final days = int.tryParse(value);
                        if (days == null || days <= 0) {
                          return 'Lama sewa harus berupa angka positif';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // End Date (Auto calculated)
                    if (_endDate != null)
                      InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Tanggal Selesai Sewa',
                          prefixIcon: const Icon(Icons.event_available),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                        child: Text(
                          DateFormat('dd MMMM yyyy', 'id_ID').format(_endDate!),
                          style: const TextStyle(color: Colors.black87),
                        ),
                      ),

                    const SizedBox(height: 24),

                    // Total Price Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xff605EA1),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xff605EA1).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Total Pembayaran',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              'Rp ${NumberFormat('#,###', 'id_ID').format(_totalPrice)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submitRental,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff605EA1),
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: _isLoading
                            ? SizedBox(
                              height: 20,
                              width: 20,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Konfirmasi Penyewaan',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarSpec(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.white70),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}