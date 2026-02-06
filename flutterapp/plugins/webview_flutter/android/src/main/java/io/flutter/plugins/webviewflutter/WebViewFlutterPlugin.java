// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.plugins.webviewflutter;

import android.app.Activity;
import android.content.Context;
import android.net.Uri;
import android.webkit.ValueCallback;

import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.platform.PlatformViewRegistry;
import io.flutter.view.FlutterView;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;

/**
 * Java platform implementation of the webview_flutter plugin.
 *
 * <p>Register this in an add to app scenario to gracefully handle activity and context changes.
 *
 * <p>Call {@link #registerWith(Registrar)} to use the stable {@code io.flutter.plugin.common}
 * package instead.
 */
public class WebViewFlutterPlugin implements FlutterPlugin, ActivityAware {

  private FlutterCookieManager flutterCookieManager;
  // fixme: 以下自己加入
  public PluginRegistry.Registrar registrar;

  public static ValueCallback<Uri> filePathCallbackLegacy;
  public static ValueCallback<Uri[]> filePathCallback;

  public ActivityPluginBinding activityPluginBinding;
  public Activity activity;

  /**
   * Add an instance of this to {@link io.flutter.embedding.engine.plugins.PluginRegistry} to
   * register it.
   *
   * <p>THIS PLUGIN CODE PATH DEPENDS ON A NEWER VERSION OF FLUTTER THAN THE ONE DEFINED IN THE
   * PUBSPEC.YAML. Text input will fail on some Android devices unless this is used with at least
   * flutter/flutter@1d4d63ace1f801a022ea9ec737bf8c15395588b9. Use the V1 embedding with {@link
   * #registerWith(Registrar)} to use this plugin with older Flutter versions.
   *
   * <p>Registration should eventually be handled automatically by v2 of the
   * GeneratedPluginRegistrant. https://github.com/flutter/flutter/issues/42694
   */
  public WebViewFlutterPlugin() {}

  /**
   * Registers a plugin implementation that uses the stable {@code io.flutter.plugin.common}
   * package.
   *
   * <p>Calling this automatically initializes the plugin. However plugins initialized this way
   * won't react to changes in activity or context, unlike {@link CameraPlugin}.
   */
  @SuppressWarnings("deprecation")
  public static void registerWith(io.flutter.plugin.common.PluginRegistry.Registrar registrar) {
    registrar
        .platformViewRegistry()
        .registerViewFactory(
            "plugins.flutter.io/webview",
            new FlutterWebViewFactory(registrar.messenger(), registrar.view(), new WebViewFlutterPlugin()));
    new FlutterCookieManager(registrar.messenger());

//    final WebViewFlutterPlugin instance = new WebViewFlutterPlugin();
//    instance.registrar = registrar;
//    instance.onAttachedToEngine(
//            registrar.context(), registrar.messenger(), registrar.activity(), registrar.platformViewRegistry(), registrar.view());
//    new FlutterCookieManager(registrar.messenger());
  }

  @Override
  public void onAttachedToEngine(FlutterPluginBinding binding) {
    BinaryMessenger messenger = binding.getBinaryMessenger();
    binding
        .getPlatformViewRegistry()
        .registerViewFactory(
            "plugins.flutter.io/webview",
            new FlutterWebViewFactory(messenger, /*containerView=*/ null, this));
    flutterCookieManager = new FlutterCookieManager(messenger);
  }

//  private void onAttachedToEngine(Context applicationContext, BinaryMessenger messenger, Activity activity, PlatformViewRegistry platformViewRegistry, FlutterView flutterView) {
//    this.applicationContext = applicationContext;
//    this.activity = activity;
//    this.messenger = messenger;
//    this.flutterView = flutterView;
//
//    flutterWebViewFactory = new FlutterWebViewFactory(messenger, flutterView, this);
//    platformViewRegistry.registerViewFactory(
//            "plugins.flutter.io/webview", flutterWebViewFactory);
//  }

  @Override
  public void onDetachedFromEngine(FlutterPluginBinding binding) {
    if (flutterCookieManager == null) {
      return;
    }

    flutterCookieManager.dispose();
    flutterCookieManager = null;

    filePathCallbackLegacy = null;
    filePathCallback = null;
  }

  @Override
  public void onAttachedToActivity(ActivityPluginBinding activityPluginBinding) {
    this.activityPluginBinding = activityPluginBinding;
    this.activity = activityPluginBinding.getActivity();
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    this.activityPluginBinding = null;
    this.activity = null;
  }

  @Override
  public void onReattachedToActivityForConfigChanges(ActivityPluginBinding activityPluginBinding) {
    this.activityPluginBinding = activityPluginBinding;
    this.activity = activityPluginBinding.getActivity();
  }

  @Override
  public void onDetachedFromActivity() {
    this.activityPluginBinding = null;
    this.activity = null;
  }
}
