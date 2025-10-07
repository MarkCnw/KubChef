import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Profile Header
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Guest User',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      'guest@kubchef.com',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Statistics Cards
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      context,
                      Icons.camera_alt,
                      '12',
                      'Scans',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      context,
                      Icons.bookmark,
                      '8',
                      'Saved',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      context,
                      Icons.restaurant,
                      '24',
                      'Cooked',
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Menu Items
          SliverList(
            delegate: SliverChildListDelegate([
              _buildSectionHeader(context, 'Account'),
              _buildMenuItem(
                context,
                Icons.person_outline,
                'Edit Profile',
                () => _showComingSoon(context),
              ),
              _buildMenuItem(
                context,
                Icons.notifications_outlined,
                'Notifications',
                () => _showComingSoon(context),
                trailing: Switch(value: true, onChanged: (val) {}),
              ),
              _buildMenuItem(
                context,
                Icons.language,
                'Language',
                () => _showComingSoon(context),
                subtitle: 'English',
              ),

              const SizedBox(height: 16),
              _buildSectionHeader(context, 'Preferences'),
              _buildMenuItem(
                context,
                Icons.dark_mode_outlined,
                'Dark Mode',
                () {},
                trailing: Switch(value: false, onChanged: (val) {}),
              ),
              _buildMenuItem(
                context,
                Icons.restaurant_menu,
                'Dietary Preferences',
                () => _showComingSoon(context),
              ),
              _buildMenuItem(
                context,
                Icons.timer_outlined,
                'Default Cooking Time',
                () => _showComingSoon(context),
                subtitle: '30 minutes',
              ),

              const SizedBox(height: 16),
              _buildSectionHeader(context, 'Support'),
              _buildMenuItem(
                context,
                Icons.help_outline,
                'Help Center',
                () => _showComingSoon(context),
              ),
              _buildMenuItem(
                context,
                Icons.info_outline,
                'About',
                () => _showAboutDialog(context),
              ),
              _buildMenuItem(
                context,
                Icons.privacy_tip_outlined,
                'Privacy Policy',
                () => _showComingSoon(context),
              ),

              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: OutlinedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Sign Out'),
                        content: const Text(
                          'Are you sure you want to sign out?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          FilledButton(
                            onPressed: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Signed out'),
                                ),
                              );
                            },
                            child: const Text('Sign Out'),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Sign Out'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    foregroundColor: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    IconData icon,
    String value,
    String label,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap, {
    String? subtitle,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: trailing != null ? null : onTap,
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('This feature is coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Kub Chef',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.restaurant, size: 48),
      children: [
        const Text(
          'Scan ingredients and discover delicious recipes powered by AI.',
        ),
      ],
    );
  }
}
