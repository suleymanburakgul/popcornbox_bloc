part of 'top_rated_movies_bloc.dart';

sealed class TopRatedMoviesState extends Equatable {
  const TopRatedMoviesState();

  @override
  List<Object> get props => [];
}

final class TopRatedMoviesInitial extends TopRatedMoviesState {}

final class TopRatedMoviesLoadingState extends TopRatedMoviesState {}

final class TopRatedMoviesLoadedState extends TopRatedMoviesState {
  final List<MovieModel> movies;
  final List<MoviesGenre> genres;
  final int currentPage;
  final MovieDates movieDates;

  const TopRatedMoviesLoadedState({
    this.movies = const [],
    this.genres = const [],
    this.currentPage = 0,
    required this.movieDates,
  });

  @override
  List<Object> get props => [movies, genres, currentPage, movieDates];
}

final class TopRatedMoviesLoadingMoreState extends TopRatedMoviesState {
  final List<MovieModel> movies;
  final List<MoviesGenre> genres;
  final int currentPage;
  final MovieDates movieDates;

  const TopRatedMoviesLoadingMoreState({
    this.movies = const [],
    this.genres = const [],
    this.currentPage = 0,
    required this.movieDates,
  });

  @override
  List<Object> get props => [movies, genres, currentPage, movieDates];
}

final class TopRatedMoviesErrorState extends TopRatedMoviesState {
  final String message;

  const TopRatedMoviesErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
