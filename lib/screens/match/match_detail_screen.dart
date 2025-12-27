
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/match_provider.dart';
import '../../models/match_model.dart';
import 'match_lineup_screen.dart';
import 'match_referee_screen.dart';
import 'match_stats_screen.dart';

class MatchDetailScreen extends StatefulWidget {
  final MatchModel match;

  const MatchDetailScreen({Key? key, required this.match}) : super(key: key);

  @override
  State<MatchDetailScreen> createState() => _MatchDetailScreenState();
}

class _MatchDetailScreenState extends State<MatchDetailScreen>
    with SingleTickerProviderStateMixin {
  late MatchModel _currentMatch;
  late TabController _tabController;
  final DateFormat _dateFormat = DateFormat('dd MMMM yyyy, hh:mm a');

  @override
  void initState() {
    super.initState();
    _currentMatch = widget.match;
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _updateStatus(String newStatus) async {
    final matchProvider = Provider.of<MatchProvider>(context, listen: false);
    final error = await matchProvider.updateMatchStatus(_currentMatch.id, newStatus);

    if (error != null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
    } else {
      setState(() {
        _currentMatch = _currentMatch.copyWith(status: newStatus);
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('স্ট্যাটাস ${_getStatusBengali(newStatus)} এ পরিবর্তন করা হয়েছে'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  String _getStatusBengali(String status) {
    switch (status) {
      case 'upcoming':
        return 'আসন্ন';
      case 'live':
        return 'লাইভ';
      case 'finished':
        return 'সম্পন্ন';
      default:
        return status;
    }
  }

  Future<void> _deleteMatch() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('নিশ্চিত করুন'),
        content: const Text('আপনি কি নিশ্চিত এই ম্যাচ মুছতে চান?'),
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
      final matchProvider = Provider.of<MatchProvider>(context, listen: false);
      final error = await matchProvider.deleteMatch(_currentMatch.id);

      if (!mounted) return;

      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: Colors.red),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ম্যাচ মুছে ফেলা হয়েছে'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  void _refreshMatch() {
    final matchProvider = Provider.of<MatchProvider>(context, listen: false);
    final updatedMatch = matchProvider.getMatchById(_currentMatch.id);
    if (updatedMatch != null) {
      setState(() {
        _currentMatch = updatedMatch;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Color statusColor = _currentMatch.status == 'live'
        ? Colors.green
        : _currentMatch.status == 'finished'
        ? Colors.grey
        : Colors.orange;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        title: const Text(
          'ম্যাচ বিস্তারিত',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Share functionality
            },
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8),
                    Text('মুছে ফেলুন'),
                  ],
                ),
                onTap: _deleteMatch,
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          _buildMatchHeader(statusColor),

          Container(
            color: const Color(0xFF16213E),
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.orange,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white54,
              tabs: const [
                Tab(text: 'OVERVIEW'),
                Tab(text: 'LINE-UP'),
                Tab(text: 'REFEREE'),
                Tab(text: 'STATS'),
              ],
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                MatchLineupScreen(match: _currentMatch, onUpdate: _refreshMatch),
                MatchRefereeScreen(match: _currentMatch, onUpdate: _refreshMatch),
                MatchStatsScreen(match: _currentMatch, onUpdate: _refreshMatch),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchHeader(Color statusColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF16213E),
            Color(0xFF0F3460),
          ],
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${_currentMatch.scoreA}',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  ':',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white54,
                  ),
                ),
              ),
              Text(
                '${_currentMatch.scoreB}',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          if (_currentMatch.status == 'live')
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "${DateTime.now().difference(_currentMatch.time).inMinutes}'",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          else
            Text(
              _getStatusBengali(_currentMatch.status),
              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                        color: Colors.white12,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.shield,
                        size: 30,
                        color: Colors.white54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _currentMatch.teamAName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const Text(
                'VS',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white54,
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                        color: Colors.white12,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.shield,
                        size: 30,
                        color: Colors.white54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _currentMatch.teamBName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return Container(
      color: const Color(0xFF1A1A2E),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildInfoCard(
            icon: Icons.location_on,
            title: 'স্থান',
            value: _currentMatch.venue ?? 'স্থান উল্লেখ নেই',
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            icon: Icons.calendar_today,
            title: 'তারিখ ও সময়',
            value: _dateFormat.format(_currentMatch.date),
          ),
          const SizedBox(height: 24),

          Expanded(
            child: _buildTimeline(),
          ),

          const SizedBox(height: 16),

          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    if (_currentMatch.timeline.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.timeline, size: 60, color: Colors.white24),
            const SizedBox(height: 16),
            Text(
              'কোনো ইভেন্ট নেই',
              style: TextStyle(color: Colors.white54),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _currentMatch.timeline.length,
      itemBuilder: (context, index) {
        final event = _currentMatch.timeline[index];
        IconData icon;
        Color color;

        switch (event.type) {
          case 'goal':
            icon = Icons.sports_soccer;
            color = Colors.green;
            break;
          case 'card':
            icon = Icons.credit_card;
            color = event.details == 'yellow' ? Colors.yellow : Colors.red;
            break;
          case 'substitution':
            icon = Icons.swap_horiz;
            color = Colors.blue;
            break;
          default:
            icon = Icons.circle;
            color = Colors.grey;
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF16213E),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.playerName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (event.assistPlayerName != null)
                      Text(
                        'Assist: ${event.assistPlayerName}',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
              Text(
                "${event.minute}'",
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButtons() {
    if (_currentMatch.status == 'upcoming') {
      return SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton.icon(
          onPressed: () => _updateStatus('live'),
          icon: const Icon(Icons.play_arrow),
          label: const Text(
            'ম্যাচ শুরু করুন',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      );
    }

    if (_currentMatch.status == 'live') {
      return SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton.icon(
          onPressed: () => _updateStatus('finished'),
          icon: const Icon(Icons.done),
          label: const Text(
            'ম্যাচ শেষ করুন',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, color: Colors.green),
          SizedBox(width: 8),
          Text(
            'ম্যাচ সম্পন্ন হয়েছে',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.orange),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white54,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}