import 'package:mvvm_statemanagements/models/movies_dates.dart';
import 'package:mvvm_statemanagements/service/api_service.dart';

import '../models/movies_genre.dart';
import '../models/movies_model.dart';

class MoviesRepository {
  final ApiService _apiService;
  MoviesRepository(this._apiService);

  Future<List<MovieModel>> fetchPopularMovies({int page = 1}) async {
    return await _apiService.fetchPopularMovies(page: page);
  }

  Future<List<MovieModel>> fetchTopRatedMovies({int page = 1}) async {
    return await _apiService.fetchTopRatedMovies(page: page);
  }

  Future<List<MovieModel>> fetchNowPlayingMovies({int page = 1}) async {
    return await _apiService.fetchNowPlayingMovies(page: page);
  }

  Future<MovieDates> fetchNowPlayingMovieDates({int page = 1}) async {
    return await _apiService.fetchNowPlayingMovieDates(page: page);
  }

  Future<List<MovieModel>> fetchUpcomingMovies({int page = 1}) async {
    return await _apiService.fetchUpcomingMovies(page: page);
  }

  Future<MovieDates> fetchUpcomingMovieDates({int page = 1}) async {
    return await _apiService.fetchUpcomingMovieDates(page: page);
  }

  // List<MoviesGenre> cachedGenres = [];
  Future<List<MoviesGenre>> fetchGenres() async {
    // return cachedGenres = await _apiService.fetchGenres();
    return await _apiService.fetchGenres();
  }
}
