import 'dart:async';
import 'dart:math';

import 'package:dating_user/core/common_widget/custom_elevated_button.dart';
import 'package:dating_user/core/constant/app_text_style.dart';
import 'package:dating_user/core/dependency/dependency.dart';
import 'package:dating_user/features/splash/presentation/splash_screen.dart';
import 'package:floating_draggable_widget/floating_draggable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:logger/logger.dart';

import 'core/constant/app_color.dart';

extension RandomListItem<T> on List<T> {
  T random() {
    final random = Random();
    return this[random.nextInt(length)];
  }
}

void main() {
  runZonedGuarded(
    () async {
      await GetStorage.init();
      await initializeDependency();
      runApp(const MyApp());
    },
    (error, stack) {
      Logger().e(error);
      Logger().e(stack);
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      defaultTransition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: Colors.transparent,
        cardTheme: CardThemeData(elevation: 0.5),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.primaryColor,
            foregroundColor: Colors.white,
            textStyle: AppTextStyle.normalPoppins.copyWith(
              fontSize: 14,
              color: Colors.white,
            ),
            disabledBackgroundColor: Colors.grey,
          ),
        ),
        appBarTheme: AppBarTheme(
          titleTextStyle: AppTextStyle.mediumPoppins.copyWith(
            fontSize: 18,
            color: Colors.white,
          ),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          ),
          centerTitle: true,
        ),
      ),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.noScaling),
          child: child!,
        );
      },
      home: SplashScreen(),
    );
  }
}

class Temp extends StatelessWidget {
  const Temp({super.key});

  @override
  Widget build(BuildContext context) {
    var isToggle = false;
    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: AppBar(
      //   title: Text("App", style: TextStyle(color: Colors.black)),
      //   centerTitle: false,
      //   actions: [
      //     Row(
      //       children: [
      //         StatefulBuilder(
      //           builder: (context, setState) => AnimatedToggleSwitch.dual(
      //             current: isToggle,
      //             first: false,
      //             height: 38,
      //             spacing: 56,
      //             second: true,
      //             indicatorSize: Size(24, 24),
      //             padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      //             onChanged: (value) {
      //               isToggle = !isToggle;
      //               setState(() {});
      //             },
      //             textBuilder: (value) {
      //               return Text(value ? "Online" : "Offline", style: AppTextStyle.mediumPoppins.copyWith(color: Colors.white, fontSize: 16));
      //             },
      //
      //             styleBuilder: (value) {
      //               if (value) {
      //                 return ToggleStyle(backgroundColor: AppColor.primaryColor, indicatorColor: Colors.white);
      //               }
      //               return ToggleStyle(backgroundColor: AppColor.primaryColor, indicatorColor: Colors.grey);
      //             },
      //           ),
      //         ),
      //       ],
      //     ),
      //   ],
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton:
          SizedBox.shrink() ??
          Column(
            mainAxisSize: .min,
            children: [
              Container(
                padding: .all(12),
                decoration: BoxDecoration(
                  borderRadius: .circular(1000),
                  color: Colors.grey.shade100,
                ),
                child: Row(
                  mainAxisSize: .min,
                  spacing: 24,
                  children: [
                    IconButton(
                      icon: Icon(Iconsax.message),
                      onPressed: () {
                        // _showModel();
                      },
                    ),
                    IconButton(onPressed: () {}, icon: Icon(Iconsax.repeat)),
                    IconButton(onPressed: () {}, icon: Icon(Iconsax.gift)),
                  ],
                ),
              ),
            ],
          ),
      body: FloatingDraggableWidget(
        floatingWidget: SizedBox.shrink() ?? Container(color: Colors.red),
        floatingWidgetWidth: 150,
        floatingWidgetHeight: 200,
        dx: 200,
        dy: 300,
        autoAlign: true,
        disableBounceAnimation: true,
        isDraggable: true,
        mainScreenWidget: SafeArea(
          top: true,
          child: Column(
            spacing: 12,
            crossAxisAlignment: .start,
            children: [
              // Padding(padding: .only(left: 24),child: Text("Request Gift", style: AppTextStyle.mediumPoppins.copyWith(fontSize: 18))),
              // Expanded(
              //   child: GridView.builder(
              //     itemCount: 20,
              //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 2 / 1),
              //     itemBuilder: (context, index) {
              //       return Column(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           Icon(
              //             [
              //               Icons.home,
              //               Icons.favorite,
              //               Icons.star,
              //               Icons.settings,
              //               Icons.person,
              //               Icons.camera_alt,
              //               Icons.notifications,
              //               Icons.shopping_cart,
              //               Icons.search,
              //               Icons.phone,
              //               Icons.map,
              //               Icons.lock,
              //               Icons.email,
              //               Icons.music_note,
              //               Icons.flight,
              //               Icons.directions_car,
              //               Icons.wifi,
              //               Icons.thumb_up,
              //               Icons.print,
              //               Icons.alarm,
              //             ].random(),
              //           ),
              //           Text(RandomNames(Zone.india).name()),
              //         ],
              //       );
              //     },
              //   ),
              // ),
              Row(
                children: [
                  CustomElevatedButton(
                    child: Text("Confirm"),
                    onPressed: () {},
                  ),
                ],
              ),

              // Center(
              //   child: SizedBox(
              //     height: Get.size.width / 2,
              //     width: Get.size.width / 2,
              //     child: CircularProgressIndicator(value: 0.9, strokeWidth: 24, strokeCap: StrokeCap.round),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

// var dio = di<Dio>();
// var endPoints = ApiEndpoints.profileImageSetup;
// try{
//
// } on DioException catch (e) {
// Logger().e(e.response?.data["detail"] ?? "Something went wrong");
// return Right(APIError(
// code: e.response?.statusCode ?? 0,
// message: e.response?.data["detail"] ?? "Something went wrong"
// ));
// } catch (e) {
// Logger().e(e.toString());
// return Right(APIError(
// code: 0,
// message: e.toString()
// ));
// }
