import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/tournament_model.dart';

class TournamentInfoTab extends StatelessWidget {
  final TournamentModel tournament;

  const TournamentInfoTab({Key? key, required this.tournament})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('dd MMMM yyyy');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tournament Logo/Icon
          Center(
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange.shade600, Colors.orange.shade800],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.shade200,
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Icon(
                Icons.emoji_events,
                size: 60,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Tournament Name
          Center(
            child: Text(
              tournament.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 8),

          // Status Badge
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: _getStatusColor(tournament.status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _getStatusColor(tournament.status),
                  width: 2,
                ),
              ),
              child: Text(
                _getStatusBengali(tournament.status),
                style: TextStyle(
                  color: _getStatusColor(tournament.status),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Description
          _buildInfoSection(
            icon: Icons.description,
            title: 'বিবরণ',
            content: tournament.description,
          ),
          const SizedBox(height: 20),

          // Format
          _buildInfoSection(
            icon: Icons.format_list_bulleted,
            title: 'ফরম্যাট',
            content: _getFormatBengali(tournament.format),
          ),
          const SizedBox(height: 20),

          // Date Range
          _buildInfoSection(
            icon: Icons.calendar_today,
            title: 'সময়কাল',
            content:
            '${dateFormat.format(tournament.startDate)} - ${dateFormat.format(tournament.endDate)}',
          ),
          const SizedBox(height: 20),

          // Teams Count
          _buildInfoSection(
            icon: Icons.groups,
            title: 'মোট টিম',
            content: '${tournament.teamIds.length} টি টিম',
          ),
          const SizedBox(height: 20),

          // Groups Info
          if (tournament.format == 'groups') ...[
            _buildInfoSection(
              icon: Icons.workspaces,
              title: 'গ্রুপ সংখ্যা',
              content: '${tournament.numberOfGroups} টি গ্রুপ',
            ),
            const SizedBox(height: 20),
            _buildInfoSection(
              icon: Icons.person_outline,
              title: 'প্রতি গ্রুপে টিম',
              content: '${tournament.teamsPerGroup} টি টিম',
            ),
            const SizedBox(height: 20),
            _buildInfoSection(
              icon: Icons.verified,
              title: 'যোগ্যতা অর্জনকারী টিম',
              content: 'প্রতি গ্রুপ থেকে ${tournament.qualifiedTeamsPerGroup} টি টিম',
            ),
            const SizedBox(height: 20),
          ],

          // Match Duration
          _buildInfoSection(
            icon: Icons.timer,
            title: 'ম্যাচের সময়',
            content: '${tournament.matchDuration} মিনিট',
          ),
          const SizedBox(height: 20),

          // Knockout Stage
          _buildInfoSection(
            icon: Icons.emoji_events,
            title: 'নকআউট পর্ব',
            content: tournament.hasKnockoutStage ? 'হ্যাঁ' : 'না',
          ),
          const SizedBox(height: 20),

          // Created By
          _buildInfoSection(
            icon: Icons.person,
            title: 'তৈরি করেছেন',
            content: tournament.createdBy,
          ),
          const SizedBox(height: 20),

          // Created Date
          _buildInfoSection(
            icon: Icons.access_time,
            title: 'তৈরির তারিখ',
            content: dateFormat.format(tournament.createdAt),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.orange.shade700, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'ongoing':
        return Colors.green;
      case 'completed':
        return Colors.grey;
      default:
        return Colors.orange;
    }
  }

  String _getStatusBengali(String status) {
    switch (status) {
      case 'upcoming':
        return 'আসন্ন';
      case 'ongoing':
        return 'চলমান';
      case 'completed':
        return 'সম্পন্ন';
      default:
        return status;
    }
  }

  String _getFormatBengali(String format) {
    switch (format) {
      case 'groups':
        return 'গ্রুপ পর্ব + নকআউট';
      case 'knockout':
        return 'সরাসরি নকআউট';
      case 'league':
        return 'লিগ (রাউন্ড রবিন)';
      default:
        return format;
    }
  }
}