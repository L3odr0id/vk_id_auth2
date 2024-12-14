import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:vk_id_auth2/entity/entity.dart';
import 'package:vk_id_auth2/vk_id_auth.dart';

void main() => runApp(const App());

@immutable
class App extends StatefulWidget {
  const App({
    Key? key,
  }) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  VkIdAuthData? data;
  late final VkIdAuth _vkIdAuth;

  @override
  void initState() {
    super.initState();
    _vkIdAuth = const VkIdAuth();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.system,
        home: FutureBuilder(
          future: _initialize(),
          builder: (context, snapshot) {
            late final Widget child;

            if (snapshot.connectionState != ConnectionState.done) {
              child = const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              child = VkIdAuthPage(
                data: data,
                loginCallback: _login,
              );
            }

            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: child,
            );
          },
        ),
      );

  Future<void> _initialize() async {
    try {
      final isInitialized = await _vkIdAuth.isInitialized;
      if (!isInitialized) {
        await _vkIdAuth.initialize();
      }
    } on Object catch (error, stackTrace) {
      log(
        'Error: $error. StackTrace: $stackTrace.',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<void> _login() async {
    try {
      final isInitialized = await _vkIdAuth.isInitialized;
      if (!isInitialized) {
        throw Error.throwWithStackTrace(
          FlutterError(
              'VkIdAuth login method was called before initialization'),
          StackTrace.current,
        );
      }
      data = await _vkIdAuth.login();
      setState(() {});
    } on Object catch (error, stackTrace) {
      log(
        'Error: $error. StackTrace: $stackTrace.',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}

@immutable
class VkIdAuthPage extends StatelessWidget {
  final VkIdAuthData? data;
  final VoidCallback loginCallback;

  const VkIdAuthPage({
    required this.data,
    required this.loginCallback,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('VK ID Auth'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'Token: ${data?.token}',
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: ElevatedButton(
                  onPressed: loginCallback,
                  child: const Text('Login with VK ID'),
                ),
              ),
            ],
          ),
        ),
      );
}
