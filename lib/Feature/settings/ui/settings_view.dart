import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:herbal_app/Feature/authentication/bloc/auth_bloc.dart';
import 'package:herbal_app/Feature/settings/bloc/settings_bloc.dart';
import 'package:herbal_app/Feature/authentication/ui/form_create_seller.dart';

// Models
class SettingsMenuItem {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Color? titleColor;

  SettingsMenuItem({
    required this.icon,
    required this.title,
    this.onTap,
    this.trailing,
    this.titleColor,
  });
}

// Settings Screen
class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Utama'),
            _buildMainSection(),
            const SizedBox(height: 24),
            _buildSectionHeader('Bantuan'),
            _buildHelpSection(),
            const SizedBox(height: 24),
            _buildVersionInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 16, 32, 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildMainSection() {
    final items = [
      SettingsMenuItem(
        icon: Icons.person_outline,
        title: 'Akun & Profil',
        onTap: () => _navigateToPage('Akun & Profil'),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      ),
      SettingsMenuItem(
        icon: Icons.people_outline,
        title: 'Ganti/Tambah Role Akun',
        onTap: () => _showRoleBottomSheet(),
      ),
      SettingsMenuItem(
        icon: Icons.notifications_outlined,
        title: 'Notifikasi',
        onTap: () => _navigateToPage('Notifikasi'),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      ),
      SettingsMenuItem(
        icon: Icons.dark_mode_outlined,
        title: 'Mode Tampilan',
        trailing: Switch(
          value: isDarkMode,
          onChanged: (value) {
            setState(() {
              isDarkMode = value;
            });
          },
          activeColor: Colors.black,
        ),
      ),
      SettingsMenuItem(
        icon: Icons.lock_outline,
        title: 'Keamanan & Privasi',
        onTap: () => _navigateToPage('Keamanan & Privasi'),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      ),
      SettingsMenuItem(
        icon: Icons.apps_outlined,
        title: 'Tentang Aplikasi',
        onTap: () => _navigateToPage('Tentang Aplikasi'),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      ),
      SettingsMenuItem(
        icon: Icons.exit_to_app,
        title: 'Keluar Akun',
        titleColor: Colors.red,
        onTap: () => _showLogoutDialog(),
      ),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return Column(
            children: [
              _buildMenuItem(item),
              if (index < items.length - 1)
                const Divider(height: 1, indent: 64),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildHelpSection() {
    final item = SettingsMenuItem(
      icon: Icons.person_outline,
      title: 'Hubungi Kami',
      onTap: () => _navigateToPage('Hubungi Kami'),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: _buildMenuItem(item),
    );
  }

  Widget _buildMenuItem(SettingsMenuItem item) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: item.titleColor == Colors.red
                    ? Colors.red.withOpacity(0.1)
                    : Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                item.icon,
                size: 20,
                color: item.titleColor ?? Colors.green,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                item.title,
                style: TextStyle(
                  fontSize: 16,
                  color: item.titleColor ?? Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (item.trailing != null) item.trailing!,
          ],
        ),
      ),
    );
  }

  

  Widget _buildVersionInfo() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Versi Aplikasi 1.0',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  void _navigateToPage(String pageName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Navigasi ke: $pageName')),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Keluar Akun'),
        content: const Text('Apakah Anda yakin ingin keluar dari akun?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Berhasil keluar')),
              );
            },
            child: const Text(
              'Keluar',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
  void _showRoleBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const RoleSelectionBottomSheet(),
    );
  }
}

class RoleSelectionBottomSheet extends StatelessWidget {
  const RoleSelectionBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.green[700],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          _buildRoleOption(
            context,
            icon: Icons.storefront,
            title: 'Akun Penjual',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider<AuthBloc>(
                    create: (context) => AuthBloc(),
                    child: const SellerProfileFormScreen(),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildRoleOption(
            context,
            icon: Icons.local_florist,
            title: 'Akun Praktisi Herbal',
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Form Akun Praktisi Herbal (Coming Soon)'),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildRoleOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.green,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}