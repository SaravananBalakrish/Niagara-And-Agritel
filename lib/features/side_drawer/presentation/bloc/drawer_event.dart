abstract class DrawerEvent {}

class ToggleDrawerItemVisibility extends DrawerEvent {
  final String itemId;
  ToggleDrawerItemVisibility(this.itemId);
}
