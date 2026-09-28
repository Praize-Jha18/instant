import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Fade + small upward slide, used for pushed detail screens.
Page<T> fadeSlidePage<T>({required LocalKey key, required Widget child, String? name}) =>
    CustomTransitionPage<T>(
      key: key,
      name: name,
      child: child,
      transitionDuration: AppMotion.slow,
      reverseTransitionDuration: AppMotion.normal,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(parent: animation, curve: AppMotion.curve, reverseCurve: AppMotion.curveIn);
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(begin: const Offset(0, 0.04), end: Offset.zero).animate(curved),
            child: child,
          ),
        );
      },
    );

/// Plain cross-fade, used between auth screens.
Page<T> fadePage<T>({required LocalKey key, required Widget child, String? name}) => CustomTransitionPage<T>(
      key: key,
      name: name,
      child: child,
      transitionDuration: AppMotion.normal,
      reverseTransitionDuration: AppMotion.fast,
      transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: AppMotion.curve),
        child: child,
      ),
    );

/// Slides up from the bottom, used for checkout / payment flows.
Page<T> slideUpPage<T>({required LocalKey key, required Widget child, String? name}) => CustomTransitionPage<T>(
      key: key,
      name: name,
      child: child,
      fullscreenDialog: true,
      transitionDuration: AppMotion.slow,
      reverseTransitionDuration: AppMotion.normal,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(parent: animation, curve: AppMotion.emphasized, reverseCurve: AppMotion.curveIn);
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(curved),
          child: child,
        );
      },
    );
