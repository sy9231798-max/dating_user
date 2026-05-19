import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../../core/constant/app_text_style.dart';
import '../../../../../core/enums/profile_setup_status.dart';

class ProfileSetupCard extends StatelessWidget {
  const ProfileSetupCard({
    super.key,
    required this.index,
    required this.cardName,
    required this.profileStatus,
    this.onTap,
    this.error,
  });

  final int index;
  final String cardName;
  final ProfileSetupStatusEnum profileStatus;
  final Function()? onTap;
  final String? error;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: Colors.white,
        elevation: 0.5,
        child: Padding(
          padding: .symmetric(horizontal: 12, vertical: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 12,
                children: [
                  Text(
                    index.toString(),
                    style: AppTextStyle.mediumPoppins.copyWith(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    cardName,
                    style: AppTextStyle.normalPoppins.copyWith(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),

              switch (profileStatus) {
                ProfileSetupStatusEnum.pending => Icon(
                  Iconsax.timer,
                  color: Colors.grey,
                ),
                ProfileSetupStatusEnum.waiting => Icon(
                  Iconsax.clock,
                  color: Colors.orange,
                ),
                ProfileSetupStatusEnum.completed => Icon(
                  Iconsax.tick_circle,
                  color: Colors.green,
                ),
                ProfileSetupStatusEnum.error => Icon(
                  Iconsax.warning_2,
                  color: Colors.red,
                ),
              },
            ],
          ),
        ),
      ),
    );
  }
}
