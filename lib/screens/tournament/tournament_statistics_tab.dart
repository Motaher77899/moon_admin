import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/tournament_provider.dart';
import '../../models/tournament_model.dart';

class TournamentStatisticsTab extends StatefulWidget {
  final TournamentModel tournament;

  const TournamentStatisticsTab({Key? key, required this.tournament})
      : super(key: key);

  @override
  State<TournamentStatisticsTab> createState() =>
      _TournamentStatisticsTabState();
}

class _TournamentStatisticsTabState extends State<TournamentStatisticsTab> {
  String _selectedTab = 'goals'; // 'goals' or 'assists'

  @override
  Widget build(BuildContext context) {
    return Consumer<TournamentProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            // Tab Selector
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildTabButton('গোল', 'goals'),
                  ),
                  Expanded(
                    child: _buildTabButton('অ্যাসিস্ট', 'assists'),
                  ),
                ],
              ),
            ),

            // Statistics List
            Expanded(
              child: _selectedTab == 'goals'
                  ? _buildGoalsList(provider)
                  : _buildAssistsList(provider),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTabButton(String label, String value) {
    bool isSelected = _selectedTab == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange.shade700 : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildGoalsList(TournamentProvider provider) {
    List<TournamentPlayerStats> topScorers = provider.getTopScorers(limit: 20);

    if (topScorers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.sports_soccer, size: 80, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              'কোন গোল রেকর্ড নেই',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: topScorers.length,
      itemBuilder: (context, index) {
        TournamentPlayerStats player = topScorers[index];
        return _buildPlayerCard(
          player,
          index + 1,
          player.goals,
          Icons.sports_soccer,
          Colors.green,
        );
      },
    );
  }

  Widget _buildAssistsList(TournamentProvider provider) {
    List<TournamentPlayerStats> topAssists = provider.getTopAssists(limit: 20);

    if (topAssists.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.handshake, size: 80, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              'কোন অ্যাসিস্ট রেকর্ড নেই',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: topAssists.length,
      itemBuilder: (context, index) {
        TournamentPlayerStats player = topAssists[index];
        return _buildPlayerCard(
          player,
          index + 1,
          player.assists,
          Icons.handshake,
          Colors.blue,
        );
      },
    );
  }

  Widget _buildPlayerCard(
      TournamentPlayerStats player,
      int position,
      int statValue,
      IconData icon,
      Color statColor,
      ) {
    // Medal colors for top 3
    Color? medalColor;
    if (position == 1) {
      medalColor = const Color(0xFFFFD700); // Gold
    } else if (position == 2) {
      medalColor = const Color(0xFFC0C0C0); // Silver
    } else if (position == 3) {
      medalColor = const Color(0xFFCD7F32); // Bronze
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: position <= 3 ? 3 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: position <= 3
            ? BorderSide(color: medalColor!, width: 2)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // Position Badge
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: medalColor ?? Colors.grey.shade300,
                shape: BoxShape.circle,
                boxShadow: position <= 3
                    ? [
                  BoxShadow(
                    color: medalColor!.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ]
                    : null,
              ),
              child: Center(
                child: Text(
                  '$position',
                  style: TextStyle(
                    color: position <= 3 ? Colors.white : Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Player Photo
            if (player.playerPhoto != null && player.playerPhoto!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image.network(
                  player.playerPhoto!,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.person,
                          size: 30, color: Colors.grey.shade400),
                    );
                  },
                ),
              )
            else
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.person, size: 30, color: Colors.grey.shade400),
              ),
            const SizedBox(width: 12),

            // Player Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    player.playerName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.shield, size: 12, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          player.teamName,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Stat Value
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: statColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: statColor, width: 2),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: statColor, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    '$statValue',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: statColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}