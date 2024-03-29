import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import './constants.dart';
import './control_views/default/default.dart';
import './superplayer_controller.dart';

class _SuperPlayerNativeView extends StatelessWidget {
  final SuperPlayerController controller;
  final VoidCallback? onViewCreated;

  _SuperPlayerNativeView({
    Key? key,
    required this.controller,
    this.onViewCreated,
  }) : super(key: key);

  void _onPlatformViewCreated(int viewId) {
    controller.initWithViewId(viewId);

    if (onViewCreated != null) onViewCreated!();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> creationParams = {};

    if (Platform.isAndroid) {
      return AndroidView(
        viewType: kSuperPlayerViewViewType,
        onPlatformViewCreated: _onPlatformViewCreated,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else if (Platform.isIOS) {
      return UiKitView(
        viewType: kSuperPlayerViewViewType,
        onPlatformViewCreated: _onPlatformViewCreated,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      );
    }
    return Container();
  }
}

class SuperPlayerView extends StatelessWidget {
  final SuperPlayerController controller;
  final Widget? controlView;
  final VoidCallback? onViewCreated;

  SuperPlayerView({
    Key? key,
    required this.controller,
    this.controlView,
    this.onViewCreated,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          _SuperPlayerNativeView(
            controller: controller,
            onViewCreated: onViewCreated,
          ),
          controlView ??
              SuperPlayerDefaultControlView(
                controller: controller,
              ),
        ],
      ),
    );
  }
}
