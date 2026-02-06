package com.tjxtm.tmstransport;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;

import androidx.annotation.NonNull;

import java.util.HashMap;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

    private static final String FlutterChannel = "connectNativeChannel";
    MethodChannel commonNativeChannel;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
    }

    private void setShareMethodCallHandler(String id) {
        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                commonNativeChannel.invokeMethod("nativeCallFlutterToShareReserve", id);
            }
        }, 1000);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Intent intent = getIntent();
        String msg = intent.getStringExtra("pushMessageParams");
        if (msg != null) {
            HashMap<String, Object> map = new HashMap<>();
            map.put("msg", msg);
            new Handler().postDelayed(new Runnable() {
                @Override
                public void run() {
                }
            }, 1000);
        }
        toSharePage(intent);
    }

    @Override
    protected void onNewIntent(@NonNull Intent intent) {
        super.onNewIntent(intent);
        String msg = intent.getStringExtra("pushMessageParams");
        if (msg != null) {
            HashMap<String, Object> map = new HashMap<>();
            map.put("msg", msg);
            new Handler().postDelayed(new Runnable() {
                @Override
                public void run() {
                }
            }, 1000);
        }
        toSharePage(intent);
    }

    private void toSharePage(Intent intent) {
        String dataString = intent.getDataString();
        if (dataString != null && dataString.contains("xiaotiema://")) {
            Uri uri = intent.getData();
            String id = uri.getQueryParameter("id");
            setShareMethodCallHandler(id);
        }
    }

}
