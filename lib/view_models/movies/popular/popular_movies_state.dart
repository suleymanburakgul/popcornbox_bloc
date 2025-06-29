part of 'popular_movies_bloc.dart';

sealed class PopularMoviesState extends Equatable {
  const PopularMoviesState();

  @override
  List<Object> get props => [];
}

final class MoviesInitial extends PopularMoviesState {}

final class MoviesLoadingState extends PopularMoviesState {}

final class MoviesLoadedState extends PopularMoviesState {
  final List<MovieModel> movies;
  final List<MoviesGenre> genres;
  final int currentPage;
  final MovieDates movieDates;

  const MoviesLoadedState({
    this.movies = const [],
    this.genres = const [],
    this.currentPage = 0,
    required this.movieDates,
  });

  @override
  List<Object> get props => [movies, genres, currentPage, movieDates];
}

final class MoviesLoadingMoreState extends PopularMoviesState {
  final List<MovieModel> movies;
  final List<MoviesGenre> genres;
  final int currentPage;
  final MovieDates movieDates;

  const MoviesLoadingMoreState({
    this.movies = const [],
    this.genres = const [],
    this.currentPage = 0,
    required this.movieDates,
  });

  @override
  List<Object> get props => [movies, genres, currentPage, movieDates];
}

final class MoviesErrorState extends PopularMoviesState {
  final String message;

  const MoviesErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
