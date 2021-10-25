import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vipepeo_app/utils/app_theme.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
//
// Uploading media files
//
import 'package:http_parser/http_parser.dart';

class AppUtils {
  BuildContext _context;
  AppUtils(BuildContext context) {
    _context = context;
  }

  nextPage({@required page}) {
    Navigator.push(_context, MaterialPageRoute(builder: (_) {
      return page;
    }));
  }

  static String convertDateFormat(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  static showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        gravity: ToastGravity.TOP,
        backgroundColor: AppTheme.PrimaryDarkColor);
  }

  static Future<File> getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker
        .getImage(
      source: ImageSource.gallery,
    )
        .catchError((onError) {
      print(onError);
    });
    final file = await FlutterImageCompress.compressAndGetFile(
      pickedFile.path,
      pickedFile.path,
      minHeight: 600,
      minWidth: 800,
      quality: 88,
    );
    // return pickedFile != null ? File(pickedFile.path) : null;
    // return File(pickedFile.path);
    return file;
  }

  static String eventMonth(String formattedDate) {
    var date = DateTime.parse(formattedDate);
    var strMonth = '';
    if (date.month == 1) strMonth = 'JAN';
    if (date.month == 2) strMonth = 'FEB';
    if (date.month == 3) strMonth = 'MAR';
    if (date.month == 4) strMonth = 'APR';
    if (date.month == 5) strMonth = 'MAY';
    if (date.month == 6) strMonth = 'JUN';
    if (date.month == 7) strMonth = 'JUL';
    if (date.month == 8) strMonth = 'AUG';
    if (date.month == 9) strMonth = 'SEP';
    if (date.month == 10) strMonth = 'OCT';
    if (date.month == 11) strMonth = 'NOV';
    if (date.month == 12) strMonth = 'DEC';
    return strMonth;
  }

  static Future<MultipartFile> createMultipartFile(String filepath) async {
    var fileName = filepath.split('/').last;
    var ext = fileName.split(".")[1];
    var futureFile = await MultipartFile.fromFile(filepath,
        filename: fileName, contentType: MediaType('image', '$ext'));
    return futureFile;
  }

  static Future<String> cachedFilePath(String imageUrl) async {
    var cache = DefaultCacheManager();
    final file = await cache.getSingleFile(imageUrl);
    // await cache.emptyCache();
    print('CachedFile: ${file.path}');
    return file.path;
  }
}
