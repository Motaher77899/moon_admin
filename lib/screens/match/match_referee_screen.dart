
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/match_provider.dart';
import '../../models/match_model.dart';

class MatchRefereeScreen extends StatefulWidget {
  final MatchModel match;
  final VoidCallback onUpdate;

  const MatchRefereeScreen({
    Key? key,
    required this.match,
    required this.onUpdate,
  }) : super(key: key);

  @override
  State<MatchRefereeScreen> createState() => _MatchRefereeScreenState();
}

class _MatchRefereeScreenState extends State<MatchRefereeScreen> {
  int _matchMinute = 0;
  bool _isFirstHalf = true;

  @override
  void initState() {
    super.initState();
    if (widget.match.status == 'live') {
      final elapsed = DateTime.now().difference(widget.match.time).inMinutes;
      _matchMinute = elapsed > 0 ? elapsed : 0;
    }
  }

  Future<void> _addGoal(String team) async {
    final lineup = team == 'teamA' ? widget.match.lineUpA : widget.match.lineUpB;
    final teamName = team == 'teamA' ? widget.match.teamAName : widget.match.teamBName;

    if (lineup == null || lineup.players.isEmpty) {
      _showSnack('$teamName এর লাইনআপ সেট করা নেই');
      return;
    }

    final scorer = await _selectPlayer(lineup.players, 'গোল করলেন কে?', teamName);
    if (scorer == null) return;

    final assistType = await _showAssistDialog();
    PlayerLineUp? assist;

    if (assistType == 'assist') {
      final filtered = lineup.players.where((p) => p.playerId != scorer.playerId).toList();
      assist = await _selectPlayer(filtered, 'অ্যাসিস্ট কার?', teamName);
    }

    final event = MatchEvent(
      type: 'goal',
      team: team,
      playerId: scorer.playerId,
      playerName: scorer.playerName,
      minute: _matchMinute,
      assistPlayerId: assist?.playerId,
      assistPlayerName: assist?.playerName,
      assistType: assistType,
    );

    await _saveEventAndUpdateScore(event, team);
  }

  Future<void> _addCard(String team, String cardType) async {
    final lineup = team == 'teamA' ? widget.match.lineUpA : widget.match.lineUpB;
    final teamName = team == 'teamA' ? widget.match.teamAName : widget.match.teamBName;

    if (lineup == null || lineup.players.isEmpty) {
      _showSnack('$teamName এর লাইনআপ সেট করা নেই');
      return;
    }

    final player = await _selectPlayer(
      lineup.players,
      cardType == 'yellow' ? 'হলুদ কার্ড' : 'লাল কার্ড',
      teamName,
    );

    if (player == null) return;

    final event = MatchEvent(
      type: 'card',
      team: team,
      playerId: player.playerId,
      playerName: player.playerName,
      minute: _matchMinute,
      details: cardType,
    );

    await _saveEvent(event);
  }

  Future<void> _addSubstitution(String team) async {
    final lineup = team == 'teamA' ? widget.match.lineUpA : widget.match.lineUpB;
    final teamName = team == 'teamA' ? widget.match.teamAName : widget.match.teamBName;

    if (lineup == null || lineup.players.isEmpty) {
      _showSnack('$teamName এর লাইনআপ সেট করা নেই');
      return;
    }

    final mainPlayers = lineup.players.where((p) => !p.isSubstitute).toList();
    final benchPlayers = lineup.players.where((p) => p.isSubstitute).toList();

    final playerOut = await _selectPlayer(mainPlayers, 'খেলোয়াড় বের হবে', teamName);
    if (playerOut == null) return;

    final playerIn = await _selectPlayer(benchPlayers, 'খেলোয়াড় ঢুকবে', teamName);
    if (playerIn == null) return;

    final outEvent = MatchEvent(
      type: 'substitution',
      team: team,
      playerId: playerOut.playerId,
      playerName: playerOut.playerName,
      minute: _matchMinute,
      details: 'out',
    );

    final inEvent = MatchEvent(
      type: 'substitution',
      team: team,
      playerId: playerIn.playerId,
      playerName: playerIn.playerName,
      minute: _matchMinute,
      details: 'in',
    );

    final mp = Provider.of<MatchProvider>(context, listen: false);
    await mp.addTimelineEvent(widget.match.id, outEvent);
    await mp.addTimelineEvent(widget.match.id, inEvent);

    _showSnack('সাবস্টিটিউশন সফলভাবে যোগ হয়েছে', Colors.green);
    widget.onUpdate();
  }

  Future<PlayerLineUp?> _selectPlayer(List<PlayerLineUp> players, String title, String teamName) async {
    if (players.isEmpty) {
      _showSnack('কোনো খেলোয়াড় পাওয়া যায়নি');
      return null;
    }

    return showDialog<PlayerLineUp>(
      context: context,
      builder: (_) => _PlayerSelectionDialog(players: players, title: title, teamName: teamName),
    );
  }

  Future<String?> _showAssistDialog() async {
    return showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('অ্যাসিস্ট কীভাবে?', textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _assistOption('penalty', 'পেনাল্টি কিক', Icons.sports_soccer),
            const SizedBox(height: 12),
            _assistOption('alone', 'একা গোল', Icons.person),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => Navigator.pop(context, 'assist'),
              child: const Text('খেলোয়াড়ের অ্যাসিস্ট', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _assistOption(String value, String label, IconData icon) {
    return InkWell(
      onTap: () => Navigator.pop(context, value),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Icon(icon, color: Colors.orange),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Future<void> _saveEvent(MatchEvent event) async {
    final mp = Provider.of<MatchProvider>(context, listen: false);
    final error = await mp.addTimelineEvent(widget.match.id, event);
    if (error == null) {
      _showSnack('ইভেন্ট সফলভাবে যোগ হয়েছে', Colors.green);
      widget.onUpdate();
    } else {
      _showSnack(error);
    }
  }

  Future<void> _saveEventAndUpdateScore(MatchEvent event, String team) async {
    final mp = Provider.of<MatchProvider>(context, listen: false);
    final error = await mp.addTimelineEvent(widget.match.id, event);
    if (error == null) {
      final newA = widget.match.scoreA + (team == 'teamA' ? 1 : 0);
      final newB = widget.match.scoreB + (team == 'teamB' ? 1 : 0);
      await mp.updateMatchScore(widget.match.id, newA, newB);
      _showSnack('গোল যোগ হয়েছে!', Colors.green);
      widget.onUpdate();
    } else {
      _showSnack(error);
    }
  }

  void _showSnack(String msg, [Color? color]) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: color ?? Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.match.status != 'live') {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.sports_soccer, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text('ম্যাচ শুরু করুন রেফারি কন্ট্রোল ব্যবহার করতে', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${_matchMinute.toString().padLeft(2, '0')}:00',
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.orange),
              ),
              const SizedBox(width: 10),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.grey),
                onPressed: () async {
                  final m = await _showMinutePicker();
                  if (m != null) setState(() => _matchMinute = m);
                },
              ),
            ],
          ),
        ),
        const Divider(height: 1),

        Expanded(
          child: Row(
            children: [
              Expanded(child: _teamControls('teamA')),
              const VerticalDivider(),
              Expanded(child: _teamControls('teamB')),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 56,
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              onPressed: () {
                setState(() => _isFirstHalf = !_isFirstHalf);
                _showSnack(_isFirstHalf ? 'দ্বিতীয় হাফ শুরু' : 'ম্যাচ শেষ', Colors.green);
              },
              child: Text(_isFirstHalf ? 'প্রথম হাফ শেষ করুন' : 'ম্যাচ শেষ করুন', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _teamControls(String team) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _ctrlBtn(Icons.sports_soccer, Colors.green, () => _addGoal(team)),
        _ctrlBtn(Icons.square, Colors.yellow.shade700, () => _addCard(team, 'yellow')),
        _ctrlBtn(Icons.square, Colors.red.shade700, () => _addCard(team, 'red')),
        _ctrlBtn(Icons.swap_horiz, Colors.blue, () => _addSubstitution(team)),
        _ctrlBtn(Icons.sports_soccer, Colors.purple, () => _addGoal(team == 'teamA' ? 'teamB' : 'teamA')),
      ],
    );
  }

  Widget _ctrlBtn(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white, border: Border.all(color: Colors.grey.shade300, width: 3)),
        child: Icon(icon, color: color, size: 36),
      ),
    );
  }

  Future<int?> _showMinutePicker() async {
    int temp = _matchMinute;
    return showDialog<int>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('মিনিট সেট করুন'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  if (temp > 0) setState(() => temp--);
                },
                icon: const Icon(Icons.remove),
              ),
              Text('$temp\'', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
              IconButton(
                onPressed: () {
                  setState(() => temp++);
                },
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('বাতিল')),
            ElevatedButton(onPressed: () => Navigator.pop(context, temp), child: const Text('ঠিক আছে')),
          ],
        ),
      ),
    );
  }
}

class _PlayerSelectionDialog extends StatelessWidget {
  final List<PlayerLineUp> players;
  final String title;
  final String teamName;

  const _PlayerSelectionDialog({required this.players, required this.title, required this.teamName});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(teamName, style: TextStyle(color: Colors.grey.shade600)),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            SizedBox(
              height: 400,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 0.9,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: players.length,
                itemBuilder: (_, i) {
                  final p = players[i];
                  return GestureDetector(
                    onTap: () => Navigator.pop(context, p),
                    child: Column(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(color: Colors.red.shade600, borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(p.playerName.isNotEmpty ? p.playerName[0].toUpperCase() : '?',
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                              Text('${p.jerseyNumber}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(p.playerName, style: const TextStyle(fontSize: 11), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}