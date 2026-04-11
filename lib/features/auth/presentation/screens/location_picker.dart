// location_picker_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:khedma/app/dependency_injections.dart';
import 'package:khedma/features/auth/presentation/cubit/Auth/auth_cubit.dart';
import 'package:khedma/features/auth/presentation/cubit/Location/location_cubit.dart';
import 'package:khedma/features/auth/presentation/cubit/Location/location_state.dart';

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
                child: _LocationCard(
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

// ويدجت البطاقة السفلية
class _LocationCard extends StatefulWidget {
  final String address;
  final VoidCallback onConfirm;
  final VoidCallback onMyLocation;
  final Function(String) onSearch;
  final bool isConfirming;

  const _LocationCard({
    required this.address,
    required this.onConfirm,
    required this.onMyLocation,
    required this.onSearch,
    required this.isConfirming,
  });

  @override
  State<_LocationCard> createState() => _LocationCardState();
}

class _LocationCardState extends State<_LocationCard> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // حقل البحث
            TextField(
              controller: _searchController,
              focusNode: _searchFocus,
              decoration: InputDecoration(
                hintText: 'ابحث عن عنوان...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  widget.onSearch(value);
                }
              },
            ),
            const SizedBox(height: 12),
            // عرض العنوان المختار
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.blue),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.address,
                    style: const TextStyle(fontSize: 16),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // أزرار الإجراءات
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: widget.onMyLocation,
                    icon: const Icon(Icons.my_location),
                    label: const Text('موقعي الحالي'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: widget.isConfirming ? null : widget.onConfirm,
                    icon: widget.isConfirming
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.check_circle),
                    label: Text(
                      widget.isConfirming ? 'جاري الحفظ...' : 'تأكيد الموقع',
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
