import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const FlashcardApp());
}

class FlashcardApp extends StatelessWidget {
  const FlashcardApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flashcard Quiz',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const FlashcardHomePage(),
    );
  }
}

class Flashcard {
  final String id;
  final String question;
  final String answer;
  bool isLearned;
  bool isExpanded;

  Flashcard({
    required this.id,
    required this.question,
    required this.answer,
    this.isLearned = false,
    this.isExpanded = false,
  });
}

class FlashcardHomePage extends StatefulWidget {
  const FlashcardHomePage({Key? key}) : super(key: key);

  @override
  State<FlashcardHomePage> createState() => _FlashcardHomePageState();
}

class _FlashcardHomePageState extends State<FlashcardHomePage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<Flashcard> _flashcards = [];
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _loadInitialCards();
  }

  void _loadInitialCards() {
    _flashcards = _generateFlashcards();
  }

  List<Flashcard> _generateFlashcards() {
    final questions = [
      {'q': 'What is Flutter?', 'a': 'A UI toolkit for building natively compiled applications from a single codebase'},
      {'q': 'What is a Widget in Flutter?', 'a': 'The basic building block of a Flutter UI - everything is a widget'},
      {'q': 'What is the difference between StatelessWidget and StatefulWidget?', 'a': 'StatelessWidget is immutable, StatefulWidget can maintain state that can change'},
      {'q': 'What is the purpose of setState()?', 'a': 'It notifies the framework that the internal state has changed and triggers a rebuild'},
      {'q': 'What is a BuildContext?', 'a': 'A handle to the location of a widget in the widget tree'},
      {'q': 'What is Dart?', 'a': 'The programming language used to write Flutter apps'},
      {'q': 'What is Hot Reload?', 'a': 'A feature that allows you to see changes instantly without restarting the app'},
      {'q': 'What is a ListView?', 'a': 'A scrollable list of widgets arranged linearly'},
      {'q': 'What is Material Design?', 'a': 'A design system created by Google that Flutter implements'},
      {'q': 'What is async/await?', 'a': 'Keywords used to handle asynchronous operations in Dart'},
    ];

    return questions.map((q) => Flashcard(
      id: DateTime.now().millisecondsSinceEpoch.toString() + Random().nextInt(1000).toString(),
      question: q['q']!,
      answer: q['a']!,
    )).toList();
  }

  Future<void> _refreshCards() async {
    setState(() {
      _isRefreshing = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _flashcards = _generateFlashcards();
      _isRefreshing = false;
    });
  }

  void _removeCard(int index) {
    final removedCard = _flashcards[index];
    setState(() {
      _flashcards[index].isLearned = true;
      _flashcards.removeAt(index);
    });

    _listKey.currentState?.removeItem(
      index,
          (context, animation) => _buildCardItem(removedCard, animation, index),
      duration: const Duration(milliseconds: 300),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Card marked as learned!'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            _undoRemove(index, removedCard);
          },
        ),
      ),
    );
  }

  void _undoRemove(int index, Flashcard card) {
    card.isLearned = false;
    setState(() {
      _flashcards.insert(index, card);
    });
    _listKey.currentState?.insertItem(index);
  }

  void _toggleCard(int index) {
    setState(() {
      _flashcards[index].isExpanded = !_flashcards[index].isExpanded;
    });
  }

  void _addNewCard() {
    final newCard = Flashcard(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      question: 'What is your custom question?',
      answer: 'This is a dynamically added flashcard!',
    );

    setState(() {
      _flashcards.insert(0, newCard);
    });

    _listKey.currentState?.insertItem(0);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('New flashcard added!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  int get _learnedCount {
    return _flashcards.where((card) => card.isLearned).length;
  }

  int get _totalCards {
    return _flashcards.length + _learnedCount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshCards,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 120.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'Progress: $_learnedCount of $_totalCards learned',
                  style: const TextStyle(fontSize: 16),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.deepPurple.shade400,
                        Colors.deepPurple.shade800,
                      ],
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        CircularProgressIndicator(
                          value: _totalCards > 0 ? _learnedCount / _totalCards : 0,
                          backgroundColor: Colors.white24,
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (_isRefreshing)
              const SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            _flashcards.isEmpty
                ? SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 80,
                      color: Colors.green.shade300,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'All cards learned!',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text('Pull down to get new cards'),
                  ],
                ),
              ),
            )
                : SliverAnimatedList(
              key: _listKey,
              initialItemCount: _flashcards.length,
              itemBuilder: (context, index, animation) {
                return _buildCardItem(_flashcards[index], animation, index);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNewCard,
        icon: const Icon(Icons.add),
        label: const Text('Add Card'),
      ),
    );
  }

  Widget _buildCardItem(Flashcard card, Animation<double> animation, int index) {
    return SizeTransition(
      sizeFactor: animation,
      child: Dismissible(
        key: Key(card.id),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          _removeCard(index);
        },
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20.0),
          color: Colors.green,
          child: const Icon(Icons.check, color: Colors.white, size: 32),
        ),
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 4,
          child: InkWell(
            onTap: () => _toggleCard(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.quiz,
                        color: Colors.deepPurple.shade400,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          card.question,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Icon(
                        card.isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  AnimatedCrossFade(
                    firstChild: const SizedBox.shrink(),
                    secondChild: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.lightbulb_outline,
                              color: Colors.amber.shade700,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Answer:',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          card.answer,
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text(
                              'Swipe left to mark as learned ',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            Icon(
                              Icons.arrow_back,
                              size: 16,
                              color: Colors.grey.shade400,
                            ),
                          ],
                        ),
                      ],
                    ),
                    crossFadeState: card.isExpanded
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 300),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}