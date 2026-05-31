import 'package:intl/intl.dart';

NumberFormat formattedNumber = NumberFormat("#,###", "en_US");

extension MoneyEx on num{
  String get toMoney => (formattedNumber.format(this)).replaceAll(",", ".");
}