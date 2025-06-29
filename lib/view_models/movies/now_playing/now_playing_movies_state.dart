part of 'now_playing_movies_bloc.dart';

sealed class NowPlayingMoviesState extends Equatable {
  const NowPlayingMoviesState();

  @override
  List<Object> get props => [];
}

final class NowPlayingMoviesInitial extends NowPlayingMoviesState {}

final class NowPlayingMoviesLoadingState extends NowPlayingMoviesState {}

final class NowPlayingMoviesLoadedState extends NowPlayingMoviesState {
  final List<MovieModel> movies;
  final List<MoviesGenre> genres;
  final int currentPage;
  final MovieDates movieDates;

  const NowPlayingMoviesLoadedState({
    this.movies = const [],
    this.genres = const [],
    this.currentPage = 0,
    required this.movieDates,
  });

  @override
  List<Object> get props => [movies, genres, currentPage, movieDates];
}

final class NowPlayingMoviesLoadingMoreState extends NowPlayingMoviesState {
  final List<MovieModel> movies;
  final List<MoviesGenre> genres;
  final int currentPage;
  final MovieDates movieDates;

  const NowPlayingMoviesLoadingMoreState({
    this.movies = const [],
    this.genres = const [],
    this.currentPage = 0,
    required this.movieDates,
  });

  @override
  List<Object> get props => [movies, genres, currentPage, movieDates];
}

final class NowPlayingMoviesErrorState extends NowPlayingMoviesState {
  final String message;

  const NowPlayingMoviesErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
