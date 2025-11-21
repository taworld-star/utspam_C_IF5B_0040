import 'package:car_rental_app/data/db/db_helper.dart';
import 'package:car_rental_app/data/model/rental_model.dart';
import 'package:car_rental_app/data/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'edit_rental_page.dart'; // Import halaman edit

class DetailRentalPage extends StatefulWidget {
  final RentalModel rental;
  final UserModel user;

  const DetailRentalPage({
    super.key,
    required this.rental,
    required this.user,
  });

  @override
  State<DetailRentalPage> createState() => _RentalDetailPageState();
}

class _RentalDetailPageState extends State<DetailRentalPage> {
  late RentalModel _rental;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _rental = widget.rental;
  }

  Future<void> _refreshRental() async {
    try {
      final updated = await DatabaseHelper.instance.getRentalById(_rental.id!);
      if (updated != null) {
        setState(() {
          _rental = updated;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _cancelRental() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Pembatalan'),
        content: const Text(
          'Apakah Anda yakin ingin membatalkan penyewaan ini?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Tidak'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Ya, Batalkan'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);

    try {
      await DatabaseHelper.instance.updateRentalStatus(_rental.id!, 'cancelled');
      
      await _refreshRental();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Penyewaan berhasil dibatalkan'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal membatalkan: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'active':
        return 'Aktif';
      case 'completed':
        return 'Selesai';
      case 'cancelled':
        return 'Dibatalkan';
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'active':
        return Icons.directions_car;
      case 'completed':
        return Icons.check_circle;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Detail Penyewaan'),
        backgroundColor: const Color(0xff605EA1),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Status Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: _getStatusColor(_rental.status),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          _getStatusIcon(_rental.status),
                          size: 60,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _getStatusText(_rental.status),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'ID Transaksi: #${_rental.id?.toString().padLeft(4, '0')}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Detail Cards
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Car Info Card
                        _buildInfoCard(
                          title: 'Informasi Mobil',
                          icon: Icons.directions_car,
                          children: [
                            _buildInfoRow('Nama Mobil', _rental.carName),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Renter Info Card
                        _buildInfoCard(
                          title: 'Informasi Penyewa',
                          icon: Icons.person,
                          children: [
                            _buildInfoRow('Nama Penyewa', _rental.renterName),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Rental Period Card
                        _buildInfoCard(
                          title: 'Periode Sewa',
                          icon: Icons.calendar_today,
                          children: [
                            _buildInfoRow(
                              'Tanggal Mulai',
                              DateFormat('dd MMMM yyyy', 'id_ID').format(_rental.startDate),
                            ),
                            const Divider(),
                            _buildInfoRow(
                              'Tanggal Selesai',
                              DateFormat('dd MMMM yyyy', 'id_ID').format(_rental.endDate),
                            ),
                            const Divider(),
                            _buildInfoRow(
                              'Lama Sewa',
                              '${_rental.rentalDays} hari',
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Payment Info Card
                        _buildInfoCard(
                          title: 'Informasi Pembayaran',
                          icon: Icons.payment,
                          children: [
                            _buildInfoRow(
                              'Harga per Hari',
                              'Rp ${NumberFormat('#,###', 'id_ID').format(_rental.totalPrice ~/ _rental.rentalDays)}',
                            ),
                            const Divider(),
                            _buildInfoRow(
                              'Jumlah Hari',
                              '${_rental.rentalDays} hari',
                            ),
                            const Divider(),
                            _buildInfoRow(
                              'Total Pembayaran',
                              'Rp ${NumberFormat('#,###', 'id_ID').format(_rental.totalPrice)}',
                              isHighlight: true,
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Status Card
                        _buildInfoCard(
                          title: 'Status Penyewaan',
                          icon: Icons.info_outline,
                          children: [
                            _buildInfoRow(
                              'Status',
                              _getStatusText(_rental.status),
                            ),
                            const Divider(),
                            _buildInfoRow(
                              'Tanggal Transaksi',
                              DateFormat('dd MMMM yyyy, HH:mm', 'id_ID').format(_rental.createdAt),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Action Buttons
                        Column(
                          children: [
                            // Tombol Edit (hanya untuk status aktif)
                            if (_rental.status == 'active')
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditRentalPage(
                                          rental: _rental,
                                          user: widget.user,
                                        ),
                                      ),
                                    );

                                    // Refresh data jika ada perubahan
                                    if (result == true) {
                                      await _refreshRental();
                                    }
                                  },
                                  icon: const Icon(Icons.edit),
                                  label: const Text('Edit Sewa'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff605EA1),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),

                            if (_rental.status == 'active') const SizedBox(height: 12),

                            // Tombol Batalkan (hanya untuk status aktif)
                            if (_rental.status == 'active')
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: OutlinedButton.icon(
                                  onPressed: _cancelRental,
                                  icon: const Icon(Icons.cancel),
                                  label: const Text('Batalkan Sewa'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.red,
                                    side: const BorderSide(color: Colors.red),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),

                            if (_rental.status == 'active') const SizedBox(height: 12),

                            // Tombol Kembali ke Riwayat
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  Navigator.pop(context, true); // Return true untuk refresh history
                                },
                                icon: const Icon(Icons.arrow_back),
                                label: const Text('Kembali ke Riwayat'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xff605EA1),
                                  side: const BorderSide(color: Color(0xff605EA1)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xff605EA1)),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontSize: isHighlight ? 18 : 14,
                fontWeight: isHighlight ? FontWeight.bold : FontWeight.w500,
                color: isHighlight ? const Color(0xff605EA1) : Colors.black87,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}