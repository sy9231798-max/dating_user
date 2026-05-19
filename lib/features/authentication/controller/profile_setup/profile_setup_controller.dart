import 'dart:io';

import 'package:country_state_city/country_state_city.dart';
import 'package:country_state_city/models/city.dart' as City;
import 'package:country_state_city/models/state.dart' as State;
import 'package:dating_user/core/common_model/user_profile_status.dart';
import 'package:dating_user/core/constant/api_endpoints.dart';
import 'package:dating_user/core/constant/storage_keys.dart';
import 'package:dating_user/core/helper/dialog_helper.dart';
import 'package:dating_user/core/helper/snackbar_helper.dart';
import 'package:dating_user/features/authentication/controller/profile_setup/profile_setup_repo.dart';
import 'package:dating_user/features/authentication/presentation/profile_setup/profile_setup_video_screen.dart';
import 'package:dating_user/features/main_screen/presentation/main_screen.dart';
import 'package:dating_user/features/splash/presentation/splash_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/enums/profile_setup_status.dart';
import '../../model/profile_setup_detail.dart';
import '../../presentation/profile_setup/profile_setup_detail_screen.dart';

class ProfileSetupController extends GetxController {
  Rxn<UserProfileStatus> profileStatus = Rxn<UserProfileStatus>();

  ProfileSetupController({UserProfileStatus? initialStatus}) {
    profileStatus.value = initialStatus;
  }

  final repo = ProfileSetupRepo();

  static ProfileSetupController get instance => Get.find();

  final isLoading = false.obs;
  final profileImage = "".obs;
  final isMale = false.obs;
  RxList<String> additionImages = RxList();
  final _profileVideo = "".obs;
  RxList<State.State> state = RxList();
  RxList<City.City> city = RxList();

  Rxn<State.State> selectedState = Rxn(null);
  Rxn<City.City> selectedCity = Rxn(null);

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final dobController = TextEditingController();

  var originalImage = "";
  List<String> originalAdditionImage = [];

  RxBool get enableImageSubmit =>
      (profileImage.value != originalImage ||
              !originalAdditionImage.every(
                (element) => originalImage.contains(element),
              ))
          .obs;

  @override
  void onInit() {
    super.onInit();
    Future.microtask(() async {
      var allState = await getStatesOfCountry("IN");
      state.addAll(allState);
    });
  }

  Future<void> fetchProfileStatus() async {
    var value = await repo.getProfileStatus();
    value.fold(
      (l) async {
        profileStatus.value = l;

        try {
          if (l.errorCode == 200) {
            GetStorage().write(StorageKeys.needProfileSetup, false);
            Get.offAll(() => SplashScreen());
            return;
          }
          var allState = await getStatesOfCountry("IN");
          state.addAll(allState);
          var stateIndex = allState.indexWhere(
            (element) => element.name == l.userData?.state,
          );
          if (stateIndex != -1) {
            selectedState.value = allState[stateIndex];

            var allCity = await getStateCities(
              "IN",
              selectedState.value!.isoCode,
            );
            city.addAll(allCity);
            var cityIndex = allCity.indexWhere(
              (element) => element.name == l.userData?.city,
            );
            if (cityIndex != -1) {
              selectedCity.value = allCity[cityIndex];
            }
          }
        } catch (e) {
          Logger().e(e);
        }
      },
      (r) {
        errorSnackBar(Get.overlayContext!, r.message ?? "something went wrong");
      },
    );
  }

  final isVideoInitializing = false.obs;
  Rxn<VideoPlayerController> videoController = Rxn(null);

  Future<XFile?> pickProfileImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    if (kDebugMode) {
      final XFile? photo = await picker.pickImage(source: ImageSource.gallery);
      return photo;
    } else {
      final XFile? photo = await picker.pickImage(source: ImageSource.camera);
      return photo;
    }
  }

  Future<List<XFile>> pickAdditionImage(BuildContext context, int limit) async {
    var photos = await galleryAndCameraDialog(
      context: context,
      multipleGallery: limit >= 2,
      limit: limit,
    );
    return photos;
  }

  Future<XFile?> pickProfileVideo(BuildContext context) async {
    var picker = ImagePicker();
    var video = await picker.pickVideo(
      source: ImageSource.gallery,
      maxDuration: Duration(seconds: 30),
    );

    return video;
  }

  void loadVideo({required String filePath, bool isFile = true}) {
    videoController.value = isFile
        ? VideoPlayerController.file(File(filePath))
        : VideoPlayerController.networkUrl(Uri.parse(filePath));
    isVideoInitializing.value = true;
    videoController.value!.initialize();
    isVideoInitializing.value = true;
  }

  Future<void> removeAdditionImage(BuildContext context, int id) async {
    isLoading.value = true;
    var response = await repo.removeAdditionImage(id: id);
    isLoading.value = false;
    response.fold(
      (l) {
        if (l) {
          fetchProfileStatus();
          successSnackBar(context, "Addition Image removed");
        } else {
          errorSnackBar(
            context,
            "Failed to remove addition image try after some time",
          );
        }
      },
      (r) {
        errorSnackBar(context, r.message ?? "something went wrong");
      },
    );
  }

  ProfileSetupStatusEnum getStatusByResponse({required String response}) {
    return response == "PENDING"
        ? .pending
        : response == "COMPLETED"
        ? .completed
        : .error;
  }

  Future<void> uploadImage(
    BuildContext context,
    List<String> additionImages,
    List<String> copyAdditionImages,
    String profileImage,
  ) async {
    if (additionImages.isEmpty) {
      if (copyAdditionImages.isEmpty) {
        errorSnackBar(context, "Please select additional profile image");
        return;
      }
    }
    if (additionImages.isEmpty) {
      if (copyAdditionImages.length < 3) {
        errorSnackBar(
          context,
          "Please select ${3 - additionImages.length} More additional profile image",
        );
        return;
      }
    }

    if (additionImages.isNotEmpty) {
      if (copyAdditionImages.length < 3) {
        errorSnackBar(
          context,
          "Please select ${3 - additionImages.length} More additional profile image",
        );
        return;
      } else {
        copyAdditionImages.removeWhere(
          (element) => additionImages.contains(element),
        );
      }
    }

    isLoading.value = true;
    var response = await repo.submitProfileImageCall(
      profilePicture: profileImage,
      additionImages: copyAdditionImages.toList(),
    );
    isLoading.value = false;
    response.fold(
      (l) async {
        if (l) {
          await fetchProfileStatus();
          successSnackBar(context, "Profile image updated");
          var videoLink = profileStatus.value!.userData?.videoPicture;
          Get.off(
            () => ProfileSetupVideoScreen(
              originalVideo: videoLink ?? "",
              error: switch (getStatusByResponse(
                response: profileStatus.value!.step2ErrorMessage,
              )) {
                ProfileSetupStatusEnum.pending => "",
                ProfileSetupStatusEnum.completed => "",
                ProfileSetupStatusEnum.error =>
                  profileStatus.value!.step2ErrorMessage,
                ProfileSetupStatusEnum.waiting => "",
              },
            ),
          );
        } else {
          errorSnackBar(context, "Failed to upload image try after some time");
        }
      },
      (r) {
        errorSnackBar(context, r.message ?? "something went wrong");
      },
    );
  }

  Future<void> uploadVideo(BuildContext context, String video) async {
    if (video.isEmpty) {
      errorSnackBar(context, "Video Cannot Be Empty");
      return;
    }
    isLoading.value = true;
    var response = await repo.submitProfileVideoCall(videoPath: video);
    isLoading.value = false;
    response.fold(
      (l) async {
        if (l) {
          await fetchProfileStatus();
          successSnackBar(context, "Video updated");
          final user = profileStatus.value?.userData;
          Get.off(
            () => LoginProfileDetailScreen(
              firstName: user?.firstName ?? "",
              lastName: user?.lastName ?? '',
              email: user?.email ?? '',
              dob: user?.dob ?? '',
              gender: user?.gender ?? "male",
              city: user?.city ?? '',
              state: user?.state ?? '',
              reference: profileStatus.value?.reference ?? '',
              hobby: profileStatus.value?.userData?.hobby ?? [],
              error: switch (getStatusByResponse(
                response: profileStatus.value!.step3ErrorMessage,
              )) {
                ProfileSetupStatusEnum.pending => "",
                ProfileSetupStatusEnum.completed => "",
                ProfileSetupStatusEnum.error =>
                  profileStatus.value!.step3ErrorMessage,
                ProfileSetupStatusEnum.waiting => "",
              },
            ),
          );
        } else {
          errorSnackBar(context, "Failed to upload image try after some time");
        }
      },
      (r) {
        errorSnackBar(context, r.message ?? "something went wrong");
      },
    );
  }

  Future<void> uploadDetail({
    required BuildContext context,
    required String firstName,
    required String lastName,
    required String gender,
    required String dob,
    required List<String> hobby,
    required String state,
    required String city,
  }) async {
    if (firstName.isEmpty) {
      errorSnackBar(context, "First Name Cannot Be Empty");
      return;
    }
    if (lastName.isEmpty) {
      errorSnackBar(context, "Last Name Cannot Be Empty");
      return;
    }
    if (dob.isEmpty) {
      errorSnackBar(context, "Select Date Of Birth");
      return;
    }
    if (hobby.isEmpty) {
      errorSnackBar(context, "Select Some Hobby");
      return;
    }

    if (hobby.length < 3) {
      errorSnackBar(context, "Add At least 3 Hobby");
      return;
    }
    if (state.isEmpty) {
      errorSnackBar(context, "Select State First");
      return;
    }
    if (city.isEmpty) {
      errorSnackBar(context, "Select City First");
      return;
    }
    isLoading.value = true;
    var response = await repo.submitProfileDetailCall(
      model: ProfileSetupDetailModel(
        firstName: firstName,
        lastName: lastName,
        hobby: [],
        dob: dob,
        gender: gender,
        state: state,
        city: city,
      ),
    );
    isLoading.value = false;
    response.fold(
      (l) {
        if (l) {
          GetStorage().write(StorageKeys.needProfileSetup, false);
          successSnackBar(context, "Profile Detail Uploaded");
          Get.offAll(() => SplashScreen());
        } else {
          errorSnackBar(context, "Failed to upload image try after some time");
        }
      },
      (r) {
        errorSnackBar(context, r.message ?? "something went wrong");
      },
    );
  }

  Future<bool> submitReference(
    BuildContext context,
    String referenceCode,
  ) async {
    if (referenceCode.isEmpty) {
      errorSnackBar(context, "Reference Code Cannot Be Empty");
      return false;
    }
    isLoading.value = true;
    var response = await repo.submitReference(referenceCode);
    isLoading.value = false;
    return response.fold(
      (l) {
        if (l) {
          fetchProfileStatus();
          successSnackBar(context, "Reference Code Submitted");
          return true;
        } else {
          errorSnackBar(
            context,
            "Failed to submit reference try after some time",
          );
          return false;
        }
      },
      (r) {
        errorSnackBar(context, r.message ?? "something went wrong");
        return false;
      },
    );
  }
}
