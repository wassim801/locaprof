import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class HostProfileScreen extends StatelessWidget {
  const HostProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage('https://example.com/host.jpg'),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ozlem',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: const [
                          Icon(Icons.star, size: 16),
                          SizedBox(width: 4),
                          Text('289'),
                          Text(' reviews'),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: const [
                          Icon(Icons.verified_user, size: 16, color: AppTheme.primaryColor),
                          SizedBox(width: 4),
                          Text('Identity verified'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Divider(),

            // Host Stats
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatItem('4.98★', 'Rating'),
                  const SizedBox(height: 16),
                  _buildStatItem('3', 'Years hosting'),
                  const SizedBox(height: 16),
                  _buildStatItem('Superhost', 'Status'),
                ],
              ),
            ),

            const Divider(),

            // About Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'About',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildAboutItem(Icons.design_services, "I'm obsessed with Interior Design"),
                  const SizedBox(height: 12),
                  _buildAboutItem(Icons.pets, 'Pets: Leo, 7 yr old cockapoo. We love dogs!'),
                  const SizedBox(height: 16),
                  const Text(
                    'My name is Ozlem. I live in Northern VA with my husband and our sweet cockapoo Leo. My sister and I fell in love with Dreamtime Cabin and decided to fix it up ourselves and redesign it from the ground up ourselves...',
                    style: TextStyle(fontSize: 16),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Read more'),
                  ),
                ],
              ),
            ),

            const Divider(),

            // Follow Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Follow our journey @Dreamtimestays',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: AppTheme.lightGreyColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text('Social Media Feed Placeholder'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: AppTheme.greyColor),
        ),
      ],
    );
  }

  Widget _buildAboutItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}