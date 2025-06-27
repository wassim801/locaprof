import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> mockMessages = const [
    {
      'hostName': 'Alice Smith',
      'preview': 'Hi! Is the apartment still available?',
      'time': '10:45 AM',
      'unreadCount': 2,
    },
    {
      'hostName': 'John Doe',
      'preview': 'Thanks for confirming the booking!',
      'time': 'Yesterday',
      'unreadCount': 0,
    },
    {
      'hostName': 'Lina B.',
      'preview': 'Can we reschedule the visit?',
      'time': 'Mon',
      'unreadCount': 1,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Header with Search
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: const [
                    Text(
                      'Messages',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search messages',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
              ],
            ),
          ),

          // Messages List
          Expanded(
            child: mockMessages.isNotEmpty
                ? ListView.builder(
                    itemCount: mockMessages.length,
                    itemBuilder: (context, index) {
                      final message = mockMessages[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppTheme.primaryColor,
                          child: const Icon(Icons.person, color: Colors.white),
                        ),
                        title: Text(message['hostName']),
                        subtitle: Text(message['preview']),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              message['time'],
                              style: TextStyle(color: AppTheme.greyColor, fontSize: 12),
                            ),
                            const SizedBox(height: 4),
                            if (message['unreadCount'] > 0)
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '${message['unreadCount']}',
                                  style: const TextStyle(color: Colors.white, fontSize: 12),
                                ),
                              ),
                          ],
                        ),
                        onTap: () {
                          // Navigate to chat detail screen
                        },
                      );
                    },
                  )
                : _buildEmptyState(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.message_outlined,
            size: 64,
            color: AppTheme.greyColor,
          ),
          const SizedBox(height: 16),
          Text(
            'No messages yet',
            style: TextStyle(
              fontSize: 18,
              color: AppTheme.greyColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start a conversation with a host',
            style: TextStyle(
              color: AppTheme.greyColor,
            ),
          ),
        ],
      ),
    );
  }
}
