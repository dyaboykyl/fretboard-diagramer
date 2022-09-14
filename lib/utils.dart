import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

T matching<T>(T a, T b, T desired) {
  return a == desired ? a : b;
}

T matchingFunc<T, K>(T a, T b, K key, K Function(T) matcher) {
  return matcher(a) == key ? a : b;
}

T matchingPredicate<T, K>(T a, T b, bool predicate) {
  return predicate ? a : b;
}

T nonmatching<T>(T a, T b, T undesired) {
  return a == undesired ? b : a;
}

T nonmatchingFunc<T, K>(T a, T b, K key, K Function(T) matcher) {
  return matcher(a) == key ? b : a;
}

const encoder = JsonEncoder();
String toStringHelper(dynamic object) {
  return (object is Map<dynamic, dynamic>) ? encoder.convert(object) : encoder.convert(object.toJson());
}

Observer observer(Widget Function() widgetBuilder) {
  return Observer(builder: (_) => widgetBuilder());
}

String enumToString(dynamic a) {
  return a.toString().split('.')[1];
}

String capitalize(String text) {
  return '${text[0].toUpperCase()}${text.substring(1)}';
}

String pluralize(int amount, String text) {
  return text + (amount == 1 ? '' : 's');
}

Duration timeUntil(DateTime timeout) {
  final now = DateTime.now();

  if (now.compareTo(timeout) > 0) {
    return Duration.zero;
  }
  return timeout.difference(now);
}

String formatDuration(Duration duration) {
  var unit = '';
  var value = 0;
  final days = duration.inDays;
  final hours = (duration - Duration(days: days)).inHours;
  final minutes = (duration - Duration(days: days) - Duration(hours: hours)).inMinutes;
  final seconds = (duration - Duration(days: days) - Duration(hours: hours) - Duration(minutes: minutes)).inSeconds;

  if (days > 0) {
    unit = 'day';
    value = days;
    if (hours > 12) {
      value += 1;
    }
  } else if (hours > 0) {
    unit = 'hour';
    value = hours;
    if (minutes > 30) {
      value += 1;
    }
  } else if (minutes > 0) {
    unit = 'minute';
    value = minutes;
    if (seconds > 30) {
      value += 1;
    }
  } else if (seconds > 0) {
    unit = 'second';
    value = seconds;
  } else {
    return 'Timed out';
  }

  return '$value ${pluralize(value, unit)}';
}
