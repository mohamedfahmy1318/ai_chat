import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';

class SplashScreen extends StatefulWidget {
	const SplashScreen({super.key});

	@override
	State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
	Timer? _timer;

	@override
	void initState() {
		super.initState();
		_timer = Timer(const Duration(seconds: 2), () {
			if (!mounted) return;
			context.go(AppRouter.conversations);
		});
	}

	@override
	void dispose() {
		_timer?.cancel();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: const Color(0xFF1E88E5),
			body: Center(
				child: Image.asset(
					'assets/images/splash_loog.png',
					width: 160,
					height: 160,
					fit: BoxFit.contain,
				),
			),
		);
	}
}
