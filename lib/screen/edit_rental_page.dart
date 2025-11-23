import 'package:car_rental_app/data/db/rental_dao.dart';
import 'package:car_rental_app/data/model/rental_model.dart';
import 'package:car_rental_app/data/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditRentalPage extends StatefulWidget {
  final RentalModel rental;
  final UserModel user;

  const EditRentalPage({
    super.key,
    required this.rental,
    required this.user,
  });

  @override
  State<EditRentalPage> createState() => _EditRentalPageState();
}

class _EditRentalPageState extends State<EditRentalPage> {
  final _formKey = GlobalKey<FormState>();
  final _rentalDao = RentalDao();
  late TextEditingController _carNameController;
  late TextEditingController _renterNameController;
  late TextEditingController _rentalDaysController;
  
  DateTime? _startDate;
  DateTime? _endDate;
  int _totalPrice = 0;
  int _pricePerDay = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    
    // Initialize controllers with data from rental
    _carNameController = TextEditingController(text: widget.rental.carName);
    _renterNameController = TextEditingController(text: widget.rental.renterName);
    _rentalDaysController = TextEditingController(text: widget.rental.rentalDays.toString());
    
    // Set dates
    _startDate = widget.rental.startDate;
    _endDate = widget.rental.endDate;
    
    // Cost calculation
    _totalPrice = widget.rental.totalPrice;
    _pricePerDay = widget.rental.totalPrice ~/ widget.rental.rentalDays;
  }

  @override
  void dispose() {
    _carNameController.dispose();
    _renterNameController.dispose();
    _rentalDaysController.dispose();
    super.dispose();
  }

  void _calculateTotal() {
    if (_rentalDaysController.text.isNotEmpty) {
      final days = int.tryParse(_rentalDaysController.text) ?? 0;
      setState(() {
        _totalPrice = days * _pricePerDay;
        
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
      initialDate: _startDate ?? DateTime.now(),
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

  Future<void> _updateRental() async {
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

      // Konfirmasi
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Konfirmasi Perubahan'),
          content: const Text('Apakah Anda yakin ingin menyimpan perubahan?'),
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
              child: const Text('Simpan'),
            ),
          ],
        ),
      );

      if (confirm != true) return;

      setState(() => _isLoading = true);

      try {
        // Update rental di database
        final updatedRental = RentalModel(
          id: widget.rental.id,
          userId: widget.rental.userId,
          carId: widget.rental.carId,
          carName: _carNameController.text,
          renterName: _renterNameController.text,
          rentalDays: int.parse(_rentalDaysController.text),
          startDate: _startDate!,
          endDate: _endDate!,
          totalPrice: _totalPrice,
          status: widget.rental.status,
          createdAt: widget.rental.createdAt,
        );

        await _rentalDao.update(updatedRental);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Penyewaan berhasil diperbarui!'),
              backgroundColor: Colors.green,
            ),
          );

          Navigator.pop(context, true); // Return true untuk refresh detail page
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal memperbarui: $e'),
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
        title: const Text('Edit Penyewaan'),
        backgroundColor: const Color(0xff605EA1),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
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
                  const Icon(
                    Icons.edit,
                    size: 60,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Edit Data Penyewaan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'ID Transaksi: #${widget.rental.id?.toString().padLeft(4, '0')}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
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
                      'Informasi Penyewaan',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Car Name
                    TextFormField(
                      controller: _carNameController,
                      enabled: !_isLoading,
                      decoration: InputDecoration(
                        labelText: 'Nama Mobil',
                        hintText: 'Masukkan nama mobil',
                        prefixIcon: const Icon(Icons.directions_car),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama mobil tidak boleh kosong';
                        }
                        return null;
                      },
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
                          fillColor: _isLoading ? Colors.grey[200] : Colors.white,
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

                    // Price Info Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Harga per Hari',
                                style: TextStyle(fontSize: 14),
                              ),
                              Text(
                                'Rp ${NumberFormat('#,###', 'id_ID').format(_pricePerDay)}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Lama Sewa',
                                style: TextStyle(fontSize: 14),
                              ),
                              Text(
                                '${_rentalDaysController.text.isEmpty ? 0 : _rentalDaysController.text} hari',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

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
                        children: [
                          const Text(
                            'Total Pembayaran',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
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
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _isLoading
                                ? null
                                : () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.grey[700],
                              side: BorderSide(color: Colors.grey[400]!),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Batal'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _updateRental,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff605EA1),
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: Colors.grey,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Simpan',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ],
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
}