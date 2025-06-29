import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_statemanagements/screens/movie_screens/now_playing_movies_screen.dart';
import 'package:mvvm_statemanagements/screens/movie_screens/top_rated_movies_screen.dart';
import 'package:mvvm_statemanagements/service/init_getit.dart';
import 'package:mvvm_statemanagements/service/navigation_service.dart';
import 'package:mvvm_statemanagements/view_models/movies/now_playing/now_playing_movies_bloc.dart';
import 'package:mvvm_statemanagements/view_models/movies/top_rated/top_rated_movies_bloc.dart';
import 'package:mvvm_statemanagements/widgets/my_error_widget.dart';

class NowPlayingMoviesLoadScreen extends StatelessWidget {
  const NowPlayingMoviesLoadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final moviesBloc = getIt<NowPlayingMoviesBloc>();
    final navigationService = getIt<NavigationService>();

    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<NowPlayingMoviesBloc, NowPlayingMoviesState>(
            bloc: moviesBloc..add(FetchNowPlayingMoviesEvent()),
            listener: (context, state) {
              if (state is NowPlayingMoviesLoadedState) {
                navigationService
                    .navigateReplace(const NowPlayingMoviesScreen());
              } else if (state is NowPlayingMoviesErrorState) {
                navigationService.showSnackbar(state.message);
              }
            },
          ),
        ],
        child: BlocBuilder<NowPlayingMoviesBloc, NowPlayingMoviesState>(
          bloc: moviesBloc..add(FetchNowPlayingMoviesEvent()),
          builder: (context, state) {
            if (state is NowPlayingMoviesLoadedState) {
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
            } else if (state is NowPlayingMoviesErrorState) {
              return MyErrorWidget(
                errorText: state.message,
                retryFunction: () {
                  moviesBloc.add(FetchNowPlayingMoviesEvent());
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
