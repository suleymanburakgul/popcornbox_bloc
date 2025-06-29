part of 'upcoming_movies_bloc.dart';

sealed class UpcomingMoviesEvent extends Equatable {
  const UpcomingMoviesEvent();

  @override
  List<Object> get props => [];
}

class FetchUpcomingMoviesEvent extends UpcomingMoviesEvent {}

class FetchMoreUpcomingMoviesEvent extends UpcomingMoviesEvent {}
