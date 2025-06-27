import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import 'favorites_screen.dart';
import 'bookings_screen.dart';
import 'messages_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    _ExploreTab(),
    const FavoritesScreen(),
    const BookingsScreen(),
    const MessagesScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: AppTheme.greyColor,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Bookings'),
          BottomNavigationBarItem(icon: Icon(Icons.message_outlined), label: 'Messages'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}

class _ExploreTab extends StatefulWidget {
  @override
  _ExploreTabState createState() => _ExploreTabState();  // Fixed
}

class _ExploreTabState extends State<_ExploreTab> {
  bool _showTotalPrice = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
            // Top Bar with Welcome Tour
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('Replay welcome tour'),
                    style: TextButton.styleFrom(foregroundColor: AppTheme.secondaryColor),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.dashboard_outlined),
                    onPressed: () => Navigator.pushNamed(context, '/proprietaire/dashboard'),
                    color: AppTheme.secondaryColor,
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Start your search',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.tune),
                    onPressed: () {},
                  ),
                ),
              ),
            ),

            // Categories
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _buildCategoryItem('Tiny homes', Icons.home_outlined),
                  _buildCategoryItem('Icons', Icons.castle_outlined),
                  _buildCategoryItem('Lakefront', Icons.water_outlined),
                  _buildCategoryItem('Treehouses', Icons.forest_outlined),
                  _buildCategoryItem('Top cities', Icons.location_city_outlined),
                ],
              ),
            ),

            // Map Image
            Container(
              height: 200,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
                image: const DecorationImage(
                  image: AssetImage('../assets/images/map12.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Total Price Toggle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Text('Display total price'),
                  const Spacer(),
                  Switch(
                    value: _showTotalPrice,
                    onChanged: (value) => setState(() => _showTotalPrice = value),
                    activeColor: AppTheme.primaryColor,
                  ),
                ],
              ),
            ),

            // Property List will go here
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: 10, // Replace with actual data
                itemBuilder: (context, index) {
                  return const PropertyCard();
                },
              ),
            ),
          ],
        ),
      );
  }

  Widget _buildCategoryItem(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(right: 24),
      child: Column(
        children: [
          Icon(icon, color: AppTheme.secondaryColor),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class PropertyCard extends StatelessWidget {
  const PropertyCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Property Image
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  '../assets/images/houseee.jpg',
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 300,
                      width: double.infinity,
                      color: Colors.grey[200],
                      child: const Icon(Icons.image_not_supported, size: 50),
                    );
                  },
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: IconButton(
                  icon: const Icon(Icons.favorite_border),
                  onPressed: () {},
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Property Details
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
              const Text(
                'Berkeley Springs, West Virginia',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Row(
                children: const [
                  Icon(Icons.star, size: 16),
                  Text('4.99'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            '\$289/night',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}