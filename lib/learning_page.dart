import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'webview_page.dart';

class LearningPage extends StatefulWidget {
  static const routeName = '/learning';
  const LearningPage({super.key});

  @override
  State<LearningPage> createState() => _LearningPageState();
}

class _LearningPageState extends State<LearningPage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  final String newsKey = '04d6fa829c0242c0a0bee11470464327';
  final String ytKey = 'AIzaSyAXZJWjhx6yzmzhK_Ie8ZQUvp8PP6Q_Rzg'; // <-- insert your key here

  final String baseQuery = 'menstrual health OR period tips OR menstruation OR menstrual hygiene '
      'OR menstrual education OR women period OR period pain OR hormonal health';

  List articles = [];
  List videos = [];

  int articlePage = 1;
  String nextVideoPageToken = '';
  bool isNewsLoading = true;
  bool isVideoLoading = true;
  bool showLoadMore = false;

  String searchText = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchArticles();
    fetchVideos();
    _scrollController.addListener(_onScroll);
  }

  Future<void> fetchArticles() async {
    final url =
        'https://newsapi.org/v2/everything?q=${Uri.encodeComponent(baseQuery)}'
        '&language=en&pageSize=10&page=$articlePage&sortBy=publishedAt&apiKey=$newsKey';

    try {
      final res = await http.get(Uri.parse(url));
      final data = json.decode(res.body);
      setState(() {
        articles.addAll(data['articles']);
        isNewsLoading = false;
        articlePage++;
      });
    } catch (e) {
      setState(() => isNewsLoading = false);
      debugPrint('News error: $e');
    }
  }

  Future<void> fetchVideos() async {
    final url = 'https://www.googleapis.com/youtube/v3/search?part=snippet'
        '&q=${Uri.encodeComponent(baseQuery)}'
        '&type=video&maxResults=10&pageToken=$nextVideoPageToken&key=$ytKey';

    try {
      final res = await http.get(Uri.parse(url));
      final data = json.decode(res.body);
      setState(() {
        videos.addAll(data['items']);
        nextVideoPageToken = data['nextPageToken'] ?? '';
        isVideoLoading = false;
      });
    } catch (e) {
      setState(() => isVideoLoading = false);
      debugPrint('YouTube error: $e');
    }
  }

  List get filteredArticles {
    if (searchText.isEmpty) return articles;
    return articles.where((article) {
      final title = (article['title'] ?? '').toLowerCase();
      final desc = (article['description'] ?? '').toLowerCase();
      return title.contains(searchText.toLowerCase()) || desc.contains(searchText.toLowerCase());
    }).toList();
  }

  List get filteredVideos {
    if (searchText.isEmpty) return videos;
    return videos.where((item) {
      final title = (item['snippet']['title'] ?? '').toLowerCase();
      return title.contains(searchText.toLowerCase());
    }).toList();
  }

  void _onScroll() {
    if (_tabController.index == 0) {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        setState(() => showLoadMore = true);
      } else {
        setState(() => showLoadMore = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArticleTab = _tabController.index == 0;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF4D7),
      appBar: AppBar(
        title: const Text('Learning', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color(0xFFF89BA3),
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'Articles'), Tab(text: 'Video Courses')],
          labelColor: Colors.white,
          indicatorColor: Colors.white,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: isArticleTab ? 'Search articles...' : 'Search videos...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF5D2E46)),
                suffixIcon: _searchController.text.isNotEmpty
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
                filled: true,
                fillColor: const Color(0xFFF6D9D9),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (val) => setState(() => searchText = val),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                isNewsLoading ? const Center(child: CircularProgressIndicator()) : _buildArticlesList(),
                isVideoLoading ? const Center(child: CircularProgressIndicator()) : _buildVideosList(),
              ],
            ),
          ),
          if (isArticleTab && showLoadMore && !isNewsLoading)
            Padding(
              padding: const EdgeInsets.all(12),
              child: ElevatedButton(
                onPressed: fetchArticles,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF85A0E8),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Load More', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          if (!isArticleTab && nextVideoPageToken.isNotEmpty && !isVideoLoading)
            Padding(
              padding: const EdgeInsets.all(12),
              child: ElevatedButton(
                onPressed: fetchVideos,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF85A0E8),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Load More Videos', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildArticlesList() {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          articles.clear();
          articlePage = 1;
          isNewsLoading = true;
        });
        await fetchArticles();
      },
      child: ListView.builder(
        controller: _scrollController,
        itemCount: filteredArticles.length,
        itemBuilder: (_, i) {
          final a = filteredArticles[i];
          return Card(
            color: const Color(0xFFE3F2FD),
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: a['urlToImage'] != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  a['urlToImage'],
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
                ),
              )
                  : const Icon(Icons.image),
              title: Text(a['title'] ?? 'No Title',
                  style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF333333))),
              subtitle: Text(a['source']['name'] ?? 'Unknown',
                  style: const TextStyle(color: Color(0xFF5D2E46))),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => WebViewPage(url: a['url'], title: a['title'])),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVideosList() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: filteredVideos.length,
      itemBuilder: (_, i) {
        final v = filteredVideos[i];
        final id = v['id']['videoId'];
        final snippet = v['snippet'];
        return Card(
          color: const Color(0xFFF6E3F7),
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                snippet['thumbnails']['default']['url'],
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(snippet['title'],
                style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF333333))),
            subtitle: Text(snippet['channelTitle'],
                style: const TextStyle(color: Color(0xFF5D2E46))),
            trailing: const Icon(Icons.play_circle),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => _VideoPlayerPage(videoId: id)),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}

class _VideoPlayerPage extends StatefulWidget {
  final String videoId;
  const _VideoPlayerPage({required this.videoId});

  @override
  State<_VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<_VideoPlayerPage> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(autoPlay: true, mute: false),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Course'),
        backgroundColor: const Color(0xFFF89BA3),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.pause();
    _controller.dispose();
    super.dispose();
  }
}
