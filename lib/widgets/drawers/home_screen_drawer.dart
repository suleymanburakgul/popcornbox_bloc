import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_statemanagements/screens/load_screens/now_playing_movies_load_screen.dart';
import 'package:mvvm_statemanagements/screens/load_screens/popular_movies_load_screen.dart';
import 'package:mvvm_statemanagements/screens/load_screens/top_rated_movies_load_screen.dart';
import 'package:mvvm_statemanagements/screens/load_screens/upcoming_movies_load_screen.dart';
import 'package:mvvm_statemanagements/service/init_getit.dart';
import 'package:mvvm_statemanagements/service/navigation_service.dart';
import 'package:mvvm_statemanagements/view_models/theme/theme_bloc.dart';
import 'package:mvvm_statemanagements/widgets/drawers/home_screen_drawer_item.dart';

class HomeScreenDrawer extends StatelessWidget {
  const HomeScreenDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return Drawer(
          child: Column(
            children: [
              DrawerHeader(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: state is DarkThemeState
                      ? Colors.teal.shade700
                      : Colors.teal.shade300,
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.videocam,
                      size: 60,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Categories',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 32),
                    ),
                  ],
                ),
              ),
              HomeScreenDrawerItem(
                drawerItemText: 'Popular Movies',
                onTapFunction: () {
                  getIt<NavigationService>()
                      .navigate(const PopularMoviesLoadScreen());
                },
                drawerItemIcon: Icons.movie,
              ),
              HomeScreenDrawerItem(
                drawerItemText: 'Top Rated Movies',
                onTapFunction: () {
                  getIt<NavigationService>()
                      .navigate(const TopRatedMoviesLoadScreen());
                },
                drawerItemIcon: Icons.movie_filter,
              ),
              HomeScreenDrawerItem(
                drawerItemText: 'Now Playing Movies',
                onTapFunction: () {
                  getIt<NavigationService>()
                      .navigate(const NowPlayingMoviesLoadScreen());
                },
                drawerItemIcon: Icons.video_call,
              ),
              HomeScreenDrawerItem(
                drawerItemText: 'Upcoming Movies',
                onTapFunction: () {
                  getIt<NavigationService>()
                      .navigate(const UpcomingMoviesLoadScreen());
                },
                drawerItemIcon: Icons.movie_edit,
              ),
            ],
          ),
        );
      },
    );
  }
}
