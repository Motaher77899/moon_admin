

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/match_provider.dart';
import '../../models/match_model.dart';

class MatchStatsScreen extends StatefulWidget {
  final MatchModel match;
  final VoidCallback onUpdate;

  const MatchStatsScreen({
    Key? key,
    required this.match,
    required this.onUpdate,
  }) : super(key: key);

  @override
  State<MatchStatsScreen> createState() => _MatchStatsScreenState();
}

class _MatchStatsScreenState extends State<MatchStatsScreen> {
  late MatchStats _stats;

  @override
  void initState() {
    super.initState();
    _stats = widget.match.stats ?? MatchStats();
  }

  Future<void> _updateStats() async {
    final matchProvider = Provider.of<MatchProvider>(context, listen: false);
    final error = await matchProvider.updateStats(widget.match.id, _stats);

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('পরিসংখ্যান সংরক্ষিত হয়েছে'),
          backgroundColor: Colors.green,
        ),
      );
      widget.onUpdate();
    }
  }

  void _updatePossession(int teamAValue) {
    setState(() {
      _stats = _stats.copyWith(
        possessionA: teamAValue,
        possessionB: 100 - teamAValue,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1A1A2E),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: _updateStats,
              icon: const Icon(Icons.save),
              label: const Text('সংরক্ষণ করুন'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00D9FF),
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildPossessionStat(),
                const SizedBox(height: 24),

                _buildCounterStat(
                  title: 'Shots',
                  teamAValue: _stats.shotsA,
                  teamBValue: _stats.shotsB,
                  onTeamAIncrement: () {
                    setState(() => _stats = _stats.copyWith(shotsA: _stats.shotsA + 1));
                  },
                  onTeamADecrement: () {
                    if (_stats.shotsA > 0) {
                      setState(() => _stats = _stats.copyWith(shotsA: _stats.shotsA - 1));
                    }
                  },
                  onTeamBIncrement: () {
                    setState(() => _stats = _stats.copyWith(shotsB: _stats.shotsB + 1));
                  },
                  onTeamBDecrement: () {
                    if (_stats.shotsB > 0) {
                      setState(() => _stats = _stats.copyWith(shotsB: _stats.shotsB - 1));
                    }
                  },
                ),
                const SizedBox(height: 16),

                _buildCounterStat(
                  title: 'Shots on Target',
                  teamAValue: _stats.shotsOnTargetA,
                  teamBValue: _stats.shotsOnTargetB,
                  onTeamAIncrement: () {
                    setState(() => _stats = _stats.copyWith(shotsOnTargetA: _stats.shotsOnTargetA + 1));
                  },
                  onTeamADecrement: () {
                    if (_stats.shotsOnTargetA > 0) {
                      setState(() => _stats = _stats.copyWith(shotsOnTargetA: _stats.shotsOnTargetA - 1));
                    }
                  },
                  onTeamBIncrement: () {
                    setState(() => _stats = _stats.copyWith(shotsOnTargetB: _stats.shotsOnTargetB + 1));
                  },
                  onTeamBDecrement: () {
                    if (_stats.shotsOnTargetB > 0) {
                      setState(() => _stats = _stats.copyWith(shotsOnTargetB: _stats.shotsOnTargetB - 1));
                    }
                  },
                ),
                const SizedBox(height: 16),

                _buildCounterStat(
                  title: 'Corners',
                  teamAValue: _stats.cornersA,
                  teamBValue: _stats.cornersB,
                  onTeamAIncrement: () {
                    setState(() => _stats = _stats.copyWith(cornersA: _stats.cornersA + 1));
                  },
                  onTeamADecrement: () {
                    if (_stats.cornersA > 0) {
                      setState(() => _stats = _stats.copyWith(cornersA: _stats.cornersA - 1));
                    }
                  },
                  onTeamBIncrement: () {
                    setState(() => _stats = _stats.copyWith(cornersB: _stats.cornersB + 1));
                  },
                  onTeamBDecrement: () {
                    if (_stats.cornersB > 0) {
                      setState(() => _stats = _stats.copyWith(cornersB: _stats.cornersB - 1));
                    }
                  },
                ),
                const SizedBox(height: 16),

                _buildCounterStat(
                  title: 'Fouls',
                  teamAValue: _stats.foulsA,
                  teamBValue: _stats.foulsB,
                  onTeamAIncrement: () {
                    setState(() => _stats = _stats.copyWith(foulsA: _stats.foulsA + 1));
                  },
                  onTeamADecrement: () {
                    if (_stats.foulsA > 0) {
                      setState(() => _stats = _stats.copyWith(foulsA: _stats.foulsA - 1));
                    }
                  },
                  onTeamBIncrement: () {
                    setState(() => _stats = _stats.copyWith(foulsB: _stats.foulsB + 1));
                  },
                  onTeamBDecrement: () {
                    if (_stats.foulsB > 0) {
                      setState(() => _stats = _stats.copyWith(foulsB: _stats.foulsB - 1));
                    }
                  },
                ),
                const SizedBox(height: 16),

                _buildReadOnlyStat(
                  title: 'Yellow Cards',
                  teamAValue: _stats.yellowCardsA,
                  teamBValue: _stats.yellowCardsB,
                ),
                const SizedBox(height: 16),

                _buildReadOnlyStat(
                  title: 'Red Cards',
                  teamAValue: _stats.redCardsA,
                  teamBValue: _stats.redCardsB,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPossessionStat() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Text(
            'Possession',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_stats.possessionA}%',
                style: const TextStyle(
                  color: Color(0xFF00D9FF),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${_stats.possessionB}%',
                style: const TextStyle(
                  color: Color(0xFFE94560),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Slider(
            value: _stats.possessionA.toDouble(),
            min: 0,
            max: 100,
            activeColor: const Color(0xFF00D9FF),
            inactiveColor: const Color(0xFFE94560),
            onChanged: (value) => _updatePossession(value.toInt()),
          ),
        ],
      ),
    );
  }

  Widget _buildCounterStat({
    required String title,
    required int teamAValue,
    required int teamBValue,
    required VoidCallback onTeamAIncrement,
    required VoidCallback onTeamADecrement,
    required VoidCallback onTeamBIncrement,
    required VoidCallback onTeamBDecrement,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, color: Colors.white54),
                      onPressed: onTeamADecrement,
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A2E),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '$teamAValue',
                          style: const TextStyle(
                            color: Color(0xFF00D9FF),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, color: Colors.white54),
                      onPressed: onTeamAIncrement,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, color: Colors.white54),
                      onPressed: onTeamBDecrement,
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A2E),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '$teamBValue',
                          style: const TextStyle(
                            color: Color(0xFFE94560),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, color: Colors.white54),
                      onPressed: onTeamBIncrement,
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

  Widget _buildReadOnlyStat({
    required String title,
    required int teamAValue,
    required int teamBValue,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.info_outline, size: 16, color: Colors.white38),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$teamAValue',
                style: const TextStyle(
                  color: Color(0xFF00D9FF),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Auto-calculated',
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 12,
                ),
              ),
              Text(
                '$teamBValue',
                style: const TextStyle(
                  color: Color(0xFFE94560),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}