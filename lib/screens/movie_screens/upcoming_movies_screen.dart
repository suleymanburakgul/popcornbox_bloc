import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_statemanagements/utils/movie_date_utils.dart';
import 'package:mvvm_statemanagements/view_models/movies/upcoming/upcoming_movies_bloc.dart';
import 'package:mvvm_statemanagements/view_models/theme/theme_bloc.dart';
import 'package:mvvm_statemanagements/widgets/drawers/home_screen_drawer.dart';

import '../../constants/my_app_icons.dart';
import '../../service/init_getit.dart';
import '../../service/navigation_service.dart';
import '../../widgets/movies/movies_widget.dart';
import '../favorites_screen.dart';

class UpcomingMoviesScreen extends StatelessWidget {
  const UpcomingMoviesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const HomeScreenDrawer(),
      appBar: AppBar(
        title: const Text("Upcoming Movies"),
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
          BlocBuilder<ThemeBloc, ThemeState>(builder: (context, state) {
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
          }),
        ],
      ),
      body: BlocBuilder<UpcomingMoviesBloc, UpcomingMoviesState>(
        builder: (context, state) {
          if (state is UpcomingMoviesLoadingState) {
            return const Center(child: CircularProgressIndicator.adaptive());
          } else if (state is UpcomingMoviesErrorState) {
            return Center(child: Text(state.message));
          } else if (state is UpcomingMoviesLoadedState ||
              state is UpcomingMoviesLoadingMoreState) {
            final movies = state is UpcomingMoviesLoadedState
                ? state.movies
                : (state as UpcomingMoviesLoadingMoreState).movies;
            final moviesDate = state is UpcomingMoviesLoadedState
                ? state.movieDates
                : (state as UpcomingMoviesLoadingMoreState).movieDates;
            bool isLoadingMore = state is UpcomingMoviesLoadingMoreState;
            int itemCount = isLoadingMore ? movies.length + 1 : movies.length;
            return NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent &&
                    !isLoadingMore) {
                  getIt<UpcomingMoviesBloc>()
                      .add(FetchMoreUpcomingMoviesEvent());
                  return true;
                }
                return false;
              },
              child: Column(
                children: [
                  BlocBuilder<ThemeBloc, ThemeState>(
                    builder: (context, stateTheme) {
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 6.0,
                        ),
                        decoration: BoxDecoration(
                          color: stateTheme is DarkThemeState
                              ? Colors.teal.shade700
                              : Colors.teal.shade50,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.teal.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: BlocBuilder<ThemeBloc, ThemeState>(
                          builder: (context, stateTheme) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.date_range,
                                  color: stateTheme is DarkThemeState
                                      ? Colors.teal.shade100
                                      : Colors.teal.shade500,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "${MovieDateUtils.formatDate(moviesDate.minimum)} - ${MovieDateUtils.formatDate(moviesDate.maximum)}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: stateTheme is DarkThemeState
                                        ? Colors.teal.shade50
                                        : Colors.teal.shade900,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      );
                    },
                  ),
                  Expanded(
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
                  )
                ],
              ),
            );
          }
          return const Center(child: Text('No Data'));
        },
      ),
    );
  }
}
