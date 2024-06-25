import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:laundromat/state/interface.dart';
import 'package:laundromat/state/state.dart';
import 'package:path_provider/path_provider.dart';
import 'package:remix_icon_icons/remix_icon_icons.dart';

import 'package:laundromat/utils/toast.dart';

enum PathType { laundry, output }

class SelectionPage extends StatefulWidget {
  const SelectionPage({
    super.key,
  });

  @override
  State<SelectionPage> createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {
  selectPath(PathType type) async {
    await directoryGet();
    pathType = type;
  }

  clearDeviceDirectories() {
    deviceDirectories = [];
    deviceDirectoryController.add([]);
  }

  List<String> deviceDirectories = [];
  StreamController<List<String>> deviceDirectoryController =
      StreamController.broadcast();
  PathType? pathType;

  directoryGet() async {
    deviceDirectories = [];
    final List<Directory>? rootList = await getExternalStorageDirectories();
    if (rootList != null) {
      for (Directory place in rootList) {
        deviceDirectories.add(place.path.split("Android")[0]);
      }
      deviceDirectoryController.add(deviceDirectories);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Card(
        color: Interface.of(context).palette.background,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 1,
                child: Card(
                  shadowColor: Interface.of(context).palette.shadow,
                  color: Interface.of(context).palette.primary,
                  child: Center(
                    child: SingleChildScrollView(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 70,
                            child: Image.asset("assets/logo.png"),
                          ),
                          SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Laundromat",
                                  style: TextStyle(
                                      color: Interface.of(context)
                                          .palette
                                          .onPrimary,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                      decorationStyle:
                                          TextDecorationStyle.double,
                                      decorationColor: Interface.of(context)
                                          .palette
                                          .onPrimary,
                                      decorationThickness: 1.5),
                                ),
                                Text(
                                  "Your music laundry done fast.",
                                  style: TextStyle(
                                    color:
                                        Interface.of(context).palette.onPrimary,
                                    fontSize: 12,
                                    decorationColor:
                                        Interface.of(context).palette.onPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (!sortState.queryOngoing) {
                            selectPath(PathType.laundry);
                          }
                        },
                        child: Card(
                          shadowColor: Interface.of(context).palette.shadow,
                          color: Interface.of(context).palette.primary,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    sortState.queryPath != null
                                        ? Text(
                                            "Laundry:\n${sortState.queryPath!}",
                                            style: TextStyle(
                                              color: Interface.of(context)
                                                  .palette
                                                  .onPrimary,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        : Text(
                                            "Select Laundry Directory",
                                            style: TextStyle(
                                              color: Interface.of(context)
                                                  .palette
                                                  .onPrimary,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                    Icon(
                                      RemixIcon.arrow_up,
                                      color: Interface.of(context)
                                          .palette
                                          .onPrimary,
                                      size: 50,
                                    ),
                                    StreamBuilder(
                                      stream: deviceDirectoryController.stream,
                                      builder:
                                          (BuildContext context, snapshot) {
                                        final List<String> dirs =
                                            snapshot.data ?? deviceDirectories;
                                        return dirs.isNotEmpty &&
                                                pathType == PathType.laundry
                                            ? Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  for (String dir in dirs)
                                                    Column(
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () async {
                                                            await sortState
                                                                .setQueryPath(
                                                                    dir,
                                                                    context);
                                                            setState(() {
                                                              clearDeviceDirectories();
                                                            });
                                                          },
                                                          child: Card(
                                                            shadowColor:
                                                                Interface.of(
                                                                        context)
                                                                    .palette
                                                                    .shadow,
                                                            color: Interface.of(
                                                                    context)
                                                                .palette
                                                                .primary,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Text(
                                                                dir,
                                                                style:
                                                                    TextStyle(
                                                                  color: Interface.of(
                                                                          context)
                                                                      .palette
                                                                      .onPrimary,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                      ],
                                                    ),
                                                ],
                                              )
                                            : Container();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (!sortState.queryOngoing) {
                            selectPath(PathType.output);
                          }
                        },
                        child: Card(
                          shadowColor: Interface.of(context).palette.shadow,
                          color: Interface.of(context).palette.secondary,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    sortState.outputPath != null
                                        ? Text(
                                            "Output:\n${sortState.outputPath!}",
                                            style: TextStyle(
                                              color: Interface.of(context)
                                                  .palette
                                                  .onSecondary,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        : Text(
                                            "Select Output Directory",
                                            style: TextStyle(
                                              color: Interface.of(context)
                                                  .palette
                                                  .onSecondary,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                    Icon(
                                      RemixIcon.arrow_down,
                                      color: Interface.of(context)
                                          .palette
                                          .onSecondary,
                                      size: 50,
                                    ),
                                    StreamBuilder(
                                      stream: deviceDirectoryController.stream,
                                      builder:
                                          (BuildContext context, snapshot) {
                                        final List<String> dirs =
                                            snapshot.data ?? deviceDirectories;
                                        return dirs.isNotEmpty &&
                                                pathType == PathType.output
                                            ? Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  for (String dir in dirs)
                                                    Column(
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () async {
                                                            await sortState
                                                                .setOutputPath(
                                                                    dir,
                                                                    context);
                                                            setState(() {
                                                              clearDeviceDirectories();
                                                            });
                                                          },
                                                          child: Card(
                                                            shadowColor:
                                                                Interface.of(
                                                                        context)
                                                                    .palette
                                                                    .shadow,
                                                            color: Interface.of(
                                                                    context)
                                                                .palette
                                                                .secondary,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Text(
                                                                dir,
                                                                style:
                                                                    TextStyle(
                                                                  color: Interface.of(
                                                                          context)
                                                                      .palette
                                                                      .onSecondary,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                      ],
                                                    ),
                                                ],
                                              )
                                            : Container();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "Note:\n- Do not select root storage.\n- Select folders from the same root storage.",
                  style: TextStyle(
                    color: Interface.of(context).palette.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: StreamBuilder<bool>(
                    stream: sortState.queryOngoingStream.stream,
                    builder: (context, snapshot) {
                      final bool queryOngoing =
                          snapshot.data ?? sortState.queryOngoing;
                      return ElevatedButton(
                        onPressed: () {
                          if (!queryOngoing) {
                            clearDeviceDirectories();
                            if (sortState.outputPath == null ||
                                sortState.queryPath == null) {
                              showToast(
                                  "Please select Laundry and Output Directories.");
                            } else {
                              bool permitted = sortState.confirmPermissions();
                              permitted
                                  ? sortState.initQuery()
                                  : showToast(
                                      "Permissions not granted, please grant them in system settings.");
                            }
                          } else {
                            showToast("Process ongoing already...");
                          }
                        },
                        style: ButtonStyle(
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          backgroundColor: WidgetStatePropertyAll(
                              Interface.of(context).palette.secondary),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Preview Albums",
                              style: TextStyle(
                                color:
                                    Interface.of(context).palette.onSecondary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            queryOngoing
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: CircularProgressIndicator(
                                            color: Interface.of(context)
                                                .palette
                                                .onSecondary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Container()
                          ],
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
