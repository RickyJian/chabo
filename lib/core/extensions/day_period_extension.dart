import 'package:flutter/material.dart';
import 'package:chabo/l10n/app_localizations.dart';

extension DayPeriodExtension on DayPeriod {
  String localize(BuildContext context) {
    switch (this) {
      case DayPeriod.am:
        return AppLocalizations.of(context)!.dayPeriodAM;
      case DayPeriod.pm:
        return AppLocalizations.of(context)!.dayPeriodPM;
    }
  }
}
