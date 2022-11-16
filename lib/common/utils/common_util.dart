import 'package:flutter/material.dart';
import 'dart:math';

import 'object_util.dart';

class CommonUtils {
  static String getImageByName(String imageName) {
    return 'assets/images/$imageName';
  }

  static String getIconByName(String iconName) {
    return 'assets/icons/$iconName';
  }

  //转为rpx
  static double toRpx(BuildContext context, double size) {
    double rpx = MediaQuery.of(context).size.width / 750;
    return size * rpx;
  }

  static formatCharCount(int? count) {
    if (count == null || count <= 0 || count.isNaN) return "0";
    String countStr = count.toString();
    if (countStr.length >= 5) {
      String prefix = countStr.substring(0, countStr.length - 4);
      if (countStr.length == 5) {
        prefix += '.${countStr[1]}';
      }
      if (countStr.length == 6) {
        prefix += '.${countStr[2]}';
      }

      return "${prefix}w";
    }
    return countStr;
  }

  static int getRandomRangeInt(int min, int max) {
    final Random random = Random();
    return min + random.nextInt(max + 1 - min);
  }

  //将String转为集合
  static List<String> string2List(String data, String regex, String server) {
    List<String> dataList = [];
    if (!ObjectUtil.isEmptyString(data)) {
      List<String> split = data.split(regex);
      for (int i = 0; i < split.length; i++) {
        if (!ObjectUtil.isEmptyString(split[i])) {
          dataList.add(server + split[i]);
        }
      }
    }
    return dataList;
  }

  //将集合转为String
  static String list2String(List<String> dataList, String regex) {
    if (ObjectUtil.isEmptyList(dataList)) {
      return "";
    }
    String builder = "";

    for (int i = 0; i < dataList.length; i++) {
      if (i != 0) {
        builder += regex;
      }
      builder += dataList[i];
    }
    return builder.toString();
  }

  static String getURLDecoderString(String str) {
    return Uri.decodeComponent(str);
  }

  static bool isChinaPhoneLegal(String phone) {
    RegExp exp = RegExp(r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
    bool matched = exp.hasMatch(phone);
    return matched;
  }

  static String dealPhoneNumber(String phoneNumber) {
    if (!ObjectUtil.isEmptyString(phoneNumber)) {
      int len = phoneNumber.length;
      String builder = "";
      for (int i = 0; i < len; i++) {
        if (i > 2 && i < 7) {
          builder += "*";
        } else {
          builder += phoneNumber[i];
        }
      }
      return builder.toString();
    }
    return "";
  }
}
