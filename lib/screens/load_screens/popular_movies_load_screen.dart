import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_statemanagements/screens/movie_screens/popular_movies_screen.dart';
import 'package:mvvm_statemanagements/service/init_getit.dart';
import 'package:mvvm_statemanagements/service/navigation_service.dart';
import 'package:mvvm_statemanagements/view_models/favorites/favorites_bloc.dart';
import 'package:mvvm_statemanagements/view_models/movies/popular/popular_movies_bloc.dart';
import 'package:mvvm_statemanagements/widgets/my_error_widget.dart';

class PopularMoviesLoadScreen extends StatelessWidget {
  const PopularMoviesLoadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final moviesBloc = getIt<PopularMoviesBloc>();
    final navigationService = getIt<NavigationService>();

    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<PopularMoviesBloc, PopularMoviesState>(
            bloc: moviesBloc..add(FetchMoviesEvent()),
            listener: (context, state) {
              if (state is MoviesLoadedState) {
                navigationService.navigateReplace(const PopularMoviesScreen());
              } else if (state is MoviesErrorState) {
                navigationService.showSnackbar(state.message);
              }
            },
          ),
        ],
        child: BlocBuilder<PopularMoviesBloc, PopularMoviesState>(
          bloc: moviesBloc..add(FetchMoviesEvent()),
          builder: (context, state) {
            if (state is MoviesLoadedState) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Loading..."),
                    SizedBox(height: 20),
                    CircularProgressIndicator.adaptive(),
                  ],
                ),
              );
            } else if (state is MoviesErrorState) {
              return MyErrorWidget(
                errorText: state.message,
                retryFunction: () {
                  moviesBloc.add(FetchMoviesEvent());
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
