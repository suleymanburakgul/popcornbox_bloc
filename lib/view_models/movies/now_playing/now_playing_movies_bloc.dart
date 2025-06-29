import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mvvm_statemanagements/models/movies_dates.dart';
import 'package:mvvm_statemanagements/models/movies_genre.dart';
import 'package:mvvm_statemanagements/models/movies_model.dart';
import 'package:mvvm_statemanagements/repository/movies_repo.dart';
import 'package:mvvm_statemanagements/service/init_getit.dart';

part 'now_playing_movies_event.dart';
part 'now_playing_movies_state.dart';

class NowPlayingMoviesBloc
    extends Bloc<NowPlayingMoviesEvent, NowPlayingMoviesState> {
  NowPlayingMoviesBloc() : super(NowPlayingMoviesInitial()) {
    on<FetchNowPlayingMoviesEvent>(_onFetchMovies);
    on<FetchNowPlayingMoreMoviesEvent>(_onFetchMoreMovies);
  }

  final MoviesRepository _moviesRepository = getIt<MoviesRepository>();

  Future<void> _onFetchMovies(event, emit) async {
    emit(NowPlayingMoviesLoadingState());
    try {
      var genres = await _moviesRepository.fetchGenres();
      log(genres.length.toString());
      var movies = await _moviesRepository.fetchNowPlayingMovies(page: 1);
      var movieDates = await _moviesRepository.fetchNowPlayingMovieDates();
      emit(NowPlayingMoviesLoadedState(
        currentPage: 1,
        genres: genres,
        movies: movies,
        movieDates: movieDates,
      ));
    } catch (error) {
      emit(NowPlayingMoviesErrorState(
        message: error.toString(),
      ));
    }
  }

  Future<void> _onFetchMoreMovies(event, emit) async {
    final currentState = state;
    if (currentState is NowPlayingMoviesLoadingMoreState) {
      return;
    }
    if (currentState is! NowPlayingMoviesLoadedState) {
      return;
    }
    emit(NowPlayingMoviesLoadingMoreState(
      currentPage: currentState.currentPage,
      movies: currentState.movies,
      genres: currentState.genres,
      movieDates: currentState.movieDates,
    ));
    try {
      List<MovieModel> moviesMore = await _moviesRepository.fetchPopularMovies(
          page: currentState.currentPage + 1);
      if (moviesMore.isEmpty) {
        emit(currentState);
        return;
      }
      currentState.movies.addAll(moviesMore);
      emit(NowPlayingMoviesLoadedState(
        currentPage: currentState.currentPage + 1,
        movies: currentState.movies,
        genres: currentState.genres,
        movieDates: currentState.movieDates,
      ));
    } catch (error) {
      emit(NowPlayingMoviesErrorState(
        message: error.toString(),
      ));
    }
  }
}
