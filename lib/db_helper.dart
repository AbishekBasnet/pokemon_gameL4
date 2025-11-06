import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PokemonCard {
  final String id;
  final String name;
  final String imageSmall;
  final String imageLarge;

  PokemonCard({
    required this.id,
    required this.name,
    required this.imageSmall,
    required this.imageLarge,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageSmall': imageSmall,
      'imageLarge': imageLarge,
    };
  }

  factory PokemonCard.fromMap(Map<String, dynamic> map) {
    return PokemonCard(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      imageSmall: map['imageSmall'] ?? '',
      imageLarge: map['imageLarge'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PokemonCard.fromJson(String source) => 
      PokemonCard.fromMap(json.decode(source));
}

class DatabaseHelper {
  static DatabaseHelper? _instance;
  static const String _cardsKey = 'pokemon_cards';

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
}