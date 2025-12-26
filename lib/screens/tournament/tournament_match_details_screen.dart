import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/tournament_model.dart'; // আপনার মডেলের পাথ অনুযায়ী পরিবর্তন করুন

class TournamentMatchDetailsScreen extends StatefulWidget {
  final String matchId;

  const TournamentMatchDetailsScreen({Key? key, required this.matchId}) : super(key: key);

  @override
  State<TournamentMatchDetailsScreen> createState() => _TournamentMatchDetailsScreenState();
}

class _TournamentMatchDetailsScreenState extends State<TournamentMatchDetailsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: _firestore.collection('tournament_matches').doc(widget.matchId).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return const Scaffold(body: Center(child: Text("Error loading match")));
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final match = TournamentMatch.fromFirestore(snapshot.data!);

        return Scaffold(
          appBar: AppBar(
            title: Text(match.round),
            backgroundColor: Colors.orange.shade700,
            actions: [
              if (match.status != 'finished')
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showEditScoreDialog(match),
                ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                _buildScoreHeader(match),
                const SizedBox(height: 20),
                _buildMatchInfo(match),
                const Divider(),
                _buildStatusSection(match),
              ],
            ),
          ),
          bottomNavigationBar: match.status != 'finished'
              ? _buildAdminActions(match)
              : null,
        );
      },
    );
  }

  Widget _buildScoreHeader(TournamentMatch match) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.orange.shade700,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTeamInfo(match.teamAName, match.teamALogo, match.scoreA),
          const Text("VS", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          _buildTeamInfo(match.teamBName, match.teamBLogo, match.scoreB),
        ],
      ),
    );
  }

  Widget _buildTeamInfo(String name, String? logo, int score) {
    return Column(
      children: [
        CircleAvatar(
          radius: 35,
          backgroundColor: Colors.white,
          backgroundImage: logo != null && logo.isNotEmpty ? NetworkImage(logo) : null,
          child: logo == null || logo.isEmpty ? const Icon(Icons.shield, size: 40) : null,
        ),
        const SizedBox(height: 10),
        Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 5),
        Text("$score", style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildMatchInfo(TournamentMatch match) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _infoRow(Icons.calendar_month, "তারিখ", DateFormat('dd MMM yyyy').format(match.matchDate)),
              _infoRow(Icons.access_time, "সময়", DateFormat('hh:mm a').format(match.matchDate)),
              _infoRow(Icons.location_on, "ভেন্যু", match.venue),
              if (match.groupName != null) _infoRow(Icons.groups, "গ্রুপ", match.groupName!),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.orange),
          const SizedBox(width: 10),
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildStatusSection(TournamentMatch match) {
    Color statusColor = match.status == 'live' ? Colors.green : Colors.orange;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor),
      ),
      child: Text(
        "ম্যাচ স্ট্যাটাস: ${match.status.toUpperCase()}",
        style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildAdminActions(TournamentMatch match) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () => _updateMatchStatus(match, 'live'),
                child: const Text("লাইভ করুন", style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                onPressed: () => _confirmFinishMatch(match),
                child: const Text("ম্যাচ শেষ", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditScoreDialog(TournamentMatch match) {
    int sA = match.scoreA;
    int sB = match.scoreB;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("স্কোর আপডেট করুন"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(match.teamAName),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                IconButton(icon: const Icon(Icons.remove), onPressed: () => sA--),
                Text("$sA"),
                IconButton(icon: const Icon(Icons.add), onPressed: () => sA++),
              ]),
            ),
            ListTile(
              title: Text(match.teamBName),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                IconButton(icon: const Icon(Icons.remove), onPressed: () => sB--),
                Text("$sB"),
                IconButton(icon: const Icon(Icons.add), onPressed: () => sB++),
              ]),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              _firestore.collection('tournament_matches').doc(match.matchId).update({
                'scoreA': sA,
                'scoreB': sB,
              });
              Navigator.pop(context);
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  void _updateMatchStatus(TournamentMatch match, String newStatus) {
    _firestore.collection('tournament_matches').doc(match.matchId).update({'status': newStatus});
  }

  void _confirmFinishMatch(TournamentMatch match) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("ম্যাচ কি শেষ?"),
        content: const Text("ম্যাচ শেষ করলে পয়েন্ট টেবিল আপডেট হবে।"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("না")),
          ElevatedButton(
            onPressed: () {
              _updateMatchStatus(match, 'finished');
              Navigator.pop(context);
            },
            child: const Text("হ্যাঁ, শেষ"),
          ),
        ],
      ),
    );
  }
}