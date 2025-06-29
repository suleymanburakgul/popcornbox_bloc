import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mvvm_statemanagements/models/movies_dates.dart';
import 'package:mvvm_statemanagements/models/movies_genre.dart';
import 'package:mvvm_statemanagements/models/movies_model.dart';
import 'package:mvvm_statemanagements/repository/movies_repo.dart';
import 'package:mvvm_statemanagements/service/init_getit.dart';

part 'upcoming_movies_event.dart';
part 'upcoming_movies_state.dart';

class UpcomingMoviesBloc
    extends Bloc<UpcomingMoviesEvent, UpcomingMoviesState> {
  UpcomingMoviesBloc() : super(UpcomingMoviesInitial()) {
    on<FetchUpcomingMoviesEvent>(_onFetchMovies);
    on<FetchMoreUpcomingMoviesEvent>(_onFetchMoreMovies);
  }

  final MoviesRepository _moviesRepository = getIt<MoviesRepository>();

  Future<void> _onFetchMovies(event, emit) async {
    emit(UpcomingMoviesLoadingState());
    try {
      var genres = await _moviesRepository.fetchGenres();
      log(genres.length.toString());
      var movies = await _moviesRepository.fetchUpcomingMovies(page: 1);
      var movieDates = await _moviesRepository.fetchUpcomingMovieDates();
      emit(UpcomingMoviesLoadedState(
        currentPage: 1,
        genres: genres,
        movies: movies,
        movieDates: movieDates,
      ));
    } catch (error) {
      emit(UpcomingMoviesErrorState(
        message: error.toString(),
      ));
    }
  }

  Future<void> _onFetchMoreMovies(event, emit) async {
    final currentState = state;
    if (currentState is UpcomingMoviesLoadingMoreState) {
      return;
    }
    if (currentState is! UpcomingMoviesLoadedState) {
      return;
    }
    emit(UpcomingMoviesLoadingMoreState(
      currentPage: currentState.currentPage,
      movies: currentState.movies,
      genres: currentState.genres,
      movieDates: currentState.movieDates,
    ));
    try {
      List<MovieModel> moviesMore = await _moviesRepository.fetchUpcomingMovies(
          page: currentState.currentPage + 1);
      if (moviesMore.isEmpty) {
        emit(currentState);
        return;
      }
      currentState.movies.addAll(moviesMore);
      emit(UpcomingMoviesLoadedState(
        currentPage: currentState.currentPage + 1,
        movies: currentState.movies,
        genres: currentState.genres,
        movieDates: currentState.movieDates,
      ));
    } catch (error) {
      emit(UpcomingMoviesErrorState(
        message: error.toString(),
      ));
    }
  }
}
