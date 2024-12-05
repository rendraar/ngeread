import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class MapsController extends GetxController {
  Rx<Position?> currentPosition = Rx<Position?>(null);
  RxString locationMessage = "Let's trace your location!".obs;
  RxString addressMessage = "Fetching address...".obs;
  RxBool loading = false.obs;

  Future<void> getCurrentLocation() async {
    if (locationMessage.value != "Let's trace your location!") {
      return; // Jika lokasi sudah tersedia, tidak perlu mencari ulang
    }

    loading.value = true;
    try {
      await _ensureLocationServiceEnabled();
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      currentPosition.value = position;

      // Perbarui nama tempat
      await _updateLocationMessage(position);
    } catch (e) {
      locationMessage.value = 'Failed to determine location';
      addressMessage.value = 'Failed to fetch address';
    } finally {
      loading.value = false;
    }
  }

  Future<void> _ensureLocationServiceEnabled() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      throw Exception('Location service not enabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permission denied forever');
    }
  }

  Future<void> _updateLocationMessage(Position position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        locationMessage.value =
            "${place.name}, ${place.subLocality}, ${place.locality}";
        addressMessage.value =
            "${place.name}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      } else {
        locationMessage.value = "Location name not found";
        addressMessage.value = "No address found";
      }
    } catch (e) {
      locationMessage.value = "Failed to fetch location name";
      addressMessage.value = "Failed to fetch address";
    }
  }

  void openGoogleMaps() {
    if (currentPosition.value != null) {
      final url =
          'https://www.google.com/maps?q=${currentPosition.value!.latitude},${currentPosition.value!.longitude}';
      _launchURL(url);
    }
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
