part of 'upcoming_movies_bloc.dart';

sealed class UpcomingMoviesState extends Equatable {
  const UpcomingMoviesState();

  @override
  List<Object> get props => [];
}

final class UpcomingMoviesInitial extends UpcomingMoviesState {}

final class UpcomingMoviesLoadingState extends UpcomingMoviesState {}

final class UpcomingMoviesLoadedState extends UpcomingMoviesState {
  final List<MovieModel> movies;
  final List<MoviesGenre> genres;
  final int currentPage;
  final MovieDates movieDates;

  const UpcomingMoviesLoadedState({
    this.movies = const [],
    this.genres = const [],
    this.currentPage = 0,
    required this.movieDates,
  });

  @override
  List<Object> get props => [movies, genres, currentPage, movieDates];
}

final class UpcomingMoviesLoadingMoreState extends UpcomingMoviesState {
  final List<MovieModel> movies;
  final List<MoviesGenre> genres;
  final int currentPage;
  final MovieDates movieDates;

  const UpcomingMoviesLoadingMoreState({
    this.movies = const [],
    this.genres = const [],
    this.currentPage = 0,
    required this.movieDates,
  });

  @override
  List<Object> get props => [movies, genres, currentPage, movieDates];
}

final class UpcomingMoviesErrorState extends UpcomingMoviesState {
  final String message;

  const UpcomingMoviesErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
