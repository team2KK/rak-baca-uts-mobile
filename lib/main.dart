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
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff4b3769)),
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

  @override
  Widget build(BuildContext context) {
    final matches = books.where((book) {
      final keywords = '${book.title} ${book.author} ${book.genre}'
          .toLowerCase();
      return keywords.contains(query) &&
          (!onlyFavorites || favorites.contains(book.id));
    }).toList();
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: ListView(
              padding: const EdgeInsets.all(18),
              children: [
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xff33244d),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.fromLTRB(20, 24, 82, 24),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rak Baca',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Katalog buku klasik',
                            style: TextStyle(color: Color(0xffe3d7f2)),
                          ),
                        ],
                      ),
                    ),
                    const Positioned(
                      right: 20,
                      bottom: 20,
                      child: Icon(
                        Icons.menu_book_outlined,
                        size: 42,
                        color: Color(0xffdcc7ff),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Cari judul, penulis, atau genre',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) =>
                      setState(() => query = value.trim().toLowerCase()),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: FilterChip(
                    label: Text('Favorit (${favorites.length})'),
                    selected: onlyFavorites,
                    onSelected: (value) =>
                        setState(() => onlyFavorites = value),
                  ),
                ),
                Text(
                  '${matches.length} buku',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (matches.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Text(
                      'Tidak ada buku yang cocok. Ubah kata kunci atau filter.',
                    ),
                  ),
                for (final book in matches)
                  Card(
                    margin: const EdgeInsets.only(top: 10),
                    elevation: 0,
                    color: Theme.of(context).colorScheme.surfaceContainerLow,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/${book.id}.jpg',
                            width: 56,
                            height: 78,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => const SizedBox(
                              width: 56,
                              height: 78,
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
                                Text(book.author),
                                Text(book.genre),
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
