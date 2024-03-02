import 'dart:async';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:notificatio_and_location_permission/model/location_state_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'provider.g.dart';

@riverpod
class LocationState extends _$LocationState {
  @override
  ProviderState build() {
    _getLocationData();
    return ProviderState(location: [], timer: null);
  }

  Future<Position> _getCurrentLocation() async {
    return await Geolocator.getCurrentPosition();
  }

  /// Start polling
  Future<void> startLocationPolling() async {
    if (state.timer != null) {
      return;
    }

    final timer = Timer.periodic(const Duration(seconds: 30), (timer) async {
      final newLocation = await _getCurrentLocation();
      final locationData = LocationData(
        lat: newLocation.latitude,
        lon: newLocation.longitude,
        speed: newLocation.speed,
      );

      state = state.copyWith(
        location: [
          ...state.location,
          locationData,
        ],
      );

      _saveLocation(locationData, state.location.length - 1);
    });

    state = state.copyWith(timer: timer);
  }

  void stopLocationPolling() {
    if (state.timer != null) {
      state.timer!.cancel();
      state = state.copyWith(timer: null);
    }
  }

  void _saveLocation(LocationData data, int index) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.setString('$index', jsonEncode(data.toJson()));
  }

  Future<void> _getLocationData() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final locations = <LocationData>[];

    var i = 0;
    while (true) {
      if (sharedPrefs.containsKey(i.toString())) {
        final locationJson = sharedPrefs.getString('$i');
        locations.add(LocationData.fromJson(jsonDecode(locationJson!)));
      } else {
        break;
      }
    }

    state = state.copyWith(location: locations);
  }
}
