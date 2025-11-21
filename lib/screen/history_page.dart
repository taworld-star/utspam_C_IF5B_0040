import 'package:car_rental_app/data/db/db_helper.dart';
import 'package:car_rental_app/data/model/rental_model.dart';
import 'package:car_rental_app/data/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'rental_detail_page.dart';
import 'home_page.dart';

class HistoryPage extends StatefulWidget {
  final UserModel user;

  const HistoryPage({super.key, required this.user});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<RentalModel> _rentals = [];
  bool _isLoading = true;
  String _filterStatus = 'all'; // all, active, completed, cancelled

  @override
  void initState() {
    super.initState();
    _loadRentals();
  }

  Future<void> _loadRentals() async {
    setState(() => _isLoading = true);
    
    try {
      List<RentalModel> rentals;
      
      if (_filterStatus == 'active') {
        rentals = await DatabaseHelper.instance.getActiveRentals(widget.user.id!);
      } else {
        rentals = await DatabaseHelper.instance.getRentalsByUser(widget.user.id!);
        
        if (_filterStatus != 'all') {
          rentals = rentals.where((r) => r.status == _filterStatus).toList();
        }
      }
      
      setState(() {
        _rentals = rentals;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Riwayat Sewa'),
        backgroundColor: const Color(0xff605EA1),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(user: widget.user),
                ),
              );
            },
            tooltip: 'Kembali ke Beranda',
          ),
        ],
      ),
      body: Column(
        children: [
          // Header dengan statistik
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
                const Text(
                  'Total Transaksi',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_rentals.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Filter chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('Semua', 'all'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Aktif', 'active'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Selesai', 'completed'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Dibatalkan', 'cancelled'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // List of rentals
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _rentals.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.history,
                              size: 80,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Belum ada riwayat sewa',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomePage(user: widget.user),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.add),
                              label: const Text('Sewa Mobil Sekarang'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff605EA1),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadRentals,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: _rentals.length,
                          itemBuilder: (context, index) {
                            return _buildRentalCard(_rentals[index]);
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(user: widget.user),
            ),
          );
        },
        backgroundColor: const Color(0xff605EA1),
        icon: const Icon(Icons.add),
        label: const Text('Sewa Baru'),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _filterStatus == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _filterStatus = value;
          _loadRentals();
        });
      },
      selectedColor: const Color(0xff605EA1),
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildRentalCard(RentalModel rental) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // Push (bukan pushReplacement) agar bisa kembali
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RentalDetailPage(
                rental: rental,
                user: widget.user,
              ),
            ),
          ).then((_) => _loadRentals()); // Refresh saat kembali
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Car name & Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      rental.carName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(rental.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _getStatusColor(rental.status),
                      ),
                    ),
                    child: Text(
                      _getStatusText(rental.status),
                      style: TextStyle(
                        color: _getStatusColor(rental.status),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Renter name
              Row(
                children: [
                  Icon(Icons.person, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    rental.renterName,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Rental period
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    '${DateFormat('dd MMM yyyy', 'id_ID').format(rental.startDate)} - ${DateFormat('dd MMM yyyy', 'id_ID').format(rental.endDate)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Duration
              Row(
                children: [
                  Icon(Icons.event, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    '${rental.rentalDays} hari',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
              
              const Divider(height: 24),

              // Total price
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Biaya',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    'Rp ${NumberFormat('#,###', 'id_ID').format(rental.totalPrice)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff605EA1),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}