import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rtinnovations_task/utils/extensions/responsive_exs.dart';

import '../../../../core/l10n/app_strings.dart';
import '../../../../core/themes/typography/app_typography.dart';
import '../../../../utils/assets.dart';

class EmptyRecords extends StatelessWidget {
  const EmptyRecords({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          AppAssets.svg.emptyRecords,
          fit: BoxFit.scaleDown,
        ),
        SizedBox(
          height: 4.h,
        ),
        Text(
          AppStrings.ofUntranslated(context).emptyRecords,
          style: AppTypography.h5.apply(
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
