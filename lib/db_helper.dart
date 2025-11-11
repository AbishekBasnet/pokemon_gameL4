import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PokemonCard {
  final String id;
  final String name;
  final String imageSmall;
  final String imageLarge;
  final int hp;

  PokemonCard({
    required this.id,
    required this.name,
    required this.imageSmall,
    required this.imageLarge,
    required this.hp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageSmall': imageSmall,
      'imageLarge': imageLarge,
      'hp': hp,
    };
  }

  factory PokemonCard.fromMap(Map<String, dynamic> map) {
    return PokemonCard(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      imageSmall: map['imageSmall'] ?? '',
      imageLarge: map['imageLarge'] ?? '',
      hp: map['hp'] ?? 50,
    );
  }

  String toJson() => json.encode(toMap());

  factory PokemonCard.fromJson(String source) => 
      PokemonCard.fromMap(json.decode(source));
}

class BattleHistory {
  final String id;
  final PokemonCard winner;
  final PokemonCard loser;
  final DateTime battleDate;

  BattleHistory({
    required this.id,
    required this.winner,
    required this.loser,
    required this.battleDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'winner': winner.toMap(),
      'loser': loser.toMap(),
      'battleDate': battleDate.toIso8601String(),
    };
  }

  factory BattleHistory.fromMap(Map<String, dynamic> map) {
    return BattleHistory(
      id: map['id'] ?? '',
      winner: PokemonCard.fromMap(map['winner'] ?? {}),
      loser: PokemonCard.fromMap(map['loser'] ?? {}),
      battleDate: DateTime.parse(map['battleDate'] ?? DateTime.now().toIso8601String()),
    );
  }

  String toJson() => json.encode(toMap());

  factory BattleHistory.fromJson(String source) => 
      BattleHistory.fromMap(json.decode(source));
}

class DatabaseHelper {
  static DatabaseHelper? _instance;
  static const String _cardsKey = 'pokemon_cards';
  static const String _battleHistoryKey = 'battle_history';

  DatabaseHelper._internal();

  factory DatabaseHelper() {
    _instance ??= DatabaseHelper._internal();
    return _instance!;
  }

  Future<int> insertCard(PokemonCard card) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    // Get existing cards
    List<PokemonCard> cards = await getAllCards();
    
    // Add new card or update existing one
    int existingIndex = cards.indexWhere((c) => c.id == card.id);
    if (existingIndex != -1) {
      cards[existingIndex] = card;
    } else {
      cards.add(card);
    }
    
    // Save back to preferences
    List<String> cardsJson = cards.map((card) => card.toJson()).toList();
    await prefs.setStringList(_cardsKey, cardsJson);
    
    return cards.length;
  }

  Future<List<PokemonCard>> getAllCards() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? cardsJson = prefs.getStringList(_cardsKey);
    
    if (cardsJson == null) return [];
    
    return cardsJson.map((cardJson) => PokemonCard.fromJson(cardJson)).toList();
  }

  Future<int> getCardCount() async {
    List<PokemonCard> cards = await getAllCards();
    return cards.length;
  }

  Future<void> deleteAllCards() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cardsKey);
  }

  Future<void> close() async {
    // No cleanup needed for SharedPreferences
  }

  // Battle History methods
  Future<void> saveBattleHistory(BattleHistory battle) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    // Get existing battles
    List<BattleHistory> battles = await getAllBattleHistory();
    
    // Add new battle
    battles.add(battle);
    
    // Save back to preferences
    List<String> battlesJson = battles.map((battle) => battle.toJson()).toList();
    await prefs.setStringList(_battleHistoryKey, battlesJson);
  }

  Future<List<BattleHistory>> getAllBattleHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? battlesJson = prefs.getStringList(_battleHistoryKey);
    
    if (battlesJson == null) return [];
    
    return battlesJson.map((battleJson) => BattleHistory.fromJson(battleJson)).toList();
  }

  Future<void> clearBattleHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_battleHistoryKey);
  }
}