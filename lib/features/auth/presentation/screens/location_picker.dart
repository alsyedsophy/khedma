// location_picker_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:khedma/core/di/dependency_injections.dart';
import 'package:khedma/features/auth/presentation/cubit/Auth/auth_cubit.dart';
import 'package:khedma/features/auth/presentation/cubit/Location/location_cubit.dart';
import 'package:khedma/features/auth/presentation/cubit/Location/location_state.dart';
import 'package:khedma/features/auth/presentation/widgets/location_card.dart';

class LocationPickerPage extends StatelessWidget {
  const LocationPickerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<LocationPickerCubit>()..getCurrentLocation(),
      child: const LocationPickerView(),
    );
  }
}

class LocationPickerView extends StatefulWidget {
  const LocationPickerView({super.key});

  @override
  State<LocationPickerView> createState() => _LocationPickerViewState();
}

class _LocationPickerViewState extends State<LocationPickerView> {
  GoogleMapController? _mapController;

  @override
  void dispose() {
    context.read<LocationPickerCubit>().reset();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _moveCamera(LatLng location) {
    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(location, 15));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('اختر موقعك'), centerTitle: true),
      body: BlocConsumer<LocationPickerCubit, LocationPickerState>(
        listener: (context, state) {
          if (state.status == LocationPickerStatus.confirmed) {
            // إبلاغ AuthCubit بأن الموقع تم اختياره
            context.read<AuthCubit>().locationSelected();
            // يمكن إغلاق الصفحة أو الانتقال تلقائياً
            // Navigator.of(context).pop();
          }
          if (state.status == LocationPickerStatus.error &&
              state.errorMessage != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          }
        },
        builder: (context, state) {
          final cubit = context.read<LocationPickerCubit>();
          final isLoading = state.status == LocationPickerStatus.loading;
          final isConfirming = state.status == LocationPickerStatus.confirming;

          return Stack(
            children: [
              // الخريطة
              if (state.selectedLocation != null)
                GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: state.selectedLocation!,
                    zoom: 15,
                  ),
                  onTap: (latLng) => cubit.updateLocation(latLng),
                  markers: {
                    Marker(
                      markerId: const MarkerId('selected'),
                      position: state.selectedLocation!,
                      infoWindow: InfoWindow(title: state.address),
                    ),
                  },
                  myLocationEnabled: true,
                ),

              // مؤشر التحميل العام
              if (isLoading) const Center(child: CircularProgressIndicator()),

              // البطاقة السفلية
              Positioned(
                bottom: 20,
                left: 16,
                right: 16,
                child: LocationCard(
                  address: state.address ?? 'جاري تحديد العنوان...',
                  onConfirm: cubit.confirmLocation,
                  isConfirming: isConfirming,
                  onMyLocation: cubit.getCurrentLocation,
                  onSearch: (query) async {
                    await cubit.searchAddress(query);
                    if (context.mounted && state.selectedLocation != null) {
                      _moveCamera(state.selectedLocation!);
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
