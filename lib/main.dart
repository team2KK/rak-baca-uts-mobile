import 'package:flutter/material.dart';

import 'books.dart';

void main() => runApp(const RakBaca());

class RakBaca extends StatelessWidget {
  const RakBaca({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Rak Baca',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff32604d)),
    ),
    home: const LibraryScreen(),
  );
}

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  String query = '';
  bool onlyFavorites = false;
  final favorites = <int>{};
  final searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final matches = books.where((book) {
      final keywords = '${book.title} ${book.author} ${book.genre}'
          .toLowerCase();
      return keywords.contains(query) &&
          (!onlyFavorites || favorites.contains(book.id));
    }).toList();
    return Scaffold(
      backgroundColor: const Color(0xfff6f7f2),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              children: [
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xff214736),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.fromLTRB(20, 30, 82, 30),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rak Baca',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontFamily: 'serif',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Katalog buku klasik',
                            style: TextStyle(color: Color(0xffd5e3d6)),
                          ),
                        ],
                      ),
                    ),
                    const Positioned(
                      right: 20,
                      bottom: 20,
                      child: Icon(
                        Icons.auto_stories_outlined,
                        size: 42,
                        color: Color(0xffb9d3bf),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    labelText: 'Cari judul, penulis, atau genre',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: query.isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'Hapus kata kunci',
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              searchController.clear();
                              setState(() => query = '');
                            },
                          ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) =>
                      setState(() => query = value.trim().toLowerCase()),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  children: [
                    ChoiceChip(
                      label: const Text('Semua buku'),
                      selected: !onlyFavorites,
                      onSelected: (_) => setState(() => onlyFavorites = false),
                    ),
                    FilterChip(
                      label: Text('Favorit (${favorites.length})'),
                      selected: onlyFavorites,
                      onSelected: (value) =>
                          setState(() => onlyFavorites = value),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  '${matches.length} buku',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 6),
                if (matches.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Text(
                      onlyFavorites && query.isEmpty
                          ? 'Belum ada buku favorit.'
                          : 'Tidak ada buku yang cocok.',
                    ),
                  ),
                for (final book in matches)
                  Card(
                    margin: EdgeInsets.zero,
                    shape: const Border(
                      bottom: BorderSide(color: Color(0xffdce4de)),
                    ),
                    elevation: 0,
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 2,
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/${book.id}.jpg',
                            width: 62,
                            height: 88,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => const SizedBox(
                              width: 62,
                              height: 88,
                              child: Icon(Icons.book_outlined),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  book.title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium,
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  book.author,
                                  style: const TextStyle(
                                    color: Color(0xff45564c),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  book.genre,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            tooltip: favorites.contains(book.id)
                                ? 'Hapus dari favorit'
                                : 'Simpan ke favorit',
                            icon: Icon(
                              favorites.contains(book.id)
                                  ? Icons.bookmark
                                  : Icons.bookmark_border,
                            ),
                            onPressed: () => setState(() {
                              if (!favorites.add(book.id)) {
                                favorites.remove(book.id);
                              }
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
