import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_statemanagements/screens/movie_screens/top_rated_movies_screen.dart';
import 'package:mvvm_statemanagements/service/init_getit.dart';
import 'package:mvvm_statemanagements/service/navigation_service.dart';
import 'package:mvvm_statemanagements/view_models/movies/top_rated/top_rated_movies_bloc.dart';
import 'package:mvvm_statemanagements/widgets/my_error_widget.dart';

class TopRatedMoviesLoadScreen extends StatelessWidget {
  const TopRatedMoviesLoadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final moviesBloc = getIt<TopRatedMoviesBloc>();
    final navigationService = getIt<NavigationService>();

    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<TopRatedMoviesBloc, TopRatedMoviesState>(
            bloc: moviesBloc..add(FetchTopRatedMoviesEvent()),
            listener: (context, state) {
              if (state is TopRatedMoviesLoadedState) {
                navigationService.navigateReplace(const TopRatedMoviesScreen());
              } else if (state is TopRatedMoviesErrorState) {
                navigationService.showSnackbar(state.message);
              }
            },
          ),
        ],
        child: BlocBuilder<TopRatedMoviesBloc, TopRatedMoviesState>(
          bloc: moviesBloc..add(FetchTopRatedMoviesEvent()),
          builder: (context, state) {
            if (state is TopRatedMoviesLoadedState) {
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
            } else if (state is TopRatedMoviesErrorState) {
              return MyErrorWidget(
                errorText: state.message,
                retryFunction: () {
                  moviesBloc.add(FetchTopRatedMoviesEvent());
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
