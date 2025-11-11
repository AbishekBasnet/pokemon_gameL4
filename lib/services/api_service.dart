import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../db_helper.dart';

class ApiService {
  static const String baseUrl = 'https://api.pokemontcg.io/v2/cards';
  static const String apiKey = 'e3d8235f-a5b8-4c70-97ea-4bf3b746a44f';

  Future<bool> fetchAndStoreCards({int maxPages = 1}) async {
    try {
      print('Loading Pokemon dataset');
      DatabaseHelper dbHelper = DatabaseHelper();
      await dbHelper.deleteAllCards();
      return await _useMockData();
    } catch (e) {
      print('Error: e');
      return false;
    }
  }

  Future<bool> _useMockData() async {
    try {
      List<Map<String, dynamic>> pokemonData = _generatePokemonDataset();
      DatabaseHelper dbHelper = DatabaseHelper();
      await dbHelper.deleteAllCards();

      for (var cardData in pokemonData) {
        PokemonCard card = PokemonCard(
          id: cardData['id'],
          name: cardData['name'],
          imageSmall: cardData['imageSmall'],
          imageLarge: cardData['imageLarge'],
          hp: cardData['hp'],
        );
        await dbHelper.insertCard(card);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  List<Map<String, dynamic>> _generatePokemonDataset() {
    return [
      // Generation 1 - Starter Pokemon
      {'id': 'gen1-001', 'name': 'Bulbasaur', 'hp': 45, 'imageSmall': 'https://images.pokemontcg.io/base1/44.png', 'imageLarge': 'https://images.pokemontcg.io/base1/44_hires.png'},
      {'id': 'gen1-002', 'name': 'Ivysaur', 'hp': 60, 'imageSmall': 'https://images.pokemontcg.io/base1/30.png', 'imageLarge': 'https://images.pokemontcg.io/base1/30_hires.png'},
      {'id': 'gen1-003', 'name': 'Venusaur', 'hp': 100, 'imageSmall': 'https://images.pokemontcg.io/base1/15.png', 'imageLarge': 'https://images.pokemontcg.io/base1/15_hires.png'},
      {'id': 'gen1-004', 'name': 'Charmander', 'hp': 50, 'imageSmall': 'https://images.pokemontcg.io/base1/46.png', 'imageLarge': 'https://images.pokemontcg.io/base1/46_hires.png'},
      {'id': 'gen1-005', 'name': 'Charmeleon', 'hp': 68, 'imageSmall': 'https://images.pokemontcg.io/base1/24.png', 'imageLarge': 'https://images.pokemontcg.io/base1/24_hires.png'},
      {'id': 'gen1-006', 'name': 'Charizard', 'hp': 120, 'imageSmall': 'https://images.pokemontcg.io/base1/4.png', 'imageLarge': 'https://images.pokemontcg.io/base1/4_hires.png'},
      {'id': 'gen1-007', 'name': 'Squirtle', 'hp': 40, 'imageSmall': 'https://images.pokemontcg.io/base1/63.png', 'imageLarge': 'https://images.pokemontcg.io/base1/63_hires.png'},
      {'id': 'gen1-008', 'name': 'Wartortle', 'hp': 65, 'imageSmall': 'https://images.pokemontcg.io/base1/42.png', 'imageLarge': 'https://images.pokemontcg.io/base1/42_hires.png'},
      {'id': 'gen1-009', 'name': 'Blastoise', 'hp': 100, 'imageSmall': 'https://images.pokemontcg.io/base1/2.png', 'imageLarge': 'https://images.pokemontcg.io/base1/2_hires.png'},
      
      // Electric Pokemon
      {'id': 'gen1-025', 'name': 'Pikachu', 'hp': 40, 'imageSmall': 'https://images.pokemontcg.io/base1/58.png', 'imageLarge': 'https://images.pokemontcg.io/base1/58_hires.png'},
      {'id': 'gen1-026', 'name': 'Raichu', 'hp': 90, 'imageSmall': 'https://images.pokemontcg.io/base1/14.png', 'imageLarge': 'https://images.pokemontcg.io/base1/14_hires.png'},
      {'id': 'gen1-081', 'name': 'Magnemite', 'hp': 40, 'imageSmall': 'https://images.pokemontcg.io/base1/53.png', 'imageLarge': 'https://images.pokemontcg.io/base1/53_hires.png'},
      {'id': 'gen1-082', 'name': 'Magneton', 'hp': 60, 'imageSmall': 'https://images.pokemontcg.io/base1/9.png', 'imageLarge': 'https://images.pokemontcg.io/base1/9_hires.png'},
      {'id': 'gen1-100', 'name': 'Voltorb', 'hp': 40, 'imageSmall': 'https://images.pokemontcg.io/base1/67.png', 'imageLarge': 'https://images.pokemontcg.io/base1/67_hires.png'},
      
      // Psychic Pokemon
      {'id': 'gen1-063', 'name': 'Abra', 'hp': 30, 'imageSmall': 'https://images.pokemontcg.io/base1/43.png', 'imageLarge': 'https://images.pokemontcg.io/base1/43_hires.png'},
      {'id': 'gen1-064', 'name': 'Kadabra', 'hp': 60, 'imageSmall': 'https://images.pokemontcg.io/base1/32.png', 'imageLarge': 'https://images.pokemontcg.io/base1/32_hires.png'},
      {'id': 'gen1-065', 'name': 'Alakazam', 'hp': 80, 'imageSmall': 'https://images.pokemontcg.io/base1/1.png', 'imageLarge': 'https://images.pokemontcg.io/base1/1_hires.png'},
      {'id': 'gen1-096', 'name': 'Drowzee', 'hp': 50, 'imageSmall': 'https://images.pokemontcg.io/base1/49.png', 'imageLarge': 'https://images.pokemontcg.io/base1/49_hires.png'},
      {'id': 'gen1-097', 'name': 'Hypno', 'hp': 90, 'imageSmall': 'https://images.pokemontcg.io/fossil/8.png', 'imageLarge': 'https://images.pokemontcg.io/fossil/8_hires.png'},
      
      // Fighting Pokemon
      {'id': 'gen1-056', 'name': 'Mankey', 'hp': 30, 'imageSmall': 'https://images.pokemontcg.io/jungle/55.png', 'imageLarge': 'https://images.pokemontcg.io/jungle/55_hires.png'},
      {'id': 'gen1-057', 'name': 'Primeape', 'hp': 70, 'imageSmall': 'https://images.pokemontcg.io/jungle/43.png', 'imageLarge': 'https://images.pokemontcg.io/jungle/43_hires.png'},
      {'id': 'gen1-066', 'name': 'Machop', 'hp': 50, 'imageSmall': 'https://images.pokemontcg.io/base1/52.png', 'imageLarge': 'https://images.pokemontcg.io/base1/52_hires.png'},
      {'id': 'gen1-067', 'name': 'Machoke', 'hp': 80, 'imageSmall': 'https://images.pokemontcg.io/base1/34.png', 'imageLarge': 'https://images.pokemontcg.io/base1/34_hires.png'},
      {'id': 'gen1-068', 'name': 'Machamp', 'hp': 100, 'imageSmall': 'https://images.pokemontcg.io/base1/8.png', 'imageLarge': 'https://images.pokemontcg.io/base1/8_hires.png'},
      {'id': 'gen1-106', 'name': 'Hitmonlee', 'hp': 60, 'imageSmall': 'https://images.pokemontcg.io/fossil/7.png', 'imageLarge': 'https://images.pokemontcg.io/fossil/7_hires.png'},
      {'id': 'gen1-107', 'name': 'Hitmonchan', 'hp': 70, 'imageSmall': 'https://images.pokemontcg.io/base1/7.png', 'imageLarge': 'https://images.pokemontcg.io/base1/7_hires.png'},
      
      // Ghost Pokemon
      {'id': 'gen1-092', 'name': 'Gastly', 'hp': 30, 'imageSmall': 'https://images.pokemontcg.io/base1/50.png', 'imageLarge': 'https://images.pokemontcg.io/base1/50_hires.png'},
      {'id': 'gen1-093', 'name': 'Haunter', 'hp': 60, 'imageSmall': 'https://images.pokemontcg.io/base1/21.png', 'imageLarge': 'https://images.pokemontcg.io/base1/21_hires.png'},
      {'id': 'gen1-094', 'name': 'Gengar', 'hp': 60, 'imageSmall': 'https://images.pokemontcg.io/fossil/5.png', 'imageLarge': 'https://images.pokemontcg.io/fossil/5_hires.png'},
      
      // Water Pokemon
      {'id': 'gen1-054', 'name': 'Psyduck', 'hp': 50, 'imageSmall': 'https://images.pokemontcg.io/fossil/53.png', 'imageLarge': 'https://images.pokemontcg.io/fossil/53_hires.png'},
      {'id': 'gen1-055', 'name': 'Golduck', 'hp': 70, 'imageSmall': 'https://images.pokemontcg.io/fossil/35.png', 'imageLarge': 'https://images.pokemontcg.io/fossil/35_hires.png'},
      {'id': 'gen1-060', 'name': 'Poliwag', 'hp': 40, 'imageSmall': 'https://images.pokemontcg.io/base1/59.png', 'imageLarge': 'https://images.pokemontcg.io/base1/59_hires.png'},
      {'id': 'gen1-061', 'name': 'Poliwhirl', 'hp': 60, 'imageSmall': 'https://images.pokemontcg.io/base1/38.png', 'imageLarge': 'https://images.pokemontcg.io/base1/38_hires.png'},
      {'id': 'gen1-062', 'name': 'Poliwrath', 'hp': 90, 'imageSmall': 'https://images.pokemontcg.io/base1/13.png', 'imageLarge': 'https://images.pokemontcg.io/base1/13_hires.png'},
      {'id': 'gen1-090', 'name': 'Shellder', 'hp': 30, 'imageSmall': 'https://images.pokemontcg.io/fossil/54.png', 'imageLarge': 'https://images.pokemontcg.io/fossil/54_hires.png'},
      {'id': 'gen1-091', 'name': 'Cloyster', 'hp': 50, 'imageSmall': 'https://images.pokemontcg.io/fossil/32.png', 'imageLarge': 'https://images.pokemontcg.io/fossil/32_hires.png'},
      {'id': 'gen1-116', 'name': 'Horsea', 'hp': 30, 'imageSmall': 'https://images.pokemontcg.io/fossil/49.png', 'imageLarge': 'https://images.pokemontcg.io/fossil/49_hires.png'},
      {'id': 'gen1-117', 'name': 'Seadra', 'hp': 60, 'imageSmall': 'https://images.pokemontcg.io/fossil/42.png', 'imageLarge': 'https://images.pokemontcg.io/fossil/42_hires.png'},
      {'id': 'gen1-098', 'name': 'Krabby', 'hp': 30, 'imageSmall': 'https://images.pokemontcg.io/fossil/51.png', 'imageLarge': 'https://images.pokemontcg.io/fossil/51_hires.png'},
      {'id': 'gen1-099', 'name': 'Kingler', 'hp': 60, 'imageSmall': 'https://images.pokemontcg.io/fossil/38.png', 'imageLarge': 'https://images.pokemontcg.io/fossil/38_hires.png'},
      {'id': 'gen1-118', 'name': 'Goldeen', 'hp': 40, 'imageSmall': 'https://images.pokemontcg.io/jungle/53.png', 'imageLarge': 'https://images.pokemontcg.io/jungle/53_hires.png'},
      {'id': 'gen1-119', 'name': 'Seaking', 'hp': 70, 'imageSmall': 'https://images.pokemontcg.io/jungle/46.png', 'imageLarge': 'https://images.pokemontcg.io/jungle/46_hires.png'},
      {'id': 'gen1-120', 'name': 'Staryu', 'hp': 40, 'imageSmall': 'https://images.pokemontcg.io/base1/65.png', 'imageLarge': 'https://images.pokemontcg.io/base1/65_hires.png'},
      {'id': 'gen1-121', 'name': 'Starmie', 'hp': 60, 'imageSmall': 'https://images.pokemontcg.io/base1/64.png', 'imageLarge': 'https://images.pokemontcg.io/base1/64_hires.png'},
      {'id': 'gen1-129', 'name': 'Magikarp', 'hp': 30, 'imageSmall': 'https://images.pokemontcg.io/base1/35.png', 'imageLarge': 'https://images.pokemontcg.io/base1/35_hires.png'},
      {'id': 'gen1-130', 'name': 'Gyarados', 'hp': 100, 'imageSmall': 'https://images.pokemontcg.io/base1/6.png', 'imageLarge': 'https://images.pokemontcg.io/base1/6_hires.png'},
      {'id': 'gen1-131', 'name': 'Lapras', 'hp': 80, 'imageSmall': 'https://images.pokemontcg.io/fossil/10.png', 'imageLarge': 'https://images.pokemontcg.io/fossil/10_hires.png'},
      {'id': 'gen1-134', 'name': 'Vaporeon', 'hp': 80, 'imageSmall': 'https://images.pokemontcg.io/jungle/12.png', 'imageLarge': 'https://images.pokemontcg.io/jungle/12_hires.png'},
      
      // Fire Pokemon
      {'id': 'gen1-037', 'name': 'Vulpix', 'hp': 50, 'imageSmall': 'https://images.pokemontcg.io/base1/68.png', 'imageLarge': 'https://images.pokemontcg.io/base1/68_hires.png'},
      {'id': 'gen1-038', 'name': 'Ninetales', 'hp': 80, 'imageSmall': 'https://images.pokemontcg.io/base1/12.png', 'imageLarge': 'https://images.pokemontcg.io/base1/12_hires.png'},
      {'id': 'gen1-058', 'name': 'Growlithe', 'hp': 60, 'imageSmall': 'https://images.pokemontcg.io/base1/28.png', 'imageLarge': 'https://images.pokemontcg.io/base1/28_hires.png'},
      {'id': 'gen1-059', 'name': 'Arcanine', 'hp': 100, 'imageSmall': 'https://images.pokemontcg.io/base1/23.png', 'imageLarge': 'https://images.pokemontcg.io/base1/23_hires.png'},
      {'id': 'gen1-077', 'name': 'Ponyta', 'hp': 40, 'imageSmall': 'https://images.pokemontcg.io/base1/60.png', 'imageLarge': 'https://images.pokemontcg.io/base1/60_hires.png'},
      {'id': 'gen1-078', 'name': 'Rapidash', 'hp': 70, 'imageSmall': 'https://images.pokemontcg.io/jungle/44.png', 'imageLarge': 'https://images.pokemontcg.io/jungle/44_hires.png'},
      {'id': 'gen1-126', 'name': 'Magmar', 'hp': 50, 'imageSmall': 'https://images.pokemontcg.io/base1/36.png', 'imageLarge': 'https://images.pokemontcg.io/base1/36_hires.png'},
      {'id': 'gen1-135', 'name': 'Jolteon', 'hp': 70, 'imageSmall': 'https://images.pokemontcg.io/jungle/4.png', 'imageLarge': 'https://images.pokemontcg.io/jungle/4_hires.png'},
      {'id': 'gen1-136', 'name': 'Flareon', 'hp': 70, 'imageSmall': 'https://images.pokemontcg.io/jungle/3.png', 'imageLarge': 'https://images.pokemontcg.io/jungle/3_hires.png'},
      {'id': 'gen1-146', 'name': 'Moltres', 'hp': 70, 'imageSmall': 'https://images.pokemontcg.io/fossil/12.png', 'imageLarge': 'https://images.pokemontcg.io/fossil/12_hires.png'},
      
      // Legendary Pokemon
      {'id': 'gen1-144', 'name': 'Articuno', 'hp': 70, 'imageSmall': 'https://images.pokemontcg.io/fossil/2.png', 'imageLarge': 'https://images.pokemontcg.io/fossil/2_hires.png'},
      {'id': 'gen1-145', 'name': 'Zapdos', 'hp': 90, 'imageSmall': 'https://images.pokemontcg.io/base1/16.png', 'imageLarge': 'https://images.pokemontcg.io/base1/16_hires.png'},
      {'id': 'gen1-149', 'name': 'Dragonite', 'hp': 100, 'imageSmall': 'https://images.pokemontcg.io/fossil/4.png', 'imageLarge': 'https://images.pokemontcg.io/fossil/4_hires.png'},
      {'id': 'gen1-150', 'name': 'Mewtwo', 'hp': 60, 'imageSmall': 'https://images.pokemontcg.io/base1/10.png', 'imageLarge': 'https://images.pokemontcg.io/base1/10_hires.png'},
      {'id': 'gen1-151', 'name': 'Mew', 'hp': 50, 'imageSmall': 'https://images.pokemontcg.io/wizpromos/8.png', 'imageLarge': 'https://images.pokemontcg.io/wizpromos/8_hires.png'},
    ];
  }

  Future<List<PokemonCard>> getCardsFromDatabase() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    return await dbHelper.getAllCards();
  }

  Future<bool> isDatabaseEmpty() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    int count = await dbHelper.getCardCount();
    return count == 0;
  }

  Future<List<PokemonCard>> getTwoRandomCards() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    List<PokemonCard> allCards = await dbHelper.getAllCards();
    if (allCards.length < 2) {
      throw Exception('Not enough cards available for battle');
    }
    
    // Use a more robust randomization method
    final random = Random();
    List<PokemonCard> selectedCards = [];
    
    // Select first card
    int firstIndex = random.nextInt(allCards.length);
    selectedCards.add(allCards[firstIndex]);
    
    // Select second card (ensure it's different from the first)
    int secondIndex;
    do {
      secondIndex = random.nextInt(allCards.length);
    } while (secondIndex == firstIndex && allCards.length > 1);
    selectedCards.add(allCards[secondIndex]);
    
    return selectedCards;
  }
}
