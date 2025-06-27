import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A Riverpod-compatible StatefulWidget alternative that avoids naming conflicts
abstract class CustomConsumerStatefulWidget extends StatefulWidget {
  const CustomConsumerStatefulWidget({super.key});

  @override
  CustomConsumerState createCustomState();
}

/// The base State class for [CustomConsumerStatefulWidget]
abstract class CustomConsumerState<T extends CustomConsumerStatefulWidget> 
    extends State<T> {
  late final Ref _ref;

  Ref get ref => _ref;

  @override
  @mustCallSuper
  void initState() {
    super.initState();
    _ref = ProviderScope.containerOf(context) as Ref<Object?>;
    onInit();
  }

  /// Initialization method with access to Riverpod's ref
  @protected
  void onInit() {}

  @override
  @mustCallSuper
  void dispose() {
    onDispose();
    super.dispose();
  }

  /// Cleanup method
  @protected
  void onDispose() {}

  @override
  Widget build(BuildContext context);
}