import 'package:get_it/get_it.dart';
import 'package:mvvm_statemanagements/service/navigation_service.dart';
import 'package:mvvm_statemanagements/view_models/favorites/favorites_bloc.dart';
import 'package:mvvm_statemanagements/view_models/movies/now_playing/now_playing_movies_bloc.dart';
import 'package:mvvm_statemanagements/view_models/movies/popular/popular_movies_bloc.dart';
import 'package:mvvm_statemanagements/view_models/movies/top_rated/top_rated_movies_bloc.dart';
import 'package:mvvm_statemanagements/view_models/movies/upcoming/upcoming_movies_bloc.dart';
import 'package:mvvm_statemanagements/view_models/theme/theme_bloc.dart';

import '../repository/movies_repo.dart';
import 'api_service.dart';

GetIt getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<NavigationService>(() => NavigationService());
  getIt.registerLazySingleton<ApiService>(() => ApiService());
  getIt.registerLazySingleton<MoviesRepository>(
      () => MoviesRepository(getIt<ApiService>()));
  getIt.registerLazySingleton<ThemeBloc>(() => ThemeBloc());
  getIt.registerLazySingleton<PopularMoviesBloc>(() => PopularMoviesBloc());
  getIt.registerLazySingleton<TopRatedMoviesBloc>(() => TopRatedMoviesBloc());
  getIt.registerLazySingleton<NowPlayingMoviesBloc>(
      () => NowPlayingMoviesBloc());
  getIt.registerLazySingleton<UpcomingMoviesBloc>(() => UpcomingMoviesBloc());
  getIt.registerLazySingleton<FavoritesBloc>(() => FavoritesBloc());
}
