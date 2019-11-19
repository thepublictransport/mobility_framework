import 'package:geolocator/geolocator.dart';
import 'package:mobility_framework/backend/constants/TrainAPIConstants.dart';
import 'package:mobility_framework/backend/http/SuperchargedHttp.dart';
import 'package:mobility_framework/backend/models/core/DepartureModel.dart';
import 'package:mobility_framework/backend/models/core/LocationModel.dart';
import 'package:mobility_framework/backend/models/core/TripModel.dart';
import 'package:mobility_framework/backend/service/nominatim/NominatimRequest.dart';

class CoreService {
  static Future<DepartureModel> getDeparture(
      String stationId, String source) async {
    var result = await SuperchargedHTTP.request(
        URL: TrainAPIConstants.API_URL +
            TrainAPIConstants.API_ENDPOINT_DEPARTURE +
            "?stationId=" +
            stationId +
            "&source=" +
            source +
            "&hourshift=" +
            "2" +
            "&equiv=" +
            "true",
        timeout: 5000);

    return DepartureModel.fromJson(result);
  }

  static Future<TripModel> getTripByName(
      String from,
      String to,
      String when,
      String accessibility,
      String optimization,
      String walkspeed,
      String source,
      String products) async {
    var result = await SuperchargedHTTP.request(
        URL: TrainAPIConstants.API_URL +
            TrainAPIConstants.API_ENDPOINT_TRIP +
            TrainAPIConstants.API_ENDPOINT_TRIP_SEARCH_NAME +
            "?from=" +
            from +
            "&to=" +
            to +
            "&when=" +
            when +
            "&accessibility=" +
            accessibility +
            "&optimization=" +
            optimization +
            "&walkspeed=" +
            walkspeed +
            "&source=" +
            source +
            "&products=" +
            products,
        timeout: 5000);

    return TripModel.fromJson(result);
  }

  static Future<TripModel> getTripById(
      String from,
      String to,
      String when,
      String accessibility,
      String optimization,
      String walkspeed,
      String source,
      String products) async {
    var result = await SuperchargedHTTP.request(
        URL: TrainAPIConstants.API_URL +
            TrainAPIConstants.API_ENDPOINT_TRIP +
            TrainAPIConstants.API_ENDPOINT_TRIP_SEARCH_ID +
            "?from=" +
            from +
            "&to=" +
            to +
            "&when=" +
            when +
            "&accessibility=" +
            accessibility +
            "&optimization=" +
            optimization +
            "&walkspeed=" +
            walkspeed +
            "&source=" +
            source +
            "&products=" +
            products,
        timeout: 5000);

    print(TrainAPIConstants.API_URL +
        TrainAPIConstants.API_ENDPOINT_TRIP +
        TrainAPIConstants.API_ENDPOINT_TRIP_SEARCH_ID +
        "?from=" +
        from +
        "&to=" +
        to +
        "&when=" +
        when +
        "&accessibility=" +
        accessibility +
        "&optimization=" +
        optimization +
        "&walkspeed=" +
        walkspeed +
        "&source=" +
        source +
        "&products=" +
        products);

    return TripModel.fromJson(result);
  }

  static Future<LocationModel> getLocationQuery(
      String query, String types, String maxLocations, String source) async {
    var result = await SuperchargedHTTP.request(
        URL: TrainAPIConstants.API_URL +
            TrainAPIConstants.API_ENDPOINT_LOCATION +
            TrainAPIConstants.API_ENDPOINT_LOCATION_SUGGEST +
            "?q=" +
            query +
            "&maxLocations=" +
            maxLocations +
            "&maxDistance=" +
            "10000" +
            "&source=" +
            source,
        timeout: 5000);

    return LocationModel.fromJson(result);
  }

  static Future<LocationModel> getLocationNearby(
      String maxLocations, String source) async {
    var coordinates = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

    var result = await SuperchargedHTTP.request(
        URL: TrainAPIConstants.API_URL +
            TrainAPIConstants.API_ENDPOINT_LOCATION +
            TrainAPIConstants.API_ENDPOINT_LOCATION_NEARBY +
            "?lat=" +
            coordinates.latitude.toString() +
            "&lon=" +
            coordinates.longitude.toString() +
            "&types=" +
            "STATION" +
            "&maxLocations=" +
            maxLocations +
            "&source=" +
            source,
        timeout: 5000);

    return LocationModel.fromJson(result);
  }

  static Future<LocationModel> getLocationNearbyCoord(
      double lat, double lon, String maxLocations, String source) async {
    var result = await SuperchargedHTTP.request(
        URL: TrainAPIConstants.API_URL +
            TrainAPIConstants.API_ENDPOINT_LOCATION +
            TrainAPIConstants.API_ENDPOINT_LOCATION_NEARBY +
            "?lat=" +
            lat.toString() +
            "&lon=" +
            lon.toString() +
            "&types=" +
            "STATION" +
            "&maxLocations=" +
            maxLocations +
            "&source=" +
            source,
        timeout: 5000);

    return LocationModel.fromJson(result);
  }

  static Future<LocationModel> getLocationNearbyAlternative(
      String maxLocations, String source) async {
    var geolocator = Geolocator();
    var coordinates = await geolocator.getCurrentPosition();
    var nominatim = await NominatimRequest.getPlace(
        coordinates.latitude, coordinates.longitude);

    var result = await SuperchargedHTTP.request(
        URL: TrainAPIConstants.API_URL +
            TrainAPIConstants.API_ENDPOINT_LOCATION +
            TrainAPIConstants.API_ENDPOINT_LOCATION_SUGGEST +
            "?q=" +
            nominatim.address.road +
            "," +
            nominatim.address.city +
            "&types=" +
            "STATION" +
            "&maxLocations=" +
            maxLocations +
            "&source=" +
            source,
        timeout: 5000);

    return LocationModel.fromJson(result);
  }

  static Future<LocationModel> getLocationNearbyAlternativeCoord(
      double lat, double lon, String maxLocations, String source) async {
    var nominatim = await NominatimRequest.getPlace(lat, lon);

    var result = await SuperchargedHTTP.request(
        URL: TrainAPIConstants.API_URL +
            TrainAPIConstants.API_ENDPOINT_LOCATION +
            TrainAPIConstants.API_ENDPOINT_LOCATION_SUGGEST +
            "?q=" +
            nominatim.address.road +
            "," +
            nominatim.address.city +
            "&types=" +
            "STATION" +
            "&maxLocations=" +
            maxLocations +
            "&source=" +
            source,
        timeout: 5000);

    return LocationModel.fromJson(result);
  }
}
