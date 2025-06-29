import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mvvm_statemanagements/models/movies_dates.dart';
import 'package:mvvm_statemanagements/models/movies_genre.dart';
import 'package:mvvm_statemanagements/models/movies_model.dart';
import 'package:mvvm_statemanagements/repository/movies_repo.dart';
import 'package:mvvm_statemanagements/service/init_getit.dart';

part 'top_rated_movies_event.dart';
part 'top_rated_movies_state.dart';

class TopRatedMoviesBloc
    extends Bloc<TopRatedMoviesEvent, TopRatedMoviesState> {
  TopRatedMoviesBloc() : super(TopRatedMoviesInitial()) {
    on<FetchTopRatedMoviesEvent>(_onFetchMovies);
    on<FetchMoreTopRatedMoviesEvent>(_onFetchMoreMovies);
  }

  final MoviesRepository _moviesRepository = getIt<MoviesRepository>();

  Future<void> _onFetchMovies(event, emit) async {
    emit(TopRatedMoviesLoadingState());
    try {
      var genres = await _moviesRepository.fetchGenres();
      log(genres.length.toString());
      var movies = await _moviesRepository.fetchTopRatedMovies(page: 1);
      emit(TopRatedMoviesLoadedState(
        currentPage: 1,
        genres: genres,
        movies: movies,
        movieDates: MovieDates(maximum: "", minimum: ""),
      ));
    } catch (error) {
      emit(TopRatedMoviesErrorState(
        message: error.toString(),
      ));
    }
  }

  Future<void> _onFetchMoreMovies(event, emit) async {
    final currentState = state;
    if (currentState is TopRatedMoviesLoadingMoreState) {
      return;
    }
    if (currentState is! TopRatedMoviesLoadedState) {
      return;
    }
    emit(TopRatedMoviesLoadingMoreState(
      currentPage: currentState.currentPage,
      movies: currentState.movies,
      genres: currentState.genres,
      movieDates: MovieDates(maximum: "", minimum: ""),
    ));
    try {
      List<MovieModel> moviesMore = await _moviesRepository.fetchTopRatedMovies(
          page: currentState.currentPage + 1);
      if (moviesMore.isEmpty) {
        emit(currentState);
        return;
      }
      currentState.movies.addAll(moviesMore);
      emit(TopRatedMoviesLoadedState(
        currentPage: currentState.currentPage + 1,
        movies: currentState.movies,
        genres: currentState.genres,
        movieDates: MovieDates(maximum: "", minimum: ""),
      ));
    } catch (error) {
      emit(TopRatedMoviesErrorState(
        message: error.toString(),
      ));
    }
  }
}
