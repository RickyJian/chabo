import 'package:chabo/core/enums/weekday.dart';
import 'package:chabo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

extension WeekdayExtension on Weekday {
  String localize(BuildContext context) {
    switch (this) {
      case Weekday.sunday:
        return AppLocalizations.of(context)!.weekdaySUN;
      case Weekday.monday:
        return AppLocalizations.of(context)!.weekdayMON;
      case Weekday.tuesday:
        return AppLocalizations.of(context)!.weekdayTUE;
      case Weekday.wednesday:
        return AppLocalizations.of(context)!.weekdayWED;
      case Weekday.thursday:
        return AppLocalizations.of(context)!.weekdayTHU;
      case Weekday.friday:
        return AppLocalizations.of(context)!.weekdayFRI;
      case Weekday.saturday:
        return AppLocalizations.of(context)!.weekdaySAT;
    }
  }
}
