import 'dart:convert';
import 'package:http/http.dart' as http;
import '../db_helper.dart';

class ApiService {
  static const String baseUrl = 'https://api.pokemontcg.io/v2/cards';
  static const int pageSize = 20;
  static const String apiKey = '6b4ed620-4f9d-4bf4-90ed-8bfa588004cc';

  Future<bool> fetchAndStoreCards() async {
    try {
      print('🔍 Fetching cards from API: $baseUrl?pageSize=$pageSize');
      
      // Try the direct API first
      final response = await http.get(
        Uri.parse('$baseUrl?pageSize=$pageSize'),
        headers: {
          'Content-Type': 'application/json',
          'X-Api-Key': apiKey,
        },
      ).timeout(Duration(seconds: 30));

      print('📡 API Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> cardsJson = data['data'] ?? [];

        print('📦 Found ${cardsJson.length} cards in API response');

        DatabaseHelper dbHelper = DatabaseHelper();
        
        // Clear existing cards before adding new ones
        await dbHelper.deleteAllCards();

        int cardCount = 0;
        for (var cardJson in cardsJson) {
          // Extract card data from API response
          String id = cardJson['id'] ?? '';
          String name = cardJson['name'] ?? 'Unknown';
          String imageSmall = '';
          String imageLarge = '';

          // Check if images exist in the response
          if (cardJson['images'] != null) {
            imageSmall = cardJson['images']['small'] ?? '';
            imageLarge = cardJson['images']['large'] ?? '';
          }

          print('🃏 Processing card: $name (ID: $id)');
          print('🖼️ Small image: $imageSmall');
          print('🖼️ Large image: $imageLarge');

          // Create PokemonCard object
          PokemonCard card = PokemonCard(
            id: id,
            name: name,
            imageSmall: imageSmall,
            imageLarge: imageLarge,
          );

          // Insert card into database
          await dbHelper.insertCard(card);
          cardCount++;
        }

        print('✅ Successfully stored $cardCount cards in database');
        return true;
      } else {
        print('❌ Failed to fetch cards: ${response.statusCode}');
        print('Response body: ${response.body}');
        return await _useMockData();
      }
    } catch (e) {
      print('💥 Error fetching cards: $e');
      print('🔄 Using mock data due to CORS/network issues');
      return await _useMockData();
    }
  }

  Future<bool> _useMockData() async {
    print('📝 Loading mock Pokémon cards for demo');
    
    // Mock Pokémon cards data for web demo
    List<Map<String, dynamic>> mockCards = [
      {
        'id': 'base1-1',
        'name': 'Alakazam',
        'images': {
          'small': 'https://images.pokemontcg.io/base1/1.png',
          'large': 'https://images.pokemontcg.io/base1/1_hires.png'
        }
      },
      {
        'id': 'base1-2',
        'name': 'Blastoise',
        'images': {
          'small': 'https://images.pokemontcg.io/base1/2.png',
          'large': 'https://images.pokemontcg.io/base1/2_hires.png'
        }
      },
      {
        'id': 'base1-3',
        'name': 'Chansey',
        'images': {
          'small': 'https://images.pokemontcg.io/base1/3.png',
          'large': 'https://images.pokemontcg.io/base1/3_hires.png'
        }
      },
      {
        'id': 'base1-4',
        'name': 'Charizard',
        'images': {
          'small': 'https://images.pokemontcg.io/base1/4.png',
          'large': 'https://images.pokemontcg.io/base1/4_hires.png'
        }
      },
      {
        'id': 'base1-5',
        'name': 'Clefairy',
        'images': {
          'small': 'https://images.pokemontcg.io/base1/5.png',
          'large': 'https://images.pokemontcg.io/base1/5_hires.png'
        }
      },
      {
        'id': 'base1-6',
        'name': 'Gyarados',
        'images': {
          'small': 'https://images.pokemontcg.io/base1/6.png',
          'large': 'https://images.pokemontcg.io/base1/6_hires.png'
        }
      },
      {
        'id': 'base1-7',
        'name': 'Hitmonchan',
        'images': {
          'small': 'https://images.pokemontcg.io/base1/7.png',
          'large': 'https://images.pokemontcg.io/base1/7_hires.png'
        }
      },
      {
        'id': 'base1-8',
        'name': 'Machamp',
        'images': {
          'small': 'https://images.pokemontcg.io/base1/8.png',
          'large': 'https://images.pokemontcg.io/base1/8_hires.png'
        }
      },
      {
        'id': 'base1-9',
        'name': 'Magneton',
        'images': {
          'small': 'https://images.pokemontcg.io/base1/9.png',
          'large': 'https://images.pokemontcg.io/base1/9_hires.png'
        }
      },
      {
        'id': 'base1-10',
        'name': 'Mewtwo',
        'images': {
          'small': 'https://images.pokemontcg.io/base1/10.png',
          'large': 'https://images.pokemontcg.io/base1/10_hires.png'
        }
      },
      {
        'id': 'base1-11',
        'name': 'Nidoking',
        'images': {
          'small': 'https://images.pokemontcg.io/base1/11.png',
          'large': 'https://images.pokemontcg.io/base1/11_hires.png'
        }
      },
      {
        'id': 'base1-12',
        'name': 'Ninetales',
        'images': {
          'small': 'https://images.pokemontcg.io/base1/12.png',
          'large': 'https://images.pokemontcg.io/base1/12_hires.png'
        }
      },
      {
        'id': 'base1-13',
        'name': 'Poliwrath',
        'images': {
          'small': 'https://images.pokemontcg.io/base1/13.png',
          'large': 'https://images.pokemontcg.io/base1/13_hires.png'
        }
      },
      {
        'id': 'base1-14',
        'name': 'Raichu',
        'images': {
          'small': 'https://images.pokemontcg.io/base1/14.png',
          'large': 'https://images.pokemontcg.io/base1/14_hires.png'
        }
      },
      {
        'id': 'base1-15',
        'name': 'Venomoth',
        'images': {
          'small': 'https://images.pokemontcg.io/base1/15.png',
          'large': 'https://images.pokemontcg.io/base1/15_hires.png'
        }
      },
      {
        'id': 'base1-16',
        'name': 'Venusaur',
        'images': {
          'small': 'https://images.pokemontcg.io/base1/16.png',
          'large': 'https://images.pokemontcg.io/base1/16_hires.png'
        }
      },
      {
        'id': 'base1-17',
        'name': 'Zapdos',
        'images': {
          'small': 'https://images.pokemontcg.io/base1/17.png',
          'large': 'https://images.pokemontcg.io/base1/17_hires.png'
        }
      },
      {
        'id': 'base1-25',
        'name': 'Pikachu',
        'images': {
          'small': 'https://images.pokemontcg.io/base1/25.png',
          'large': 'https://images.pokemontcg.io/base1/25_hires.png'
        }
      }
    ];

    DatabaseHelper dbHelper = DatabaseHelper();
    await dbHelper.deleteAllCards();

    int cardCount = 0;
    for (var cardJson in mockCards) {
      String id = cardJson['id'] ?? '';
      String name = cardJson['name'] ?? 'Unknown';
      String imageSmall = cardJson['images']?['small'] ?? '';
      String imageLarge = cardJson['images']?['large'] ?? '';

      print('🃏 Processing mock card: $name (ID: $id)');

      PokemonCard card = PokemonCard(
        id: id,
        name: name,
        imageSmall: imageSmall,
        imageLarge: imageLarge,
      );

      await dbHelper.insertCard(card);
      cardCount++;
    }

    print('✅ Successfully stored $cardCount mock cards in database');
    return true;
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
}