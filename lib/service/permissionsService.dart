import 'package:permission_handler/permission_handler.dart';

class PermissionsService {
  final PermissionHandler _permissionHandler = PermissionHandler();
  Future<bool> _requestPermission(PermissionGroup permission) async {
    var result = await _permissionHandler.requestPermissions([permission]);
    if (result[permission] == PermissionStatus.granted) {
      return true;
    }
    return false;
  }

  Future<bool> requestLocationPermission() async {
    return _requestPermission(PermissionGroup.location);
  }

  Future<bool> requestLocationAlwaysPermission() async {
    return _requestPermission(PermissionGroup.locationAlways);
  }

  Future<bool> requestLocationWhenInUsePermission() async {
    return _requestPermission(PermissionGroup.locationWhenInUse);
  }
}
