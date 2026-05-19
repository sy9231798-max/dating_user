import 'package:country_state_city/models/city.dart' as cityPackage;
import 'package:country_state_city/models/state.dart' as statePackage;
import 'package:country_state_city/utils/city_utils.dart';
import 'package:dating_user/core/common_widget/custom_elevated_button.dart';
import 'package:dating_user/core/constant/app_text_style.dart';
import 'package:dating_user/core/helper/helper.dart';
import 'package:dating_user/features/authentication/controller/profile_setup/profile_setup_controller.dart';
import 'package:dating_user/features/authentication/presentation/profile_setup/profile_upload_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import '../../../../core/common_widget/custom_text_field.dart';

class LoginProfileDetailScreen extends StatefulWidget {
  const LoginProfileDetailScreen({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.dob,
    required this.gender,
    required this.city,
    required this.state,
    required this.reference,
    required this.hobby,
    required this.error,
  });

  final String firstName,
      lastName,
      email,
      dob,
      gender,
      city,
      state,
      reference,
      error;
  final List<String> hobby;

  @override
  State<LoginProfileDetailScreen> createState() =>
      _LoginProfileDetailScreenState();
}

class _LoginProfileDetailScreenState extends State<LoginProfileDetailScreen> {
  final controller = Get.find<ProfileSetupController>();

  late RxString firstName = RxString(widget.firstName);
  late RxString lastName = RxString(widget.lastName);
  late RxString email = RxString(widget.email);
  late RxString dob = RxString(widget.dob);
  late RxString gender = RxString(widget.gender);
  late Rxn<statePackage.State> state;
  late Rxn<cityPackage.City> city;
  late RxString reference = RxString(widget.reference);
  late RxList<String> hobby = RxList(widget.hobby);

   final dobController = TextEditingController();

  RxBool get submitted =>
      (firstName.value != widget.firstName ||
              lastName.value != widget.lastName ||
              email.value != widget.email ||
              dob.value != widget.dob ||
              gender.value != widget.gender ||
              (state.value?.name ?? "").toLowerCase() !=
                  widget.state.toLowerCase() ||
              (city.value?.name ?? "").toLowerCase() !=
                  widget.city.toLowerCase() ||
              !AppHelper.isListEqual(widget.hobby, hobby.toList()))
          .obs;

  late RxBool isReferenceDone = RxBool(widget.reference.isNotEmpty);

  final hobbyController = TextEditingController();

  @override
  void initState() {
    state = Rxn(
      controller.state
          .where(
            (e) =>
                e.name.trim().toLowerCase() ==
                (widget.state ?? '').trim().toLowerCase(),
          )
          .cast<statePackage.State?>()
          .firstOrNull,
    );
    city = Rxn(
      controller.city
          .where(
            (e) =>
                e.name.trim().toLowerCase() ==
                (widget.city ?? '').trim().toLowerCase(),
          )
          .cast<cityPackage.City?>()
          .firstOrNull,
    );
    super.initState();
  }

  @override
  void dispose() {
    dobController.dispose();
    hobbyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ImageBackgroundContainer(
      child: Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
          title: Text(
            "Profile Details",
            style: AppTextStyle.mediumPoppins.copyWith(fontSize: 18),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 12),
          child: Column(
            spacing: 12,
            children: [
              Row(
                spacing: 12,
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: TextEditingController(text: firstName.value),
                      label: "First Name",
                      onChanged: (value) {
                        firstName.value = value;
                      },
                      prefixIcon: Icon(Iconsax.user, size: 16),
                    ),
                  ),
                  Expanded(
                    child: CustomTextField(
                      controller: TextEditingController(text: lastName.value),
                      label: "Last Name",
                      onChanged: (value) {
                        lastName.value = value;
                      },
                      prefixIcon: Icon(Iconsax.user, size: 16),
                    ),
                  ),
                ],
              ),
              CustomTextField(
                label: "DOB",
                readOnly: true,
                controller: dobController,
                hint: "Date Of Birth",
                onTap: () async {
                  await DatePicker.showDatePicker(
                    context,
                    showTitleActions: true,
                    minTime: DateTime(1990, 3, 5),
                    maxTime: DateTime(DateTime.now().year - 10),
                    onChanged: (date) {},
                    onConfirm: (date) {
                      dob.value = date.toIso8601String();
                      dobController.text = DateFormat(
                        "dd/MM/yy",
                      ).format(DateTime.tryParse(dob.value) ?? DateTime.now());
                    },
                    currentTime: DateTime.tryParse(dob.value) ?? DateTime.now(),
                  );
                },
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 6,
                children: [
                  Text(
                    "Gender",
                    style: AppTextStyle.normalPoppins.copyWith(fontSize: 14),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Color(0xffF3EEFF),
                      borderRadius: .circular(12),
                    ),
                    child: Padding(
                      padding: .symmetric(horizontal: 12),
                      child: Obx(
                        () => RadioGroup<bool>(
                          groupValue: gender.value == "male",
                          onChanged: (bool? value) {
                            if (value == null) return;

                            gender.value = value ? "male" : "female";
                          },
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Row(
                                  children: [
                                    Text(
                                      "Male",
                                      style: AppTextStyle.normalPoppins
                                          .copyWith(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                    ),
                                    Radio<bool>(value: true),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    Text(
                                      "Female",
                                      style: AppTextStyle.normalPoppins
                                          .copyWith(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                    ),
                                    Radio<bool>(value: false),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: .start,
                children: [
                  Row(
                    crossAxisAlignment: .end,
                    spacing: 12,
                    children: [
                      Expanded(
                        child: CustomTextField(
                          label: "Hobby",
                          hint: "Enter Hobby And Press Add",
                          controller: hobbyController,
                        ),
                      ),
                      CustomElevatedButton(
                        child: Text("Add"),
                        onPressed: () {
                          if (hobbyController.text.trim().isEmpty) return;
                          hobby.add(hobbyController.text.trim());
                          hobbyController.clear();
                        },
                      ),
                    ],
                  ),
                  Obx(
                    () => Wrap(
                      spacing: 12,
                      crossAxisAlignment: .start,
                      children: List.generate(hobby.length, (index) {
                        return Chip(
                          label: Text(hobby[index]),
                          onDeleted: () {
                            hobby.removeAt(index);
                          },
                        );
                      }),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: .start,
                spacing: 6,
                children: [
                  Text(
                    "State",
                    style: AppTextStyle.normalPoppins.copyWith(fontSize: 14),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xffD7D7D7)),
                      // color: Colors.white,
                      color: Color(0xffF3EEFF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Obx(
                      () => DropdownButton(
                        value: state.value,
                        hint: Text(
                          "Please Select State",
                          style: AppTextStyle.normalPoppins.copyWith(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        style: AppTextStyle.normalPoppins.copyWith(
                          fontSize: 14,
                        ),
                        underline: SizedBox.shrink(),
                        isExpanded: true,
                        items: List.generate(controller.state.length, (index) {
                          return DropdownMenuItem(
                            value: controller.state[index],
                            child: Text(
                              controller.state[index].name,
                              style: AppTextStyle.normalPoppins.copyWith(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          );
                        }),

                        onTap: () {},
                        onChanged: (value) async {
                          if (value != null) {
                            state.value = value;
                            city.value = null;
                            controller.city.clear();
                            controller.city.addAll(
                              await getStateCities("IN", value.isoCode),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: .start,
                spacing: 6,
                children: [
                  Text(
                    "City",
                    style: AppTextStyle.normalPoppins.copyWith(fontSize: 14),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xffD7D7D7)),
                      // color: Colors.white,
                      color: Color(0xffF3EEFF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Obx(
                      () => DropdownButton(
                        value: city.value,
                        hint: Text(
                          "Please Select City",
                          style: AppTextStyle.normalPoppins.copyWith(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        style: AppTextStyle.normalPoppins.copyWith(
                          fontSize: 14,
                        ),
                        underline: SizedBox.shrink(),
                        isExpanded: true,
                        items: List.generate(controller.city.length, (index) {
                          return DropdownMenuItem(
                            value: controller.city[index],
                            child: Text(
                              controller.city[index].name,
                              style: AppTextStyle.normalPoppins.copyWith(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          );
                        }),

                        onTap: () {},
                        onChanged: (value) async {
                          if (value != null) {
                            city.value = value;
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),

              if (widget.error.isNotEmpty)
                Text(
                  widget.error,
                  style: AppTextStyle.mediumPoppins.copyWith(fontSize: 18),
                ),
              Obx(
                () => submitted.value
                    ? CustomElevatedButton(
                        child: Row(
                          spacing: 12,
                          mainAxisSize: .min,
                          children: [
                            Text(
                              "Submit",
                              style: AppTextStyle.normalPoppins.copyWith(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            Icon(Iconsax.send_1, color: Colors.white),
                          ],
                        ),
                        onPressed: () {
                          controller.uploadDetail(
                            context: context,
                            firstName: firstName.value,
                            lastName: lastName.value,
                            hobby: hobby.toList(),
                            gender: gender.value,
                            dob: dob.value,
                            state: state.value?.name ?? "",
                            city: city.value?.name ?? "",
                          );
                        },
                      )
                    : SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
