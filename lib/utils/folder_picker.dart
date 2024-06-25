import 'dart:io';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';

import '../state/interface.dart';

Future<String?> pickFolderPath(String path, context) async {
  String? newPath = await FilesystemPicker.openBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(4.0),
        topRight: Radius.circular(4.0),
      ),
    ),
    rootDirectory: Directory(path),
    fsType: FilesystemType.folder,
    barrierColor: Interface.of(context).palette.background,
    constraints: const BoxConstraints(),
    theme: FilesystemPickerTheme(
      topBar: FilesystemPickerTopBarThemeData(
        backgroundColor: Interface.of(context).palette.background,
        foregroundColor: Interface.of(context).palette.onBackground,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Interface.of(context).palette.primary,
            statusBarIconBrightness: Brightness.dark),
      ),
      backgroundColor: Interface.of(context).palette.background,
      fileList: FilesystemPickerFileListThemeData(
        fileTextStyle: TextStyle(
          fontSize: 16,
          color: Interface.of(context).palette.onBackground,
        ),
        folderTextStyle: TextStyle(
          fontSize: 16,
          color: Interface.of(context).palette.onBackground,
        ),
      ),
      pickerAction: FilesystemPickerActionThemeData(
        backgroundColor: Interface.of(context).palette.primary,
        checkIconColor: Interface.of(context).palette.onPrimary,
      ),
    ),
    pickText: "Select Folder",
    folderIconColor: Interface.of(context).palette.secondary,
  );
  return newPath;
}
