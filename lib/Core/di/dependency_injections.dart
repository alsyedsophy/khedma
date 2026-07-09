import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:khedma/core/network/network_info.dart';
import 'package:khedma/app/routing/route_config.dart';
import 'package:khedma/app/routing/router_notifier.dart';
import 'package:khedma/features/Services/data/datasources/service_remote_data_surce.dart';
import 'package:khedma/features/Services/data/repositories/services_repo_impl.dart';
import 'package:khedma/features/Services/domain/repositories/services_repo.dart';
import 'package:khedma/features/Services/domain/usecases/services_usecases.dart';
import 'package:khedma/features/Services/presentation/cubits/Listings/service_listing_cubit.dart';
import 'package:khedma/features/Services/presentation/cubits/Offers/service_offer_cubit.dart';
import 'package:khedma/features/Services/presentation/cubits/Request/service_request_cubit.dart';
import 'package:khedma/features/Subscriptions/data/datasources/subscription_remote_data_source.dart';
import 'package:khedma/features/Subscriptions/data/repositories/subscription_repository_impl.dart';
import 'package:khedma/features/Subscriptions/domain/repositories/subscription_repository.dart';
import 'package:khedma/features/Subscriptions/domain/usecases/subscriptions_use_cases.dart';
import 'package:khedma/features/Subscriptions/presentation/cubit/subscription_cubit.dart';
import 'package:khedma/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:khedma/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:khedma/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:khedma/features/auth/domain/repositories/auth_repo.dart';
import 'package:khedma/features/auth/domain/usecases/auth_use_cases.dart';
import 'package:khedma/features/auth/presentation/cubit/Auth/auth_cubit.dart';
import 'package:khedma/features/auth/presentation/cubit/Location/location_cubit.dart';
import 'package:khedma/features/categories/data/datasources/categories_remote_data_source.dart';
import 'package:khedma/features/categories/data/repositories/categories_repo_impl.dart';
import 'package:khedma/features/categories/domain/repositories/categories_repo.dart';
import 'package:khedma/features/categories/domain/usecases/get_categories_use_case.dart';
import 'package:khedma/features/categories/presentation/bloc/categories_bloc.dart';
import 'package:khedma/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:khedma/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:khedma/features/chat/domain/repositories/chat_repository.dart';
import 'package:khedma/features/chat/domain/usecases/create_conversation_use_case.dart';
import 'package:khedma/features/chat/domain/usecases/get_conversations_use_case.dart';
import 'package:khedma/features/chat/domain/usecases/get_messages_use_case.dart';
import 'package:khedma/features/chat/domain/usecases/send_message_use_case.dart';
import 'package:khedma/features/chat/presentation/cubits/chat/chat_cubit.dart';
import 'package:khedma/features/chat/presentation/cubits/conversation/conversation_list_cubit.dart';
import 'package:khedma/features/Notification/data/datasources/notification_remote_data_source.dart';
import 'package:khedma/features/Notification/data/repositories/notification_repo_impl.dart';
import 'package:khedma/features/Notification/domain/repositories/notification_repo.dart';
import 'package:khedma/features/Notification/domain/usecases/notificaiton_usecases.dart';
import 'package:khedma/features/Notification/presentation/cubit/notification_cubit.dart';
import 'package:khedma/features/Notification/presentation/cubit/notification_settings_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //? Core
  sl.registerLazySingleton<Connectivity>(() => Connectivity());
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(connectivity: sl<Connectivity>()),
  );

  //? Router
  sl.registerLazySingleton(() => RouterNotifier(sl<AuthCubit>()));
  sl.registerLazySingleton(() => RouteConfig(notifier: sl()));

  //? External
  final sharedPref = await SharedPreferences.getInstance();
  final firebaseAuth = FirebaseAuth.instance;
  final google = GoogleSignIn.instance;
  final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;
  final facebook = FacebookAuth.instance;
  sl.registerLazySingleton(() => sharedPref);
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(aOptions: AndroidOptions()),
  );

  sl.registerLazySingleton<FirebaseAuth>(() => firebaseAuth);
  sl.registerLazySingleton<GoogleSignIn>(() => google);
  sl.registerLazySingleton<FirebaseFirestore>(() => firestore);
  sl.registerLazySingleton<FirebaseStorage>(() => storage);
  sl.registerLazySingleton<FacebookAuth>(() => facebook);

  //! ===============================================

  //? Auth Feature
  // data
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(secureStorage: sl(), sharedPreferences: sl()),
  );
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: sl(),
      googleSignIn: sl(),
      firestore: sl(),
      facebookAuth: sl(),
    ),
  );

  // Repository
  sl.registerLazySingleton<AuthRepo>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl<AuthRemoteDataSource>(),
      localDataSource: sl<AuthLocalDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Usecases
  sl.registerLazySingleton(() => CheckEmailVerifiedUseCase(sl()));
  sl.registerLazySingleton(() => CreateAcountUseCase(sl()));
  sl.registerLazySingleton(() => GetCachedUserUseCase(sl()));
  sl.registerLazySingleton(() => IsFirstTimeUseCase(sl()));
  sl.registerLazySingleton(() => LoginWithEmailUseCase(sl()));
  sl.registerLazySingleton(() => LoginWithFacebookUseCase(sl()));
  sl.registerLazySingleton(() => LoginWithGoogleUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => SendPasswordResetEmailUseCase(sl()));
  sl.registerLazySingleton(() => SetFirstTimeDoneUseCase(sl()));
  sl.registerLazySingleton(() => SetLocationSelectedUseCase(sl()));
  sl.registerLazySingleton(() => SetLocationAddressUseCase(sl()));
  sl.registerLazySingleton(() => SetProfileCompletedUseCase(sl()));
  sl.registerLazySingleton(() => SetUserTypeUseCase(sl()));
  sl.registerLazySingleton(() => UpdateUserUseCase(sl()));
  sl.registerLazySingleton(() => VerifyEmailUseCase(sl()));

  // Cubit
  //! Auth Cubit
  sl.registerLazySingleton(
    () => AuthCubit(
      checkEmailVerifiedUseCase: sl(),
      createAcountUseCase: sl(),
      getCachedUserUseCase: sl(),
      isFirstTimeUseCase: sl(),
      loginWithEmailUseCase: sl(),
      loginWithFacebookUseCase: sl(),
      loginWithGoogleUseCase: sl(),
      logoutUseCase: sl(),
      sendPasswordResetEmailUseCase: sl(),
      setFirstTimeDoneUseCase: sl(),
      setLocationSelectedUseCase: sl(),
      setLocationAddressUseCase: sl(),
      setUserTypeUseCase: sl(),
      setProfileCompletedUseCase: sl(),
      updateUserUseCase: sl(),
      verifiyEmailUseCase: sl(),
    ),
  );

  //! Location Cubit
  sl.registerFactory(() => LocationPickerCubit(sl(), sl()));

  //! ==============================================

  //? Categories Feature

  // Data
  sl.registerLazySingleton<CategoriesRemoteDataSource>(
    () => CategoriesRemoteDataSourceImpl(firestore: sl()),
  );

  // Repository
  sl.registerLazySingleton<CategoriesRepo>(
    () => CategoriesRepoImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // Use cases
  sl.registerFactory(() => GetCategoriesUseCase(repo: sl()));

  // Bloc
  sl.registerFactory(() => CategoriesBloc(sl()));

  //! ======================================================
  //? ================ Services Feature ==================

  // Data
  sl.registerLazySingleton<ServiceRemoteDataSource>(
    () => ServiceRemoteDataSourceImpl(firestore: sl(), auth: sl()),
  );

  // Repository
  sl.registerLazySingleton<ServicesRepo>(
    () => ServiceRepoImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => AcceptOfferUseCase(servicesRepo: sl()));
  sl.registerLazySingleton(() => CreateOfferUseCase(servicesRepo: sl()));
  sl.registerLazySingleton(
    () => CreateServiceListingUseCase(servicesRepo: sl()),
  );
  sl.registerLazySingleton(
    () => CreateServiceRequestUseCase(servicesRepo: sl()),
  );
  sl.registerLazySingleton(
    () => DeleteServiceListingUseCase(servicesRepo: sl()),
  );
  sl.registerLazySingleton(
    () => DeleteServiceRequestUseCase(servicesRepo: sl()),
  );
  sl.registerLazySingleton(
    () => GetAllServiceListingsUseCase(servicesRepo: sl()),
  );
  sl.registerLazySingleton(() => GetMyOffersUseCase(servicesRepo: sl()));
  sl.registerLazySingleton(() => GetMyRequestsUseCase(servicesRepo: sl()));
  sl.registerLazySingleton(
    () => GetMyServiceListingsUseCase(servicesRepo: sl()),
  );
  sl.registerLazySingleton(
    () => GetOffersForRequestUseCase(servicesRepo: sl()),
  );
  sl.registerLazySingleton(() => GetOpenRequestsUseCase(servicesRepo: sl()));
  sl.registerLazySingleton(
    () => GetRequestsByCategoryUseCase(servicesRepo: sl()),
  );
  sl.registerLazySingleton(() => RejectOfferUseCase(servicesRepo: sl()));
  sl.registerLazySingleton(
    () => UpdateRequestStatusUseCase(servicesRepo: sl()),
  );
  sl.registerLazySingleton(
    () => UpdateServiceListingAvailabilityUseCase(servicesRepo: sl()),
  );

  // Cubits

  // ========= Listings ===========
  sl.registerFactory(
    () => ServiceListingCubit(
      createServiceListing: sl(),
      getAllServiceListings: sl(),
      getMyServiceListings: sl(),
      updateAvailability: sl(),
      deleteServiceListing: sl(),
    ),
  );

  // ========== Offers =========
  sl.registerFactory(
    () => ServiceOfferCubit(
      createOffer: sl(),
      getOffersForRequest: sl(),
      getMyOffers: sl(),
      acceptOffer: sl(),
      rejectOffer: sl(),
    ),
  );

  // ========== Requests =========
  sl.registerFactory(
    () => ServiceRequestCubit(
      createServiceRequest: sl(),
      getMyRequests: sl(),
      getOpenRequests: sl(),
      getRequestsByCategory: sl(),
      updateRequestStatus: sl(),
      deleteServiceRequest: sl(),
    ),
  );

  //! =========================================
  //? Chat

  // Data Source
  sl.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(sl(), sl()),
  );

  // Repository
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // Usecases
  sl.registerLazySingleton(() => CreateConversationUseCase(sl()));
  sl.registerLazySingleton(() => GetConversationsUseCase(sl()));
  sl.registerLazySingleton(() => GetMessagesUseCase(sl()));
  sl.registerLazySingleton(() => SendMessageUseCase(sl()));

  // Cubits
  // Conversation
  sl.registerLazySingleton(
    () => ConversationListCubit(
      getConversationsUseCase: sl(),
      createConversationUseCase: sl(),
    ),
  );
  // Chat
  sl.registerFactory(
    () => ChatCubit(getMessagesUseCase: sl(), sendMessageUseCase: sl()),
  );

  //! =========================================
  //? Subscriptions

  // Data Source
  sl.registerLazySingleton<SubscriptionRemoteDataSource>(
    () => SubscriptionRemoteDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<SubscriptionRepository>(
    () => SubscriptionRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // Usecases
  sl.registerLazySingleton(() => CheckQuotasUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentSubUseCase(sl()));
  sl.registerLazySingleton(() => GetPlansUseCase(sl()));
  sl.registerLazySingleton(() => IncrementQuotaUseCase(sl()));
  sl.registerLazySingleton(() => PurchasePlanUseCase(sl()));
  sl.registerLazySingleton(() => RestorePurchasesUseCase(sl()));

  // Cubits
  sl.registerFactory(
    () => SubscriptionCubit(
      getPlansUseCase: sl(),
      purchasePlanUseCase: sl(),
      getCurrentSubscriptionUseCase: sl(),
      restorePurchasesUseCase: sl(),
      checkQuotaUseCase: sl(),
      incrementQuotaUseCase: sl(),
    ),
  );

  //! =========================================
  //? Notifications

  // Data Source
  sl.registerLazySingleton<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSourceImpl(firestore: sl()),
  );

  // Repository
  sl.registerLazySingleton<NotificationRepo>(
    () => NotificationRepoImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // Usecases
  sl.registerLazySingleton(() => GetNotificationsUseCase(sl()));
  sl.registerLazySingleton(() => MarkAsReadUseCase(sl()));
  sl.registerLazySingleton(() => MarkAllAsReadUseCase(sl()));
  sl.registerLazySingleton(() => GetPreferencesUseCase(sl()));
  sl.registerLazySingleton(() => UpdatePreferencesUseCase(sl()));

  // Cubits
  sl.registerFactory(
    () => NotificationCubit(
      getNotifications: sl(),
      markAsRead: sl(),
      markAllAsRead: sl(),
    ),
  );
  sl.registerFactory(
    () => NotificationSettingsCubit(
      getPreferences: sl(),
      updatePreferences: sl(),
    ),
  );
}
