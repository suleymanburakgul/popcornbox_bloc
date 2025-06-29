import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_statemanagements/main.dart';
import 'package:mvvm_statemanagements/view_models/movies/popular/popular_movies_bloc.dart';
import 'package:mvvm_statemanagements/view_models/theme/theme_bloc.dart';
import 'package:mvvm_statemanagements/widgets/drawers/home_screen_drawer.dart';

import '../../constants/my_app_icons.dart';
import '../../service/init_getit.dart';
import '../../service/navigation_service.dart';
import '../../widgets/movies/movies_widget.dart';
import '../favorites_screen.dart';

class PopularMoviesScreen extends StatelessWidget {
  const PopularMoviesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const HomeScreenDrawer(),
      appBar: AppBar(
        title: const Text("Popular Movies"),
        actions: [
          IconButton(
            onPressed: () {
              // getIt<NavigationService>().showSnackbar();
              // getIt<NavigationService>().showDialog(MoviesWidget());
              getIt<NavigationService>().navigate(const FavoritesScreen());
            },
            icon: const Icon(
              MyAppIcons.favoriteRounded,
              color: Colors.red,
            ),
          ),
          BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              return IconButton(
                onPressed: () async {
                  //context.read<ThemeBloc>().add(ToggleThemeEvent());
                  getIt<ThemeBloc>().add(ToggleThemeEvent());
                },
                icon: Icon(
                  state is LightThemeState
                      ? MyAppIcons.lightMode
                      : MyAppIcons.darkMode,
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<PopularMoviesBloc, PopularMoviesState>(
        builder: (context, state) {
          if (state is MoviesLoadingState) {
            return const Center(child: CircularProgressIndicator.adaptive());
          } else if (state is MoviesErrorState) {
            return Center(child: Text(state.message));
          } else if (state is MoviesLoadedState ||
              state is MoviesLoadingMoreState) {
            final movies = state is MoviesLoadedState
                ? state.movies
                : (state as MoviesLoadingMoreState).movies;
            bool isLoadingMore = state is MoviesLoadingMoreState;
            int itemCount = isLoadingMore ? movies.length + 1 : movies.length;
            return NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent &&
                    !isLoadingMore) {
                  getIt<PopularMoviesBloc>().add(FetchMoreMoviesEvent());
                  return true;
                }
                return false;
              },
              child: ListView.builder(
                itemCount: itemCount,
                itemBuilder: (context, index) {
                  if (index >= movies.length && isLoadingMore) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  return MoviesWidget(
                    movieModel: movies[index],
                  );
                },
              ),
            );
          }
          return const Center(child: Text('No Data'));
        },
      ),
    );
  }
}
