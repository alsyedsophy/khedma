// location_picker_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:khedma/features/auth/domain/usecases/auth_use_cases.dart';
import 'package:khedma/features/auth/domain/usecases/set_location_address_use_case.dart';
import 'package:khedma/features/auth/presentation/cubit/Location/location_state.dart';

class LocationPickerCubit extends Cubit<LocationPickerState> {
  final SetLocationSelectedUseCase setLocationSelectedUseCase;
  final SetLocationAddressUseCase setLocationAddressUseCase;

  LocationPickerCubit(
    this.setLocationSelectedUseCase,
    this.setLocationAddressUseCase,
  ) : super(const LocationPickerState());

  /// الحصول على الموقع الحالي للمستخدم
  Future<void> getCurrentLocation() async {
    emit(state.copyWith(status: LocationPickerStatus.loading));

    // 1. التحقق من تفعيل خدمة الموقع
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      emit(
        state.copyWith(
          status: LocationPickerStatus.error,
          errorMessage: 'خدمة الموقع غير مفعلة. يرجى تفعيلها من الإعدادات.',
        ),
      );
      return;
    }

    // 2. التحقق من الأذونات
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        emit(
          state.copyWith(
            status: LocationPickerStatus.error,
            errorMessage: 'تم رفض إذن الموقع. لا يمكن تحديد موقعك.',
          ),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      emit(
        state.copyWith(
          status: LocationPickerStatus.error,
          errorMessage: 'تم رفض إذن الموقع نهائياً. يرجى تفعيله من الإعدادات.',
        ),
      );
      return;
    }

    // 3. جلب الموقع
    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      final newLocation = LatLng(position.latitude, position.longitude);
      await updateLocation(newLocation);
    } catch (e) {
      emit(
        state.copyWith(
          status: LocationPickerStatus.error,
          errorMessage: 'فشل في الحصول على الموقع: ${e.toString()}',
        ),
      );
    }
  }

  /// تحديث الموقع المحدد (عند النقر على الخريطة أو البحث)
  Future<void> updateLocation(LatLng newLocation) async {
    emit(
      state.copyWith(
        status: LocationPickerStatus.loading,
        selectedLocation: newLocation,
      ),
    );

    try {
      final address = await _getAddressFromLatLng(newLocation);
      emit(
        state.copyWith(
          status: LocationPickerStatus.loaded,
          selectedLocation: newLocation,
          address: address,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: LocationPickerStatus.loaded,
          selectedLocation: newLocation,
          address: 'عنوان غير معروف',
        ),
      );
    }
  }

  /// تحويل الإحداثيات إلى عنوان نصي
  Future<String> _getAddressFromLatLng(LatLng location) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        final street = p.street ?? '';
        final city = p.locality ?? p.administrativeArea ?? '';
        final country = p.country ?? '';
        return '$street, $city, $country'.replaceAll(RegExp(r'^, |, $'), '');
      }
      return 'عنوان غير معروف';
    } catch (e) {
      return 'تعذر جلب العنوان';
    }
  }

  /// البحث عن موقع عبر كلمة نصية وتحريك الخريطة إليه
  Future<void> searchAddress(String query) async {
    if (query.isEmpty) return;

    emit(state.copyWith(status: LocationPickerStatus.loading));
    try {
      List<Location> locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        final location = locations.first;
        final newLatLng = LatLng(location.latitude, location.longitude);
        await updateLocation(newLatLng);
      } else {
        emit(
          state.copyWith(
            status: LocationPickerStatus.error,
            errorMessage: 'لم يتم العثور على العنوان المطلوب',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: LocationPickerStatus.error,
          errorMessage: 'حدث خطأ أثناء البحث: ${e.toString()}',
        ),
      );
    }
  }

  /// تأكيد الموقع (يمكن استدعاؤها من الـ UI لتمرير النتيجة)
  void confirmLocation() async {
    if (state.selectedLocation != null && state.address != null) {
      emit(state.copyWith(status: LocationPickerStatus.confirming));
      // هنا يمكن حفظ الموقع في Firestore أو تمريره إلى Cubit آخر
      final result = await setLocationSelectedUseCase();
      result.fold(
        (failure) => emit(state.copyWith(status: LocationPickerStatus.error)),
        (_) async {
          final setAddress = await setLocationAddressUseCase(
            state.selectedLocation!,
            state.address!,
          );
          setAddress.fold(
            (failure) =>
                emit(state.copyWith(status: LocationPickerStatus.error)),
            (_) => emit(state.copyWith(status: LocationPickerStatus.confirmed)),
          );
        },
      );
      // بعد نجاح العملية:
      emit(state.copyWith(status: LocationPickerStatus.confirmed));
    }
  }

  /// إعادة تعيين الحالة (عند الخروج من الصفحة)
  void reset() {
    emit(const LocationPickerState());
  }
}
