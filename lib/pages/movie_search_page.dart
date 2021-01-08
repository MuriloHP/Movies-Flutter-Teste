import 'package:flutter/material.dart';
import 'package:movies/controllers/movie_search_controller.dart';
import 'package:movies/pages/movie_detail_page.dart';
import 'package:movies/widgets/centered_message.dart';
import 'package:movies/widgets/centered_progress.dart';
import 'package:movies/widgets/movie_card.dart';

class MovieSearchPage extends StatefulWidget {
  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MovieSearchPage> {
  final _controller = MovieSearchController();
  final _scrollController = ScrollController();
  final _titleController = TextEditingController();
  int lastPage = 1;
  String _genre = "Todos";
  String genreId;

  @override
  void initState() {
    super.initState();
    _controller.loading = false;
    _initScrollListener();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    _titleController.dispose();
    super.dispose();
  }

  _search() async {
    setState(() {
      _controller.loading = true;
    });

    await _controller.searchMovies(
        page: lastPage,
        title: _titleController.text.isNotEmpty ? _titleController.text : null,
        genre: genreId);

    setState(() {
      _controller.loading = false;
    });
  }

  _initScrollListener() {
    _scrollController.addListener(() async {
      if (_scrollController.offset >=
          _scrollController.position.maxScrollExtent) {
        if (_controller.currentPage == lastPage) {
          lastPage++;
          await _controller.searchMovies(
              page: lastPage,
              title: _titleController.text.isNotEmpty
                  ? _titleController.text
                  : null,
              genre: genreId);
          setState(() {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            _buildFilters(),
            Expanded(
              child: _buildMovieGrid(),
            ),
          ],
        ));
  }

  _buildFilters() {

    
    return Container(
      padding: EdgeInsets.all(15),
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.white,
            ),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _titleController,
                    enabled: null,
                    autofocus: true,
                    style: TextStyle(fontSize: 14, color: Colors.black),
                    textInputAction: TextInputAction.search,
                    onSubmitted: (text) {
                      setState(() {
                        _genre = "Todos";
                        genreId = null;
                      });
                      _search();
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Buscar...",
                      hintStyle: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Flexible(
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Gêneros de Filmes",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 2,
                child: new DropdownButton<String>(
                  isExpanded: true,
                  value: _genre,
                  onChanged: (String newValue) async {
                    setState(() {
                      _titleController.clear();
                      if (newValue.contains("Todos")) {
                        _genre = newValue;
                        genreId = null;
                      } else if (newValue.contains("Comédia")) {
                        _genre = newValue;
                        genreId = null;
                      } else if (newValue.contains("Ação")) {
                        _genre = newValue;
                        genreId = null;
                      } else if (newValue.contains("Terror")) {
                        _genre = newValue;
                        genreId = null;
                      } else if (newValue.contains("Suspense")) {
                        _genre = newValue;
                        genreId = null;
                      } else if (newValue.contains("Aventura")) {
                        _genre = newValue;
                        genreId = null;
                      } else if (newValue.contains("Anime")) {
                        _genre = newValue;
                        genreId = null;
                      }
                      _search();
                    });
                  },
                  items: [
                    "Todos",
                    "Comédia",
                    "Ação",
                    "Terror",
                    "Suspense",
                    "Aventura",
                    "Anime",
                  ].map((String value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  _buildMovieGrid() {
    if (_controller.loading) {
      return CenteredProgress();
    }

    if (_controller.movieError != null) {
      return CenteredMessage(message: _controller.movieError.message);
    }


    return _controller.moviesCount > 0 ? GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(2.0),
      itemCount: _controller.moviesCount,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 5,
        crossAxisSpacing: 3,
        childAspectRatio: 0.65,
      ),
      itemBuilder: _buildMovieCard,
    ) : Center(
      child: Text(
        "Nenhum filme encontrado!!!",
        style: TextStyle(
          fontSize: 20
        ),
      ),
    );
  }

  Widget _buildMovieCard(context, index) {
    final movie = _controller.movies[index];
    return MovieCard(
      posterPath: movie.posterPath,
      onTap: () => _openDetailPage(movie.id),
    );
  }

  _openDetailPage(movieId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetailPage(movieId),
      ),
    );
  }
}
