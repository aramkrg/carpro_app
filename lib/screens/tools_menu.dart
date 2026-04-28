import 'package:flutter/material.dart';
import '../core/theme.dart';
import 'utilities/vin_history_screen.dart';
import 'utilities/traffic_fines_screen.dart';
import 'utilities/wallet_screen.dart';
import 'utilities/feedback_screen.dart';
import 'utilities/settings_screen.dart';

class ToolsMenu extends StatelessWidget {
  const ToolsMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeManager.active;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tools & Utilities'),
        elevation: 0,
        backgroundColor: theme.bg,
        foregroundColor: theme.primary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _toolCard(
            context: context,
            icon: Icons.document_scanner,
            title: 'VIN History',
            subtitle: 'Check vehicle history reports',
            color: Colors.blue,
            screen: const VINHistoryScreen(),
          ),
          const SizedBox(height: 12),
          _toolCard(
            context: context,
            icon: Icons.traffic,
            title: 'Traffic Fines',
            subtitle: 'Check outstanding fines',
            color: Colors.orange,
            screen: const TrafficFinesScreen(),
          ),
          const SizedBox(height: 12),
          _toolCard(
            context: context,
            icon: Icons.wallet,
            title: 'Wallet',
            subtitle: 'Manage balance & transactions',
            color: Colors.green,
            screen: const WalletScreen(),
          ),
          const SizedBox(height: 12),
          _toolCard(
            context: context,
            icon: Icons.feedback,
            title: 'Feedback',
            subtitle: 'Report issues or suggest improvements',
            color: Colors.purple,
            screen: const FeedbackScreen(),
          ),
          const SizedBox(height: 12),
          _toolCard(
            context: context,
            icon: Icons.settings,
            title: 'Settings',
            subtitle: 'Manage preferences & account',
            color: Colors.red,
            screen: const SettingsScreen(),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _toolCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required Widget screen,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => screen),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}
