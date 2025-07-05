import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'video_player_page.dart';
import 'webview_page.dart';
import 'quiz_page.dart';
import 'quiz_data.dart';

class LearningPage extends StatefulWidget {
  static const routeName = '/learning';
  const LearningPage({super.key});

  @override
  State<LearningPage> createState() => _LearningPageState();
}

class _LearningPageState extends State<LearningPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  int _currentTab = 0;
  final TextEditingController _search = TextEditingController();
  final ScrollController _articleCtrl = ScrollController();
  final ScrollController _videoCtrl = ScrollController();

  final String newsKey = '04d6fa829c0242c0a0bee11470464327';
  final String ytKey = 'AIzaSyAXZJWjhx6yzmzhK_Ie8ZQUvp8PP6Q_Rzg';

  final String baseQuery =
      'menstrual health OR period tips OR menstruation OR menstrual hygiene '
      'OR menstrual education OR women period OR period pain OR hormonal health';

  List articles = [];
  List videos = [];

  int articlePage = 1;
  String? nextVideoToken = '';
  bool isNewsLoading = true;
  bool isVideoLoading = true;
  bool moreNewsLoading = false;
  bool moreVideoLoading = false;
  String searchText = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() => _currentTab = _tabController.index);
    });

    fetchArticles();
    fetchVideos();
    _articleCtrl.addListener(_checkArticleScroll);
    _videoCtrl.addListener(_checkVideoScroll);
  }

  Future<void> fetchArticles({bool loadMore = false}) async {
    if (loadMore) setState(() => moreNewsLoading = true);
    final url =
        'https://newsapi.org/v2/everything?q=${Uri.encodeComponent(baseQuery)}'
        '&language=en&pageSize=10&page=$articlePage&sortBy=publishedAt&apiKey=$newsKey';

    try {
      final res = await http.get(Uri.parse(url));
      final data = jsonDecode(res.body);
      setState(() {
        articles.addAll(data['articles']);
        articlePage++;
      });
    } catch (e) {
      debugPrint('News fetch error: $e');
    } finally {
      setState(() {
        isNewsLoading = false;
        moreNewsLoading = false;
      });
    }
  }

  Future<void> fetchVideos({bool loadMore = false}) async {
    if (loadMore && (nextVideoToken == null || nextVideoToken!.isEmpty)) return;
    if (loadMore) setState(() => moreVideoLoading = true);

    final tok = loadMore && nextVideoToken != null ? '&pageToken=$nextVideoToken' : '';
    final url =
        'https://www.googleapis.com/youtube/v3/search?part=snippet'
        '&q=${Uri.encodeComponent(baseQuery)}'
        '&type=video&maxResults=10$tok&key=$ytKey';

    try {
      final res = await http.get(Uri.parse(url));
      final data = jsonDecode(res.body);
      setState(() {
        videos.addAll(data['items']);
        nextVideoToken = data['nextPageToken'] ?? '';
      });
    } catch (e) {
      debugPrint('YouTube fetch error: $e');
    } finally {
      setState(() {
        isVideoLoading = false;
        moreVideoLoading = false;
      });
    }
  }

  void _checkArticleScroll() {
    if (_articleCtrl.position.pixels >=
        _articleCtrl.position.maxScrollExtent - 200 &&
        !moreNewsLoading) {
      fetchArticles(loadMore: true);
    }
  }

  void _checkVideoScroll() {
    if (_videoCtrl.position.pixels >=
        _videoCtrl.position.maxScrollExtent - 200 &&
        !moreVideoLoading) {
      fetchVideos(loadMore: true);
    }
  }

  List get filteredArticles {
    if (searchText.isEmpty) return articles;
    return articles.where((a) {
      final title = (a['title'] ?? '').toLowerCase();
      final desc = (a['description'] ?? '').toLowerCase();
      return title.contains(searchText.toLowerCase()) ||
          desc.contains(searchText.toLowerCase());
    }).toList();
  }

  List get filteredVideos {
    if (searchText.isEmpty) return videos;
    return videos.where((v) {
      final title = (v['snippet']['title'] ?? '').toLowerCase();
      return title.contains(searchText.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF4D7),
      appBar: AppBar(
        title: const Text('Learning', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color(0xFFF89BA3),
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Articles'),
            Tab(text: 'Video Courses'),
            Tab(text: 'Quiz'),
          ],
          labelColor: Colors.white,
        ),
      ),
      body: Column(
        children: [
          if (_currentTab != 2)
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                controller: _search,
                decoration: InputDecoration(
                  hintText: _currentTab == 0
                      ? 'Search articles...'
                      : 'Search videos...',
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF5D2E46)),
                  suffixIcon: _search.text.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => setState(() {
                      searchText = '';
                      _search.clear();
                    }),
                  )
                      : null,
                  filled: true,
                  fillColor: const Color(0xFFF6D9D9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (v) => setState(() => searchText = v),
              ),
            ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                isNewsLoading
                    ? const Center(child: CircularProgressIndicator())
                    : RefreshIndicator(
                  onRefresh: () async {
                    articles.clear();
                    articlePage = 1;
                    await fetchArticles();
                  },
                  child: ListView.builder(
                    controller: _articleCtrl,
                    itemCount: filteredArticles.length + (moreNewsLoading ? 1 : 0),
                    itemBuilder: (_, i) {
                      if (i == filteredArticles.length) {
                        return const Padding(
                          padding: EdgeInsets.all(12),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      final a = filteredArticles[i];
                      return _ArticleTile(article: a);
                    },
                  ),
                ),
                isVideoLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                  controller: _videoCtrl,
                  itemCount: filteredVideos.length + (moreVideoLoading ? 1 : 0),
                  itemBuilder: (_, i) {
                    if (i == filteredVideos.length) {
                      return const Padding(
                        padding: EdgeInsets.all(12),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final v = filteredVideos[i];
                    return _VideoTile(video: v);
                  },
                ),
                ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: quizList.length,
                  itemBuilder: (_, i) {
                    final quiz = quizList[i];
                    return Card(
                      color: const Color(0xFFE1F5FE),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        leading: CircleAvatar(child: Text('${i + 1}')),
                        title: Text(quiz.title),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => QuizPage(quiz: quiz),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _articleCtrl.dispose();
    _videoCtrl.dispose();
    _tabController.dispose();
    _search.dispose();
    super.dispose();
  }
}

class _ArticleTile extends StatelessWidget {
  final Map article;
  const _ArticleTile({required this.article});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: const Color(0xFFE3F2FD),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: article['urlToImage'] != null
            ? ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            article['urlToImage'],
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
          ),
        )
            : const Icon(Icons.image),
        title: Text(article['title'] ?? 'No title',
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(article['source']['name'] ?? 'Unknown'),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => WebViewPage(
              url: article['url'],
              title: article['title'],
            ),
          ),
        ),
      ),
    );
  }
}

class _VideoTile extends StatelessWidget {
  final Map video;
  const _VideoTile({required this.video});

  @override
  Widget build(BuildContext context) {
    final id = video['id']['videoId'];
    final sn = video['snippet'];
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: const Color(0xFFF6E3F7),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            sn['thumbnails']['default']['url'],
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(sn['title'],
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(sn['channelTitle']),
        trailing: const Icon(Icons.play_circle),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VideoPlayerPage(
              videoId: id,
              videoTitle: sn['title'],
            ),
          ),
        ),
      ),
    );
  }
}
