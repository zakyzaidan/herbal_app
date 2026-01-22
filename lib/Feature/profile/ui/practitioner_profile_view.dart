// lib/Feature/profile/ui/practitioner_profile_view_complete.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:herbal_app/Feature/profile/ui/form_edit_practitioner.dart';
import 'package:herbal_app/data/models/practitioner_model.dart';
import 'package:herbal_app/data/models/user_model.dart';
import 'package:herbal_app/data/services/practitioner_services.dart';

class PractitionerProfileView extends StatefulWidget {
  final UserModel user;

  const PractitionerProfileView({super.key, required this.user});

  @override
  State<PractitionerProfileView> createState() =>
      _PractitionerProfileViewState();
}

class _PractitionerProfileViewState extends State<PractitionerProfileView>
    with SingleTickerProviderStateMixin {
  final PractitionerServices _practitionerServices = PractitionerServices();
  late TabController _tabController;
  PractitionerProfile? _practitionerProfile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadPractitionerData();
  }

  Future<void> _loadPractitionerData() async {
    try {
      final profile = await _practitionerServices.getProfileByUserId(
        widget.user.id,
      );
      if (profile != null) {
        setState(() {
          _practitionerProfile = profile;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A400C),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 12),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            child: _buildPractitionerCard(),
                          ),
                          _buildTabBar(),
                          Expanded(
                            child: TabBarView(
                              controller: _tabController,
                              children: [_buildInfoTab(), _buildForumTab()],
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Akun Saya',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined, color: Colors.white),
                onPressed: () {
                  context.push('/settings');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPractitionerCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.amber,
                backgroundImage: _practitionerProfile?.profilePhoto != null
                    ? NetworkImage(_practitionerProfile!.profilePhoto!)
                    : null,
                child: _practitionerProfile?.profilePhoto == null
                    ? Text(
                        _practitionerProfile?.fullName[0].toUpperCase() ?? 'P',
                        style: const TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _practitionerProfile?.fullName ?? 'Praktisi',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Praktisi',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () {},
              ),
            ],
          ),
          if (_practitionerProfile?.title != null) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _practitionerProfile!.title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.green[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
          if (_practitionerProfile?.city != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '${_practitionerProfile!.city}${_practitionerProfile!.province != null ? ', ${_practitionerProfile!.province}' : ''}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: const Color(0xFF0A400C),
        unselectedLabelColor: Colors.grey,
        indicatorColor: const Color(0xFF0A400C),
        tabs: const [
          Tab(text: 'Info Saya'),
          Tab(text: 'Postingan Forum'),
        ],
      ),
    );
  }

  Widget _buildInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Buttons Row
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    if (_practitionerProfile != null) {
                      context.push(
                        '/practitioner/${_practitionerProfile!.id}',
                        extra: _practitionerProfile,
                      );
                      _loadPractitionerData();
                    }
                  },
                  icon: const Icon(Icons.visibility),
                  label: const Text('Lihat Tampilan'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: BorderSide(color: Colors.green[700]!),
                    foregroundColor: Colors.green[700],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    if (_practitionerProfile != null) {
                      final updated = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PractitionerEditFormScreen(
                            profile: _practitionerProfile!,
                          ),
                        ),
                      );
                      if (updated != null) {
                        _loadPractitionerData();
                      }
                    }
                  },
                  icon: const Icon(Icons.edit, color: Colors.white),
                  label: const Text(
                    'Edit',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          const Text(
            'Tentang Praktisi',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (_practitionerProfile?.educationHistory != null)
            _buildInfoSection(
              'Riwayat Pendidikan/Pelatihan',
              _practitionerProfile!.educationHistory!,
            ),
          if (_practitionerProfile?.trainingInstitution != null)
            _buildInfoRow(
              'Institusi Pelatihan',
              _practitionerProfile!.trainingInstitution!,
            ),
          const SizedBox(height: 24),
          const Text(
            'Tempat Praktik',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (_practitionerProfile?.practiceName != null)
            _buildInfoRow(
              'Tempat Praktik',
              _practitionerProfile!.practiceName!,
            ),
          if (_practitionerProfile?.practiceAddress != null)
            _buildInfoSection('Alamat', _practitionerProfile!.practiceAddress!),
          const SizedBox(height: 24),
          const Text(
            'Sertifikasi - Surat Izin Praktik',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (_practitionerProfile?.certificationNumber != null)
            Text(
              _practitionerProfile!.certificationNumber!,
              style: const TextStyle(fontSize: 16),
            ),
          const SizedBox(height: 24),
          const Text(
            'Layanan',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (_practitionerProfile?.services != null)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _practitionerProfile!.services!.map((service) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(service, style: const TextStyle(fontSize: 14)),
                );
              }).toList(),
            ),
          const SizedBox(height: 24),
          const Text(
            'Deskripsi',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (_practitionerProfile?.description != null)
            Text(
              _practitionerProfile!.description!,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.6,
              ),
            ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForumTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Belum ada postingan',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
