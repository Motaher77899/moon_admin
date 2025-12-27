
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/tournament_provider.dart';
import '../../providers/match_provider.dart';
import '../../models/tournament_model.dart';
import 'create_tournament_match_screen.dart';
import 'tournament_teams_tab.dart';
import 'tournament_matches_tab.dart';
import 'tournament_table_tab.dart';
import 'tournament_statistics_tab.dart';

class TournamentDetailScreen extends StatefulWidget {
  final TournamentModel tournament;

  const TournamentDetailScreen({Key? key, required this.tournament})
      : super(key: key);

  @override
  State<TournamentDetailScreen> createState() => _TournamentDetailScreenState();
}

class _TournamentDetailScreenState extends State<TournamentDetailScreen>
    with SingleTickerProviderStateMixin {
  late TournamentModel _currentTournament;
  late TabController _tabController;
  final DateFormat _fullDateFormat = DateFormat('dd MMMM yyyy');
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentTournament = widget.tournament;
    _tabController = TabController(length: 6, vsync: this); // ✅ Changed to 6 tabs
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final tournamentProvider =
    Provider.of<TournamentProvider>(context, listen: false);
    final matchProvider = Provider.of<MatchProvider>(context, listen: false);

    await Future.wait([
      tournamentProvider.loadTournamentGroups(_currentTournament.tournamentId!),
      tournamentProvider.loadTournamentMatches(_currentTournament.tournamentId!),
      tournamentProvider.loadTeamStats(_currentTournament.tournamentId!),
      matchProvider.loadTeams(),
    ]);

    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _updateStatus(String newStatus) async {
    final tournamentProvider =
    Provider.of<TournamentProvider>(context, listen: false);
    final error = await tournamentProvider.updateTournamentStatus(
        _currentTournament.tournamentId!, newStatus);

    if (error != null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
    } else {
      setState(() {
        _currentTournament = _currentTournament.copyWith(status: newStatus);
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'স্ট্যাটাস ${_getStatusBengali(newStatus)} এ পরিবর্তন করা হয়েছে'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  String _getStatusBengali(String status) {
    switch (status) {
      case 'upcoming':
        return 'আসন্ন';
      case 'ongoing':
        return 'চলমান';
      case 'finished':
        return 'সম্পন্ন';
      default:
        return status;
    }
  }

  Color _getStatusColor() {
    switch (_currentTournament.status) {
      case 'ongoing':
        return Colors.green;
      case 'finished':
        return Colors.grey;
      default:
        return Colors.orange;
    }
  }

  Future<void> _deleteTournament() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
            SizedBox(width: 12),
            Text('টুর্নামেন্ট মুছুন'),
          ],
        ),
        content: const Text(
          'আপনি কি নিশ্চিত যে এই টুর্নামেন্ট এবং এর সকল ম্যাচ ও ডেটা মুছে ফেলতে চান?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('না'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('হ্যাঁ, মুছুন'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final tournamentProvider =
      Provider.of<TournamentProvider>(context, listen: false);
      final error = await tournamentProvider
          .deleteTournament(_currentTournament.tournamentId!);

      if (!mounted) return;

      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: Colors.red),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('টুর্নামেন্ট মুছে ফেলা হয়েছে'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          // ==================== Custom AppBar ====================
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: Colors.orange.shade700,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white),
                onPressed: _loadData,
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onSelected: (value) {
                  if (value == 'delete') {
                    _deleteTournament();
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red, size: 20),
                        SizedBox(width: 8),
                        Text('মুছুন', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.orange.shade700,
                      Colors.orange.shade900,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 50),
                      // Trophy Icon
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.emoji_events,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Tournament Name
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          _currentTournament.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Status Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _getStatusBengali(_currentTournament.status),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
          children: [
            // ==================== Tabs (6 tabs) ====================
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.orange.shade700,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.orange.shade700,
                indicatorWeight: 3,
                isScrollable: true, // ✅ Scrollable for 6 tabs
                labelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                tabs: const [
                  Tab(text: 'তথ্য'),
                  Tab(text: 'ম্যাচসমূহ'),
                  Tab(text: 'পয়েন্ট টেবিল'),
                  Tab(text: 'খেলোয়াড়'),
                  Tab(text: 'টিম স্ট্যাটস'),
                  Tab(text: 'টিম'),
                ],
              ),
            ),
            // ==================== Tab Views ====================
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Tab 1: Info
                  _buildInfoTab(),
                  // Tab 2: Matches
                  TournamentMatchesTab(tournament: _currentTournament),
                  // Tab 3: Points Table
                  TournamentTableTab(tournament: _currentTournament),
                  // Tab 4: Player Stats (Using TournamentStatisticsTab)
                  TournamentStatisticsTab(tournament: _currentTournament),
                  // Tab 5: Team Stats
                  _buildTeamStatsTab(),
                  // Tab 6: Teams
                  TournamentTeamsTab(tournament: _currentTournament),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== Info Tab (Tab 1) ====================
  Widget _buildInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Info Card
          _buildCompactInfoCard(),
          const SizedBox(height: 20),
          // Action Buttons
          _buildActionButtons(),
        ],
      ),
    );
  }

  // ==================== Compact Info Card ====================
  Widget _buildCompactInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          _buildCompactInfoRow(
            Icons.description,
            'বিবরণ',
            _currentTournament.name,
            Colors.blue,
          ),
          const Divider(height: 24),
          _buildCompactInfoRow(
            Icons.workspaces,
            'ফরম্যাট',
            _currentTournament.format == 'groups'
                ? 'লিগ (গ্রুপ বিন্যাস)'
                : 'নকআউট',
            Colors.purple,
          ),
          const Divider(height: 24),
          _buildCompactInfoRow(
            Icons.calendar_today,
            'সময়কাল',
            '${DateFormat('dd MMM yyyy').format(_currentTournament.startDate)} - ${DateFormat('dd MMM yyyy').format(_currentTournament.endDate)}',
            Colors.orange,
          ),
          const Divider(height: 24),
          _buildCompactInfoRow(
            Icons.people,
            'মোট টিম',
            '${_currentTournament.teamIds.length} টি টিম',
            Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildCompactInfoRow(
      IconData icon,
      String label,
      String value,
      Color color,
      ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==================== Team Stats Tab (Tab 5) ====================
  Widget _buildTeamStatsTab() {
    return Consumer<TournamentProvider>(
      builder: (context, provider, child) {
        final stats = provider.teamStats;

        if (stats.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.bar_chart,
                    size: 80, color: Colors.grey.shade300),
                const SizedBox(height: 16),
                const Text(
                  'কোন টিম পরিসংখ্যান নেই',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'ম্যাচ সম্পন্ন হলে টিম পরিসংখ্যান দেখা যাবে',
                  style: TextStyle(color: Colors.grey.shade500),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        // Sort by points
        final sortedStats = List<TournamentTeamStats>.from(stats)
          ..sort((a, b) => b.points.compareTo(a.points));

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: sortedStats.length,
          itemBuilder: (context, index) {
            final stat = sortedStats[index];
            return _buildTeamStatsCard(stat, index + 1);
          },
        );
      },
    );
  }

  Widget _buildTeamStatsCard(TournamentTeamStats stat, int rank) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // Rank
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: rank <= 3
                  ? Colors.orange.shade100
                  : Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$rank',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: rank <= 3
                      ? Colors.orange.shade700
                      : Colors.grey.shade700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Team Name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stat.teamName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${stat.matchesPlayed} ম্যাচ • ${stat.wins} জয়',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          // Points
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${stat.points}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.orange.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== Action Buttons ====================
  Widget _buildActionButtons() {
    return Column(
      children: [
        // Status Change Buttons
        if (_currentTournament.status == 'upcoming')
          _buildActionButton(
            icon: Icons.play_arrow,
            label: 'টুর্নামেন্ট শুরু করুন',
            color: Colors.green,
            onPressed: () => _updateStatus('ongoing'),
          ),
        if (_currentTournament.status == 'ongoing')
          _buildActionButton(
            icon: Icons.done,
            label: 'টুর্নামেন্ট শেষ করুন',
            color: Colors.orange.shade700,
            onPressed: () => _updateStatus('finished'),
          ),
        // Add Match Button (only if not finished)
        if (_currentTournament.status != 'finished') ...[
          if (_currentTournament.status != 'upcoming')
            const SizedBox(height: 12),
          _buildActionButton(
            icon: Icons.add,
            label: 'নতুন ম্যাচ যোগ করুন',
            color: Colors.blue,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CreateTournamentMatchScreen(
                    tournament: _currentTournament,
                  ),
                ),
              ).then((_) => _loadData());
            },
          ),
        ],
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}