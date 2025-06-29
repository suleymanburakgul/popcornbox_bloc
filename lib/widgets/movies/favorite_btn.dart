import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_statemanagements/models/movies_model.dart';
import 'package:mvvm_statemanagements/service/init_getit.dart';
import 'package:mvvm_statemanagements/service/navigation_service.dart';
import 'package:mvvm_statemanagements/view_models/favorites/favorites_bloc.dart';

import '../../constants/my_app_icons.dart';

//The code below has been implemented using the bloc consumer
class FavoriteBtnWidget extends StatelessWidget {
  const FavoriteBtnWidget({
    super.key,
    required this.movieModel,
  });
  final MovieModel movieModel;

  @override
  Widget build(BuildContext context) {
    final navigationService = getIt<NavigationService>();
    return BlocConsumer<FavoritesBloc, FavoritesState>(
      listener: (context, state) {
        if (state is FavoritesError) {
          navigationService
              .showSnackbar("An error has been occured ${state.message}");
        }
      },
      builder: (context, state) {
        bool isFavorite = (state is FavoritesLoaded) &&
            state.favorites.any(
              (movie) => movie.id == movieModel.id,
            );
        return IconButton(
          onPressed: () {
            getIt<FavoritesBloc>().add(
              isFavorite
                  ? RemoveFromFavorites(movieModel: movieModel)
                  : AddToFavorites(movieModel: movieModel),
            );
            /*   if (isFavorite) {
              getIt<FavoritesBloc>()
                  .add(RemoveFromFavorites(movieModel: movieModel));
            } else {
              getIt<FavoritesBloc>()
                  .add(AddToFavorites(movieModel: movieModel));
            }
          */
          },
          icon: Icon(
            isFavorite
                ? MyAppIcons.favorite
                : MyAppIcons.favoriteOutlineRounded,
            color: isFavorite ? Colors.red : null,
            size: 20,
          ),
        );
      },
    );
  }
}
