import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum LocationPickerStatus {
  initial,
  loading,
  loaded,
  error,
  confirming,
  confirmed,
}

class LocationPickerState extends Equatable {
  final LocationPickerStatus status;
  final LatLng? selectedLocation;
  final String? address;
  final String? errorMessage;

  const LocationPickerState({
    this.status = LocationPickerStatus.initial,
    this.selectedLocation,
    this.address,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [status, selectedLocation, address, errorMessage];

  LocationPickerState copyWith({
    LocationPickerStatus? status,
    LatLng? selectedLocation,
    String? address,
    String? errorMessage,
  }) {
    return LocationPickerState(
      status: status ?? this.status,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      address: address ?? this.address,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
