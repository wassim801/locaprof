import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/providers.dart';
import '../../data/providers/property_provider.dart';
class ProprietaireStatisticsScreen extends ConsumerStatefulWidget {
  const ProprietaireStatisticsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ProprietaireStatisticsScreen> createState() => _ProprietaireStatisticsScreenState();
}

class _ProprietaireStatisticsScreenState extends ConsumerState<ProprietaireStatisticsScreen> {
  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    try {
      final provider = ref.read(propertyProvider.notifier);
      final statistics = await provider.getPropertyStatistics();
      ref.read(propertyStatsProvider.notifier).state = statistics;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors du chargement des statistiques: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
final statisticsState = ref.watch(mockPropertyStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistiques'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadStatistics,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadStatistics,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatisticCard(
                'Propriétés',
                statisticsState['totalProperties']?.toString() ?? '0',
                Icons.home,
                Colors.blue,
              ),
              _buildStatisticCard(
                'Propriétés louées',
                statisticsState['rentedProperties']?.toString() ?? '0',
                Icons.check_circle,
                Colors.green,
              ),
              _buildStatisticCard(
                'Propriétés disponibles',
                statisticsState['availableProperties']?.toString() ?? '0',
                Icons.real_estate_agent,
                Colors.orange,
              ),
              _buildStatisticCard(
                'Revenu mensuel total',
                '${statisticsState['totalMonthlyIncome']?.toString() ?? '0'}€',
                Icons.euro,
                Colors.purple,
              ),
              const SizedBox(height: 20),
              _buildPropertyTypeDistribution(statisticsState['propertyTypes'] ?? {}),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    value,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyTypeDistribution(Map<String, dynamic> typeDistribution) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Distribution par type',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            ...typeDistribution.entries.map((entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              entry.key,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          Text(
                            '${entry.value}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4.0),
                      LinearProgressIndicator(
  value: entry.value / typeDistribution.values.fold(0, (int sum, dynamic value) => sum + (value as int)),
  backgroundColor: Colors.grey[200],
  valueColor: AlwaysStoppedAnimation<Color>(
    Colors.blue[400]!,
  ),
),

                      
                    ],
                  ),
                  
                )),
          ],
        ),
      ),
    );
  }
}