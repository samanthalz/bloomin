import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'webview_page.dart';

class LearningPage extends StatefulWidget {
  static const routeName = '/learning';

  const LearningPage({super.key});

  @override
  State<LearningPage> createState() => _LearningPageState();
}

class _LearningPageState extends State<LearningPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  final String apiKey = '04d6fa829c0242c0a0bee11470464327';

  final String query =
      'menstrual health OR period tips OR menstruation OR menstrual hygiene OR menstrual education OR women period OR period pain OR hormonal health';

  List articles = [];
  bool isLoading = true;
  int currentPage = 1;
  bool showLoadMore = false;
  String searchText = '';

  @override
  void initState() {
    super.initState();
    fetchArticles();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      setState(() => showLoadMore = true);
    } else {
      setState(() => showLoadMore = false);
    }
  }

  Future<void> fetchArticles() async {
    final url =
        'https://newsapi.org/v2/everything?q=${Uri.encodeComponent(query)}&language=en&pageSize=10&page=$currentPage&sortBy=publishedAt&apiKey=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);
      setState(() {
        articles.addAll(data['articles']);
        isLoading = false;
        currentPage++;
      });
    } catch (e) {
      debugPrint("Error fetching articles: $e");
      setState(() => isLoading = false);
    }
  }

  List get filteredArticles {
    if (searchText.isEmpty) return articles;
    return articles
        .where(
          (article) =>
              (article['title'] ?? '').toLowerCase().contains(
                searchText.toLowerCase(),
              ) ||
              (article['description'] ?? '').toLowerCase().contains(
                searchText.toLowerCase(),
              ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Learning"),
        centerTitle: true,
        backgroundColor: Colors.purple[100],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search articles...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon:
                    _searchController.text.isNotEmpty
                        ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              searchText = '';
                              _searchController.clear();
                            });
                          },
                        )
                        : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (val) {
                setState(() => searchText = val);
              },
            ),
          ),
          Expanded(
            child:
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : RefreshIndicator(
                      onRefresh: () async {
                        setState(() {
                          articles.clear();
                          currentPage = 1;
                          isLoading = true;
                        });
                        await fetchArticles();
                      },
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: filteredArticles.length,
                        itemBuilder: (context, index) {
                          final article = filteredArticles[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            child: ListTile(
                              leading:
                                  article['urlToImage'] != null
                                      ? Image.network(
                                        article['urlToImage'],
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (_, __, ___) => const Icon(
                                              Icons.image_not_supported,
                                            ),
                                      )
                                      : const Icon(Icons.image),
                              title: Text(article['title'] ?? 'No Title'),
                              subtitle: Text(
                                article['source']['name'] ?? 'Unknown',
                              ),
                              trailing: const Icon(Icons.arrow_forward_ios),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => WebViewPage(
                                          url: article['url'],
                                          title: article['title'],
                                        ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
          ),
          if (showLoadMore && !isLoading)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ElevatedButton(
                onPressed: fetchArticles,
                child: const Text("Load More"),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
