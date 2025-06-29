import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mvvm_statemanagements/models/movies_dates.dart';
import 'package:mvvm_statemanagements/models/movies_genre.dart';
import 'package:mvvm_statemanagements/models/movies_model.dart';
import 'package:mvvm_statemanagements/repository/movies_repo.dart';
import 'package:mvvm_statemanagements/service/init_getit.dart';

part 'popular_movies_event.dart';
part 'popular_movies_state.dart';

class PopularMoviesBloc extends Bloc<PopularMoviesEvent, PopularMoviesState> {
  PopularMoviesBloc() : super(MoviesInitial()) {
    on<FetchMoviesEvent>(_onFetchMovies);
    on<FetchMoreMoviesEvent>(_onFetchMoreMovies);
  }

  final MoviesRepository _moviesRepository = getIt<MoviesRepository>();

  Future<void> _onFetchMovies(event, emit) async {
    emit(MoviesLoadingState());
    try {
      var genres = await _moviesRepository.fetchGenres();
      log(genres.length.toString());
      var movies = await _moviesRepository.fetchPopularMovies(page: 1);
      emit(MoviesLoadedState(
        currentPage: 1,
        genres: genres,
        movies: movies,
        movieDates: MovieDates(maximum: "", minimum: ""),
      ));
    } catch (error) {
      emit(MoviesErrorState(
        message: error.toString(),
      ));
    }
  }

  Future<void> _onFetchMoreMovies(event, emit) async {
    final currentState = state;
    if (currentState is MoviesLoadingMoreState) {
      return;
    }
    if (currentState is! MoviesLoadedState) {
      return;
    }
    emit(MoviesLoadingMoreState(
      currentPage: currentState.currentPage,
      movies: currentState.movies,
      genres: currentState.genres,
      movieDates: MovieDates(maximum: "", minimum: ""),
    ));
    try {
      List<MovieModel> moviesMore = await _moviesRepository.fetchPopularMovies(
          page: currentState.currentPage + 1);
      if (moviesMore.isEmpty) {
        emit(currentState);
        return;
      }
      currentState.movies.addAll(moviesMore);
      emit(MoviesLoadedState(
        currentPage: currentState.currentPage + 1,
        movies: currentState.movies,
        genres: currentState.genres,
        movieDates: MovieDates(maximum: "", minimum: ""),
      ));
    } catch (error) {
      emit(MoviesErrorState(
        message: error.toString(),
      ));
    }
  }
}
