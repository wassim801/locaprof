import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  // MOCK DATA
  final List<Map<String, String>> mockFavorites = const [
    {
      'title': 'Modern Apartment',
      'details': '3 rooms - 75m² - Paris',
    },
    {
      'title': 'Cozy Studio',
      'details': '1 room - 30m² - Lyon',
    },
    {
      'title': 'Family House',
      'details': '5 rooms - 120m² - Marseille',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final bool hasFavorites = mockFavorites.isNotEmpty;

    return SafeArea(
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: const [
                Text(
                  'Favorites',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // Favorites List
          if (hasFavorites)
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: mockFavorites.length,
                itemBuilder: (context, index) {
                  final favorite = mockFavorites[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      leading: const Icon(Icons.favorite, color: AppTheme.primaryColor),
                      title: Text(favorite['title']!),
                      subtitle: Text(favorite['details']!),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // Optional: Navigate to property details
                      },
                    ),
                  );
                },
              ),
            )
          else
            // Empty State
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.favorite_border,
                      size: 64,
                      color: AppTheme.greyColor,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No favorites yet',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppTheme.greyColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Start adding properties to your favorites',
                      style: TextStyle(
                        color: AppTheme.greyColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
