import 'package:dartz/dartz.dart';

import '../errors/movie_error.dart';
import '../models/movie_model.dart';
import '../models/movie_response_model.dart';
import '../repositories/movie_repository.dart';

class MovieSearchController {
  final _repository = MovieRepository();

  MovieResponseModel movieResponseModel;
  MovieError movieError;
  bool loading = true;

  List<MovieModel> get movies => movieResponseModel?.movies ?? <MovieModel>[];
  int get moviesCount => movies.length;
  bool get hasMovies => moviesCount != 0;
  int get totalPages => movieResponseModel?.totalPages ?? 1;
  int get currentPage => movieResponseModel?.page ?? 1;

  Future<Either<MovieError, MovieResponseModel>> searchMovies(
      {int page = 1, String title, String genre}) async {
    movieError = null;
    final result = await _repository.searchMovies(page: page, title: title, genre: genre);
    result.fold(
      (error) => movieError = error,
      (movie) {
        if (movieResponseModel == null) {
          movieResponseModel = movie;
        } else {
          movieResponseModel.page = movie.page;
          movieResponseModel.movies.addAll(movie.movies);
        }
      },
    );

    return result;
  }
}
