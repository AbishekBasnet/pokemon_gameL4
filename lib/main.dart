import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'services/api_service.dart';
import 'card_detail_screen.dart';

void main() {
  runApp(const PokemonCardApp());
}

class PokemonCardApp extends StatelessWidget {
  const PokemonCardApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokémon Trading Cards',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const PokemonCardList(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PokemonCardList extends StatefulWidget {
  const PokemonCardList({Key? key}) : super(key: key);

  @override
  State<PokemonCardList> createState() => _PokemonCardListState();
}

class _PokemonCardListState extends State<PokemonCardList> {
  List<PokemonCard> cards = [];
  bool isLoading = false;
  bool hasError = false;
  String errorMessage = '';
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    setState(() {
      isLoading = true;
      hasError = false;
      errorMessage = '';
    });

    try {
      // Check if database is empty
      bool isEmpty = await apiService.isDatabaseEmpty();
      
      if (isEmpty) {
        // Fetch cards from API if database is empty
        bool success = await apiService.fetchAndStoreCards();
        if (!success) {
          setState(() {
            hasError = true;
            errorMessage = 'Failed to fetch cards from API';
            isLoading = false;
          });
          return;
        }
      }

      // Load cards from database
      List<PokemonCard> loadedCards = await apiService.getCardsFromDatabase();
      
      setState(() {
        cards = loadedCards;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        hasError = true;
        errorMessage = 'Error loading cards: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _refreshCards() async {
    await _loadCards();
  }

  void _navigateToDetail(PokemonCard card) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CardDetailScreen(card: card),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokémon Trading Cards'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: isLoading ? null : _refreshCards,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Loading Pokémon cards...',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      );
    }

    if (hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              errorMessage,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _refreshCards,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (cards.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.credit_card,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No cards found',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshCards,
      child: ListView.builder(
        itemCount: cards.length,
        itemBuilder: (context, index) {
          final card = cards[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              leading: SizedBox(
                width: 60,
                height: 60,
                child: card.imageSmall.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          card.imageSmall,
                          fit: BoxFit.cover,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                            return const Icon(
                              Icons.image_not_supported,
                              size: 30,
                              color: Colors.grey,
                            );
                          },
                        ),
                      )
                    : const Icon(
                        Icons.image_not_supported,
                        size: 30,
                        color: Colors.grey,
                      ),
              ),
              title: Text(
                card.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                'ID: ${card.id}',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _navigateToDetail(card),
            ),
          );
        },
      ),
    );
  }
}