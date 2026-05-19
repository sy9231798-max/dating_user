import 'package:dating_user/core/constant/api_endpoints.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';


final di = GetIt.instance;

Future<void> initializeDependency() async {
  di.registerSingleton<Dio>(Dio(BaseOptions(
    baseUrl: ApiEndpoints.baseUrl
  )));
  // di.registerSingleton<StorageService>(StorageService());
  //
  // di.registerSingleton<DebugRepo>(DebugRepo());
  // di.registerSingleton(InAppPurchaseUtil());
  // di.registerSingleton<InternetConnection>(InternetConnection());
  // di.registerSingleton<AuthenticationRepository>(AuthenticationRepositoryImpl(dio: di()));
  //
  // di.registerSingleton<GetGoogleLogin>(GetGoogleLogin(authenticationRepository: di()));
  // di.registerSingleton<GetFacebookLogin>(GetFacebookLogin(authenticationRepository: di()));
  // di.registerSingleton<VerifyOtpUseCase>(VerifyOtpUseCase(repo: di()));
  // di.registerSingleton<SendMail>(SendMail(di()));
  //
  // di.registerSingleton<DashboardRepository>(DashboardRepositoryImpl(dio: di(), storageService: di()));
  // di.registerSingleton<GetDashboardStatUseCase>(GetDashboardStatUseCase(repo: di()));
  // di.registerSingleton<GetCategoryUseCase>(GetCategoryUseCase(repo: di()));
  // di.registerSingleton<UniversalBloc>(UniversalBloc());
  // di.registerSingleton<AudioRepository>(AudioRepositoryImpl(dio: di(), storageService: di()));
  // di.registerSingleton<VideoRepo>(VideoRepositoryImpl(dio: di(), storageService: di()));
  //
  // //Habit
  // di.registerSingleton<HabitRepository>(HabitRepositoryImpl(dio: di(), storageService: di()));
  // di.registerSingleton<GetTodayHabitUseCase>(GetTodayHabitUseCase(repo: di()));
  // di.registerSingleton<GetAllHabitUseCase>(GetAllHabitUseCase(repo: di()));
  // di.registerSingleton<UpdateCompletionUseCase>(UpdateCompletionUseCase(repo: di()));
  // di.registerSingleton<AudioManager>(AudioManager());
  //
  // di.registerSingleton<VideoPlayerRepository>(VideoPlayerRepositoryImpl(dio: di(), storageService: di()));
  // di.registerSingleton<SetChecklistProgressUseCase>(SetChecklistProgressUseCase(repo: di()));
  //
  // di.registerSingleton<UpdateVideoLikeUseCase>(UpdateVideoLikeUseCase(repo: di()));
  // di.registerSingleton<UpdateVideoIsCompletedUseCase>(UpdateVideoIsCompletedUseCase(repo: di()));
  // di.registerSingleton<UpdateVideoPlaylistUseCase>(UpdateVideoPlaylistUseCase(repo: di()));
  //
  // di.registerSingleton<GetLessonVideosUseCase>(GetLessonVideosUseCase(repo: di()));
  // di.registerSingleton<VideoPlayerBloc>(VideoPlayerBloc(setChecklistProgressUseCase: di(), updateVideoIsCompletedUseCase: di(), updateVideoLikeUseCase: di(), updateVideoPlaylistUseCase: di(), getLessonVideosUseCase: di()));
  // di.registerSingleton<AudioManagerBloc>(AudioManagerBloc(audioManager: di()));
  //
  // di.registerSingleton<UpdateAudioPlaylistUseCase>(UpdateAudioPlaylistUseCase(repo: di()));
  // di.registerSingleton<ProfileRepository>(ProfileRepositoryImpl(dio: di(), storageService: di()));
  //
  // di.registerSingleton<UpdateProfileUseCase>(UpdateProfileUseCase(profileRepository: di()));
  // di.registerSingleton<GetUserProfileUseCase>(GetUserProfileUseCase(repo: di()));
  // di.registerSingleton<UpdateAudioLikeUseCase>(UpdateAudioLikeUseCase(repo: di()));
  //
  // di.registerSingleton<SetVideoChecklistProgressUseCase>(SetVideoChecklistProgressUseCase(repo: di()));
  // di.registerSingleton<UpdateAudioIsCompletedUseCase>(UpdateAudioIsCompletedUseCase(repo: di()));
  // di.registerSingleton<AudioPlayerBloc>(AudioPlayerBloc(audioManager: di(), updateAudioPlaylistUseCase: di(), updateAudioLikeUseCase: di(), setVideoChecklistProgressUseCase: di(), updateAudioIsCompletedUseCase: di()));
  //
  // di.registerSingleton<PlaylistRepository>(PlaylistRepositoryImpl(dio: di(), storageService: di()));
  // di.registerSingleton<GetAudioPlaylistUseCase>(GetAudioPlaylistUseCase(playlistRepository: di()));
  // di.registerSingleton<GetVideoPlaylistUseCase>(GetVideoPlaylistUseCase(playlistRepository: di()));
  //
  // di.registerSingleton<SubscriptionRepository>(SubscriptionRepositoryImpl(dio: di(), storageService: di()));
}
