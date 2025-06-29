part of 'now_playing_movies_bloc.dart';

sealed class NowPlayingMoviesEvent extends Equatable {
  const NowPlayingMoviesEvent();

  @override
  List<Object> get props => [];
}

class FetchNowPlayingMoviesEvent extends NowPlayingMoviesEvent {}

class FetchNowPlayingMoreMoviesEvent extends NowPlayingMoviesEvent {}
