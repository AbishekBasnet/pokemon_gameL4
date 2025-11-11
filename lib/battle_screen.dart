import 'package:flutter/material.dart';
import 'dart:math';
import 'db_helper.dart';
import 'services/api_service.dart';

class BattleScreen extends StatefulWidget {
  const BattleScreen({Key? key}) : super(key: key);

  @override
  State<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends State<BattleScreen> {
  PokemonCard? card1;
  PokemonCard? card2;
  PokemonCard? winner;
  bool isLoading = false;
  bool hasBattled = false;
  List<BattleHistory> battleHistory = [];
  final ApiService apiService = ApiService();
  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadBattleHistory();
    _startNewBattle();
  }

  Future<void> _loadBattleHistory() async {
    try {
      List<BattleHistory> history = await dbHelper.getAllBattleHistory();
      setState(() {
        battleHistory = history;
      });
    } catch (e) {
      print('Error loading battle history: $e');
    }
  }

  Future<void> _startNewBattle() async {
    setState(() {
      isLoading = true;
      hasBattled = false;
      winner = null;
      card1 = null;
      card2 = null;
    });

    try {
      List<PokemonCard> randomCards = await apiService.getTwoRandomCards();
      
      setState(() {
        card1 = randomCards[0];
        card2 = randomCards[1];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading cards: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _battle() {
    if (card1 == null || card2 == null) return;

    setState(() {
      hasBattled = true;
      
      if (card1!.hp > card2!.hp) {
        winner = card1;
      } else if (card2!.hp > card1!.hp) {
        winner = card2;
      } else {
        // If HP is equal, random winner
        winner = Random().nextBool() ? card1 : card2;
      }
    });

    // Save battle to history
    _saveBattleHistory();
  }

  Future<void> _saveBattleHistory() async {
    if (card1 == null || card2 == null || winner == null) return;

    try {
      BattleHistory battle = BattleHistory(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        winner: winner!,
        loser: winner == card1 ? card2! : card1!,
        battleDate: DateTime.now(),
      );

      await dbHelper.saveBattleHistory(battle);
      await _loadBattleHistory(); // Refresh history
    } catch (e) {
      print('Error saving battle history: $e');
    }
  }

  Widget _buildCard(PokemonCard? card, String title, {bool isWinner = false}) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                if (card != null) ...[
                  Container(
                    width: 150,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        card.imageSmall,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.image_not_supported,
                              size: 50,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    card.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.red,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      'HP: ${card.hp}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red[700],
                      ),
                    ),
                  ),
                  if (isWinner && hasBattled) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        '👑 WINNER!',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ] else ...[
                  Container(
                    width: 150,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text('Loading...'),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBattleHistory() {
    if (battleHistory.isEmpty) {
      return const Center(
        child: Text(
          'No battles yet!',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Battle History (${battleHistory.length} battles)',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...battleHistory.reversed.take(5).map((battle) {
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.emoji_events,
                  color: Colors.green,
                ),
              ),
              title: Text(
                '${battle.winner.name} defeated ${battle.loser.name}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'HP: ${battle.winner.hp} vs ${battle.loser.hp} • ${_formatDate(battle.battleDate)}',
              ),
              trailing: Text(
                '${battle.winner.hp} HP',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
            ),
          );
        }).toList(),
        if (battleHistory.length > 5)
          Center(
            child: Text(
              '... and ${battleHistory.length - 5} more battles',
              style: const TextStyle(color: Colors.grey),
            ),
          ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokémon Battle Arena'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Battle History'),
                  content: SizedBox(
                    width: double.maxFinite,
                    height: 400,
                    child: SingleChildScrollView(
                      child: _buildBattleHistory(),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                    if (battleHistory.isNotEmpty)
                      TextButton(
                        onPressed: () async {
                          await dbHelper.clearBattleHistory();
                          await _loadBattleHistory();
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Battle history cleared!'),
                            ),
                          );
                        },
                        child: const Text('Clear History'),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (hasBattled && winner != null) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        border: Border.all(color: Colors.green),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.emoji_events, color: Colors.green, size: 32),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              '${winner!.name} wins with ${winner!.hp} HP!',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  Expanded(
                    child: Row(
                      children: [
                        _buildCard(
                          card1, 
                          'Fighter 1',
                          isWinner: hasBattled && winner == card1,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: const Text(
                            'VS',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        _buildCard(
                          card2, 
                          'Fighter 2',
                          isWinner: hasBattled && winner == card2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (!hasBattled && card1 != null && card2 != null && !isLoading)
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _battle,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.flash_on, size: 24),
                          SizedBox(width: 8),
                          Text(
                            'BATTLE!',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (hasBattled || isLoading)
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _startNewBattle,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (isLoading) ...[
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text('Loading...'),
                          ] else ...[
                            const Icon(Icons.refresh, size: 24),
                            const SizedBox(width: 8),
                            const Text(
                              'NEW BATTLE',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ],
                      ),
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