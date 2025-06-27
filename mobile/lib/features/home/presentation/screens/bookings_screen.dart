import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({Key? key}) : super(key: key);

  @override
  State<BookingsScreen> get createState => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> upcomingBookings = [
    {
      'property': 'Modern Apartment',
      'checkIn': '2025-07-01',
      'checkOut': '2025-07-10',
      'status': 'Confirmed',
    },
    {
      'property': 'Sea View Studio',
      'checkIn': '2025-08-15',
      'checkOut': '2025-08-20',
      'status': 'Confirmed',
    },
  ];

  final List<Map<String, dynamic>> pastBookings = [
    {
      'property': 'Cozy Loft',
      'checkIn': '2025-05-10',
      'checkOut': '2025-05-15',
      'status': 'Completed',
    },
    {
      'property': 'Countryside House',
      'checkIn': '2025-04-01',
      'checkOut': '2025-04-07',
      'status': 'Completed',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Header with Tabs
          Container(
            color: Colors.white,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Text(
                        'Bookings',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                TabBar(
                  controller: _tabController,
                  labelColor: AppTheme.primaryColor,
                  unselectedLabelColor: AppTheme.greyColor,
                  indicatorColor: AppTheme.primaryColor,
                  tabs: const [
                    Tab(text: 'Upcoming'),
                    Tab(text: 'Past'),
                  ],
                ),
              ],
            ),
          ),

          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBookingsList(true),
                _buildBookingsList(false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingsList(bool isUpcoming) {
    final bookings = isUpcoming ? upcomingBookings : pastBookings;

    if (bookings.isEmpty) {
      return const Center(
        child: Text('No bookings found.'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.home_outlined),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        booking['property'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      booking['status'],
                      style: TextStyle(
                        color: isUpcoming ? AppTheme.primaryColor : AppTheme.greyColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Check-in: ${booking['checkIn']}'),
                Text('Check-out: ${booking['checkOut']}'),
                const SizedBox(height: 8),
                if (isUpcoming)
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to booking details
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                    ),
                    child: const Text('View Details'),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
