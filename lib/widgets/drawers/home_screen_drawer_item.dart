import 'package:flutter/material.dart';

class HomeScreenDrawerItem extends StatelessWidget {
  const HomeScreenDrawerItem({
    super.key,
    required this.drawerItemText,
    required this.onTapFunction,
    required this.drawerItemIcon,
  });

  final String drawerItemText;
  final IconData drawerItemIcon;
  final VoidCallback onTapFunction;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        drawerItemIcon,
        size: 26,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      title: Text(
        drawerItemText,
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 24,
            ),
      ),
      onTap: () {
        onTapFunction();
        //getIt<DrawerService>().currentMenuItem = 'filters';
      },
    );
  }
}
