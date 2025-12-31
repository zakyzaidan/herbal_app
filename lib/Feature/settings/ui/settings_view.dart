// lib/Feature/settings/ui/settings_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:herbal_app/Feature/authentication/bloc/auth_bloc.dart';
import 'package:herbal_app/Feature/authentication/ui/login_view.dart';
import 'package:herbal_app/Feature/settings/bloc/settings_bloc.dart';
import 'package:herbal_app/Feature/authentication/ui/form_create_seller.dart';
import 'package:herbal_app/data/models/user_model.dart';

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
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ),
    );
  }

  void _navigateToPage(String pageName) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Navigasi ke: $pageName')));
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
              context.read<AuthBloc>().add(AuthLogoutRequested());
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Berhasil keluar')));
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const LoginPage();
                  },
                ),
              );
            },
            child: const Text('Keluar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showRoleBottomSheet() {
    // Ambil AuthBloc dari context saat ini
    final authBloc = context.read<AuthBloc>();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) => BlocProvider(
        create: (context) => SettingsBloc(),
        child: RoleSelectionBottomSheet(authBloc: authBloc),
      ),
    );
  }
}

class RoleSelectionBottomSheet extends StatelessWidget {
  final AuthBloc authBloc;

  const RoleSelectionBottomSheet({Key? key, required this.authBloc})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsBloc, SettingsState>(
      listener: (context, state) {
        if (state is RoleSwitchSuccess) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Berhasil switch ke role ${state.roleName}'),
              backgroundColor: Colors.green,
            ),
          );
          // Refresh auth state
          authBloc.add(AuthCheckRequested());
        } else if (state is SellerProfileCreated) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Berhasil membuat akun penjual!'),
              backgroundColor: Colors.green,
            ),
          );
          // Refresh auth state
          authBloc.add(AuthCheckRequested());
        } else if (state is PractitionerProfileCreated) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Berhasil membuat akun praktisi!'),
              backgroundColor: Colors.green,
            ),
          );
          // Refresh auth state
          authBloc.add(AuthCheckRequested());
        } else if (state is SettingsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, settingsState) {
        return BlocBuilder<AuthBloc, AuthState>(
          bloc: authBloc,
          builder: (context, authState) {
            if (authState is! AuthAuthenticated) {
              return const SizedBox();
            }

            final user = authState.user;
            final activeRole = user.activeRole;
            final isLoading = settingsState is SettingsLoading;

            return Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle indicator
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.green[700],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Title
                  Text(
                    'Kelola Role Akun',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Role aktif: ${activeRole?.roleName ?? "Tidak ada"}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),

                  // Loading indicator
                  if (isLoading)
                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(),
                    ),

                  // Role options based on active role
                  if (!isLoading) ..._buildRoleOptions(context, user),

                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        );
      },
    );
  }

  List<Widget> _buildRoleOptions(BuildContext context, UserModel user) {
    final activeRole = user.activeRole;
    final hasPenjualRole = user.hasRole('penjual');
    final hasPraktisiRole = user.hasRole('praktisi');

    List<Widget> options = [];

    // Jika role pengguna biasa aktif
    if (activeRole?.roleName.toLowerCase() == 'pengguna') {
      // Option untuk buat/switch ke penjual
      if (hasPenjualRole) {
        options.add(
          _buildRoleOption(
            context,
            icon: Icons.storefront,
            title: 'Switch ke Akun Penjual',
            subtitle: 'Beralih ke mode penjual',
            onTap: () {
              context.read<SettingsBloc>().add(SwitchRoleEvent('penjual'));
            },
          ),
        );
      } else {
        options.add(
          _buildRoleOption(
            context,
            icon: Icons.storefront,
            title: 'Buat Akun Penjual',
            subtitle: 'Daftar sebagai penjual produk herbal',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider.value(
                    value: authBloc,
                    child: const SellerProfileFormScreen(),
                  ),
                ),
              );
            },
          ),
        );
      }

      options.add(const SizedBox(height: 12));

      // Option untuk buat/switch ke praktisi
      if (hasPraktisiRole) {
        options.add(
          _buildRoleOption(
            context,
            icon: Icons.local_florist,
            title: 'Switch ke Akun Praktisi',
            subtitle: 'Beralih ke mode praktisi herbal',
            onTap: () {
              context.read<SettingsBloc>().add(SwitchRoleEvent('praktisi'));
            },
          ),
        );
      } else {
        options.add(
          _buildRoleOption(
            context,
            icon: Icons.local_florist,
            title: 'Buat Akun Praktisi Herbal',
            subtitle: 'Daftar sebagai praktisi herbal',
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Form Akun Praktisi Herbal (Coming Soon)'),
                ),
              );
            },
          ),
        );
      }
    }
    // Jika role penjual aktif
    else if (activeRole?.roleName.toLowerCase() == 'penjual') {
      // Switch ke pengguna biasa
      options.add(
        _buildRoleOption(
          context,
          icon: Icons.person,
          title: 'Switch ke Pengguna Biasa',
          subtitle: 'Kembali ke mode pengguna',
          onTap: () {
            context.read<SettingsBloc>().add(SwitchRoleEvent('pengguna'));
          },
        ),
      );

      options.add(const SizedBox(height: 12));

      // Option untuk praktisi
      if (hasPraktisiRole) {
        options.add(
          _buildRoleOption(
            context,
            icon: Icons.local_florist,
            title: 'Switch ke Akun Praktisi',
            subtitle: 'Beralih ke mode praktisi herbal',
            onTap: () {
              context.read<SettingsBloc>().add(SwitchRoleEvent('praktisi'));
            },
          ),
        );
      } else {
        options.add(
          _buildRoleOption(
            context,
            icon: Icons.local_florist,
            title: 'Buat Akun Praktisi Herbal',
            subtitle: 'Daftar sebagai praktisi herbal',
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Form Akun Praktisi Herbal (Coming Soon)'),
                ),
              );
            },
          ),
        );
      }
    }
    // Jika role praktisi aktif
    else if (activeRole?.roleName.toLowerCase() == 'praktisi') {
      // Switch ke pengguna biasa
      options.add(
        _buildRoleOption(
          context,
          icon: Icons.person,
          title: 'Switch ke Pengguna Biasa',
          subtitle: 'Kembali ke mode pengguna',
          onTap: () {
            context.read<SettingsBloc>().add(SwitchRoleEvent('pengguna'));
          },
        ),
      );

      options.add(const SizedBox(height: 12));

      // Option untuk penjual
      if (hasPenjualRole) {
        options.add(
          _buildRoleOption(
            context,
            icon: Icons.storefront,
            title: 'Switch ke Akun Penjual',
            subtitle: 'Beralih ke mode penjual',
            onTap: () {
              context.read<SettingsBloc>().add(SwitchRoleEvent('penjual'));
            },
          ),
        );
      } else {
        options.add(
          _buildRoleOption(
            context,
            icon: Icons.storefront,
            title: 'Buat Akun Penjual',
            subtitle: 'Daftar sebagai penjual produk herbal',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider.value(
                    value: authBloc,
                    child: const SellerProfileFormScreen(),
                  ),
                ),
              );
            },
          ),
        );
      }
    }

    return options;
  }

  Widget _buildRoleOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
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
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 28, color: Colors.green[700]),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}
