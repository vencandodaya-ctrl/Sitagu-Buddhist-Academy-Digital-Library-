
import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://kwtjuwkbdlyewhnorizp.supabase.co',
    publishableKey: 'sb_publishable_i12wCIn739J8rs0TCx-PAg_MYap-yBY',
  );

  runApp(const SitaguLibraryApp());
}

class SitaguLibraryApp extends StatelessWidget {
  const SitaguLibraryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sitagu Buddhist Academy Digital Library',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF174B3A),
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F8F5),
      ),
      home: const LibraryHomePage(),
    );
  }
}

class LibraryHomePage extends StatelessWidget {
  const LibraryHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF174B3A),
        foregroundColor: Colors.white,
        title: const Text(
          'SITAGU DIGITAL LIBRARY',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.account_circle_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF174B3A),
                    Color(0xFF26745A),
                  ],
                  ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Sitagu Buddhist Academy',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Digital Library',
                    style: TextStyle(
                      color: Color(0xFFFFD98A),
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'A place for knowledge, wisdom and learning.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Search Library',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              decoration: InputDecoration(
                hintText: 'Search books, authors and subjects...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              'Library Categories',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Wrap(
  spacing: 12,
  runSpacing: 12,
  children: [
                CategoryCard(
                  icon: Icons.menu_book,
                  title: 'Pali Books',
                ),
                CategoryCard(
                  icon: Icons.auto_stories,
                  title: 'Buddhist Studies',
                ),
                CategoryCard(
                  icon: Icons.language,
                  title: 'English Books',
                ),
                CategoryCard(
                  icon: Icons.history_edu,
                  title: 'Research Papers',
                ),
              ],
            ),

            const SizedBox(height: 28),

            const Text(
              'Featured Collection',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.library_books,
                    size: 48,
                    color: Color(0xFF26745A),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Books and Learning Resources',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Your digital library collection will appear here.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            const Center(
              child: Text(
                'Sitagu Buddhist Academy',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}

class CategoryBooksPage extends StatefulWidget {
  final String title;

  const CategoryBooksPage({
    super.key,
    required this.title,
  });

  @override
  State<CategoryBooksPage> createState() =>
      _CategoryBooksPageState();
}

class _CategoryBooksPageState extends State<CategoryBooksPage> {
  late Future<List<Map<String, String>>> _booksFuture;

  @override
  void initState() {
    super.initState();
    _booksFuture = _loadBooks();
  }

  Future<List<Map<String, String>>> _loadBooks() async {
    final response = await Supabase.instance.client
        .from('books')
        .select()
        .eq('category', widget.title)
        .eq('is_published', true)
        .order('created_at', ascending: false);

    return response.map<Map<String, String>>((book) {
      return {
        'name': (book['title'] ?? 'Untitled').toString(),
        'author': (book['author'] ?? 'Unknown Author').toString(),
        'type': (book['category'] ?? '').toString(),
        'pdfUrl': (book['pdf_url'] ?? '').toString(),
        'description': (book['description'] ?? '').toString(),
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF174B3A),
        foregroundColor: Colors.white,
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<Map<String, String>>>(
        future: _booksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF26745A),
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Unable to load books.\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final books = snapshot.data ?? [];

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF174B3A),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${books.length} books',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 18),

              if (books.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Text('No books available yet.'),
                  ),
                ),

              ...books.map((book) {
                return Card(
                  color: Colors.white,
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookDetailPage(
                            book: book,
                          ),
                        ),
                      );
                    },
                    contentPadding: const EdgeInsets.all(12),
                    leading: Container(
                      width: 52,
                      height: 65,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE4F0E9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.menu_book,
                        size: 32,
                        color: Color(0xFF26745A),
                      ),
                    ),
                    title: Text(
                      book['name']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 7),
                      child: Text(
                        'Author: ${book['author']}\n'
                        'Type: ${book['type']}',
                      ),
                    ),
                    isThreeLine: true,
                  ),
                );
              }),

              const SizedBox(height: 15),
              const Center(
                child: Text(
                  'Sitagu Buddhist Academy Digital Library',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final IconData icon;
  final String title;

  const CategoryCard({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 155,
      height: 125,
      child: Card(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CategoryBooksPage(title: title),
              ),
            );
          },
          child:Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 35,
                  color: const Color(0xFF26745A),
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
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

class BookDetailPage extends StatelessWidget {
  final Map<String, String> book;

  const BookDetailPage({
    super.key,
    required this.book,
  });

  @override
  Widget build(BuildContext context) {
    final name = book['name'] ?? 'Unknown Book';
    final author = book['author'] ?? 'Unknown Author';
    final type = book['type'] ?? 'Not specified';
    final pdfUrl = book['pdfUrl'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF174B3A),
        foregroundColor: Colors.white,
        title: const Text('Book Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 150,
                height: 190,
                decoration: BoxDecoration(
                  color: const Color(0xFFE4F0E9),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.menu_book,
                  size: 90,
                  color: Color(0xFF26745A),
                ),
              ),
            ),
            const SizedBox(height: 25),
            Center(
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF174B3A),
                ),
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              'Book Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            _detailRow('Book Title', name),
            _detailRow('Author', author),
            _detailRow('Category', type),
            _detailRow('Language', 'Pali / English'),
            const SizedBox(height: 25),
            const Text(
              'About This Book',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '$name is part of the digital library collection '
              'of Sitagu Buddhist Academy.',
              style: const TextStyle(
                fontSize: 15,
                height: 1.7,
              ),
            ),

            const SizedBox(height: 25),
            if (pdfUrl != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF174B3A),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: const Icon(Icons.picture_as_pdf, size: 25),
                  label: const Text(
                    'Read PDF',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PdfReaderPage(
                          pdfUrl: pdfUrl,
                          bookName: name,
                        ),
                      ),
                    );
                  },
                ),
              )
            else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFE4F0E9),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons.picture_as_pdf,
                      size: 42,
                      color: Color(0xFF26745A),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'PDF Book',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'PDF file will be available soon.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 105,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF174B3A),
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}

class PdfReaderPage extends StatelessWidget {
  final String pdfUrl;
  final String bookName;

  const PdfReaderPage({
    super.key,
    required this.pdfUrl,
    required this.bookName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF174B3A),
        foregroundColor: Colors.white,
        title: Text(
          bookName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: PdfViewer.uri(
        Uri.parse(pdfUrl),
      ),
    );
  }
}
