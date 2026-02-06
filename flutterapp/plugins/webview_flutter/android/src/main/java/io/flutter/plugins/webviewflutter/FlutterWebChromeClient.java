package io.flutter.plugins.webviewflutter;

import android.Manifest;
import android.annotation.TargetApi;
import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.res.AssetFileDescriptor;
import android.net.Uri;
import android.os.Build;
import android.os.Environment;
import android.os.Message;
import android.os.Parcelable;
import android.provider.MediaStore;
import android.util.Log;
import android.view.ViewGroup;
import android.webkit.MimeTypeMap;
import android.webkit.PermissionRequest;
import android.webkit.ValueCallback;
import android.webkit.WebChromeClient;
import android.webkit.WebResourceRequest;
import android.webkit.WebView;
import android.webkit.WebViewClient;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import androidx.core.content.ContextCompat;
import androidx.core.content.FileProvider;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

import static android.app.Activity.RESULT_OK;

// import android.webkit.GeolocationPermissions;

public class FlutterWebChromeClient extends WebChromeClient implements PluginRegistry.ActivityResultListener{

    private final static String LOG_TAG = "zzb_webview";

    private final FlutterWebViewClient flutterWebViewClient;

    private final FlutterWebView flutterWebView;

    @Nullable
    public WebViewFlutterPlugin plugin;

    private final MethodChannel channel;


    /***** 以下是类内容*****/
    private static final int PICKER = 1;
    private static final int PICKER_LEGACY = 3;
    final String DEFAULT_MIME_TYPES = "*/*";
    private static final String fileProviderAuthorityExtension = "fileProvider.install";
    private static Uri videoOutputFileUri;
    private static Uri imageOutputFileUri;

    public FlutterWebChromeClient(FlutterWebViewClient flutterWebViewClient, FlutterWebView flutterWebView, @Nullable WebViewFlutterPlugin plugin, MethodChannel methodChannel) {
        this.flutterWebViewClient = flutterWebViewClient;
        this.flutterWebView = flutterWebView;
        this.plugin = plugin;
        this.channel = methodChannel;

        // 注意加入监听回调
        if (plugin.registrar != null){
            plugin.registrar.addActivityResultListener(this);
        } else{
            plugin.activityPluginBinding.addActivityResultListener(this);
        }

    }

    @Override
    public boolean onCreateWindow(
            final WebView view, boolean isDialog, boolean isUserGesture, Message resultMsg) {
        final WebViewClient webViewClient =
                new WebViewClient() {
                    @TargetApi(Build.VERSION_CODES.LOLLIPOP)
                    @Override
                    public boolean shouldOverrideUrlLoading(
                            @NonNull WebView view, @NonNull WebResourceRequest request) {
                        final String url = request.getUrl().toString();
                        if (!flutterWebViewClient.shouldOverrideUrlLoading(
                                flutterWebView.webView, request)) {
                            flutterWebView.webView.loadUrl(url);
                        }
                        return true;
                    }

                    @Override
                    public boolean shouldOverrideUrlLoading(WebView view, String url) {
                        if (!flutterWebViewClient.shouldOverrideUrlLoading(
                                flutterWebView.webView, url)) {
                            flutterWebView.webView.loadUrl(url);
                        }
                        return true;
                    }
                };

        final WebView newWebView = new WebView(view.getContext());
        newWebView.setWebViewClient(webViewClient);

        final WebView.WebViewTransport transport = (WebView.WebViewTransport) resultMsg.obj;
        transport.setWebView(newWebView);
        resultMsg.sendToTarget();

        return true;
    }

    @Override
    public void onProgressChanged(WebView view, int progress) {
        flutterWebViewClient.onLoadingProgress(progress);
    }

    // fixme: 加入
    @TargetApi(Build.VERSION_CODES.LOLLIPOP)
    @Override
    public boolean onShowFileChooser(WebView webView, ValueCallback<Uri[]> filePathCallback, FileChooserParams fileChooserParams) {
        String[] acceptTypes = fileChooserParams.getAcceptTypes();
        boolean allowMultiple = fileChooserParams.getMode() == WebChromeClient.FileChooserParams.MODE_OPEN_MULTIPLE;
        Intent intent = fileChooserParams.createIntent();
        Log.i("zzb", "请求图片");
        return startPhotoPickerIntent(filePathCallback, intent, acceptTypes, allowMultiple);
    }

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
        Log.i("zzb", "获取结果 results " + data);
        if (WebViewFlutterPlugin.filePathCallback == null && WebViewFlutterPlugin.filePathCallbackLegacy == null) {
            return true;
        }

        // based off of which button was pressed, we get an activity result and a file
        // the camera activity doesn't properly return the filename* (I think?) so we use
        // this filename instead
        switch (requestCode) {
            case PICKER:
                Uri[] results = null;
                if (resultCode == RESULT_OK) {
                    results = getSelectedFiles(data, resultCode);
                }


                if (WebViewFlutterPlugin.filePathCallback != null) {
                    WebViewFlutterPlugin.filePathCallback.onReceiveValue(results);
                }
                break;

            case PICKER_LEGACY:
                Uri result = null;
                if (resultCode == RESULT_OK) {
                    result = data != null ? data.getData() : getCapturedMediaFile();
                }

                WebViewFlutterPlugin.filePathCallbackLegacy.onReceiveValue(result);
                break;
        }

        WebViewFlutterPlugin.filePathCallback = null;
        WebViewFlutterPlugin.filePathCallbackLegacy = null;
        imageOutputFileUri = null;
        videoOutputFileUri = null;

        return true;
    }

    private Uri[] getSelectedFiles(Intent data, int resultCode) {
        // we have one file selected
        if (data != null && data.getData() != null) {
            if (resultCode == RESULT_OK && Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                return WebChromeClient.FileChooserParams.parseResult(resultCode, data);
            } else {
                return null;
            }
        }

        // we have multiple files selected
        if (data != null && data.getClipData() != null) {
            final int numSelectedFiles = data.getClipData().getItemCount();
            Uri[] result = new Uri[numSelectedFiles];
            for (int i = 0; i < numSelectedFiles; i++) {
                result[i] = data.getClipData().getItemAt(i).getUri();
            }
            return result;
        }

        // we have a captured image or video file
        Uri mediaUri = getCapturedMediaFile();
        if (mediaUri != null) {
            return new Uri[]{mediaUri};
        }

        return null;
    }

    private boolean isFileNotEmpty(Uri uri) {
        Activity activity = plugin.activity;

        long length;
        try {
            AssetFileDescriptor descriptor = activity.getContentResolver().openAssetFileDescriptor(uri, "r");
            length = descriptor.getLength();
            descriptor.close();
        } catch (IOException e) {
            return false;
        }

        return length > 0;
    }

    private Uri getCapturedMediaFile() {
        if (imageOutputFileUri != null && isFileNotEmpty(imageOutputFileUri)) {
            return imageOutputFileUri;
        }

        if (videoOutputFileUri != null && isFileNotEmpty(videoOutputFileUri)) {
            return videoOutputFileUri;
        }

        return null;
    }

//    protected ViewGroup getRootView() {
//        Activity activity = inAppBrowserDelegate != null ? inAppBrowserDelegate.getActivity() : plugin.activity;
//        return (ViewGroup) activity.findViewById(android.R.id.content);
//    }

    protected void openFileChooser(ValueCallback<Uri> filePathCallback, String acceptType) {
        startPhotoPickerIntent(filePathCallback, acceptType);
    }

    protected void openFileChooser(ValueCallback<Uri> filePathCallback) {
        startPhotoPickerIntent(filePathCallback, "");
    }

    protected void openFileChooser(ValueCallback<Uri> filePathCallback, String acceptType, String capture) {
        startPhotoPickerIntent(filePathCallback, acceptType);
    }

    public void startPhotoPickerIntent(ValueCallback<Uri> filePathCallback, String acceptType) {
        WebViewFlutterPlugin.filePathCallbackLegacy = filePathCallback;

        Intent fileChooserIntent = getFileChooserIntent(acceptType);
        Intent chooserIntent = Intent.createChooser(fileChooserIntent, "");

        ArrayList<Parcelable> extraIntents = new ArrayList<>();
        if (acceptsImages(acceptType)) {
            extraIntents.add(getPhotoIntent());
        }
        if (acceptsVideo(acceptType)) {
            extraIntents.add(getVideoIntent());
        }
        chooserIntent.putExtra(Intent.EXTRA_INITIAL_INTENTS, extraIntents.toArray(new Parcelable[]{}));

        Activity activity = plugin.activity;
        if (chooserIntent.resolveActivity(activity.getPackageManager()) != null) {
            activity.startActivityForResult(chooserIntent, PICKER_LEGACY);
        } else {
            Log.d(LOG_TAG, "there is no Activity to handle this Intent");
        }
    }

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    public boolean startPhotoPickerIntent(final ValueCallback<Uri[]> callback, final Intent intent, final String[] acceptTypes, final boolean allowMultiple) {
        WebViewFlutterPlugin.filePathCallback = callback;

        ArrayList<Parcelable> extraIntents = new ArrayList<>();
        if (!needsCameraPermission()) {
            if (acceptsImages(acceptTypes)) {
                extraIntents.add(getPhotoIntent());
            }
            if (acceptsVideo(acceptTypes)) {
                extraIntents.add(getVideoIntent());
            }
        }

        Intent fileSelectionIntent = getFileChooserIntent(acceptTypes, allowMultiple);

        Intent chooserIntent = new Intent(Intent.ACTION_CHOOSER);
        chooserIntent.putExtra(Intent.EXTRA_INTENT, fileSelectionIntent);
        chooserIntent.putExtra(Intent.EXTRA_INITIAL_INTENTS, extraIntents.toArray(new Parcelable[]{}));

        Activity activity = plugin.activity;
        if (chooserIntent.resolveActivity(activity.getPackageManager()) != null) {
            activity.startActivityForResult(chooserIntent, PICKER);
        } else {
            Log.d(LOG_TAG, "there is no Activity to handle this Intent");
        }

        return true;
    }

    protected boolean needsCameraPermission() {
        boolean needed = false;

        Activity activity = plugin.activity;
        PackageManager packageManager = activity.getPackageManager();
        try {
            String[] requestedPermissions = packageManager.getPackageInfo(activity.getApplicationContext().getPackageName(), PackageManager.GET_PERMISSIONS).requestedPermissions;
            if (Arrays.asList(requestedPermissions).contains(Manifest.permission.CAMERA)
                    && ContextCompat.checkSelfPermission(activity, Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED) {
                needed = true;
            }
        } catch (PackageManager.NameNotFoundException e) {
            needed = true;
        }

        return needed;
    }

    private Intent getPhotoIntent() {
        Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        imageOutputFileUri = getOutputUri(MediaStore.ACTION_IMAGE_CAPTURE);
        intent.putExtra(MediaStore.EXTRA_OUTPUT, imageOutputFileUri);
        return intent;
    }

    private Intent getVideoIntent() {
        Intent intent = new Intent(MediaStore.ACTION_VIDEO_CAPTURE);
        videoOutputFileUri = getOutputUri(MediaStore.ACTION_VIDEO_CAPTURE);
        intent.putExtra(MediaStore.EXTRA_OUTPUT, videoOutputFileUri);
        return intent;
    }
    

    private Intent getFileChooserIntent(String acceptTypes) {
        String _acceptTypes = acceptTypes;
        if (acceptTypes.isEmpty()) {
            _acceptTypes = DEFAULT_MIME_TYPES;
        }
        if (acceptTypes.matches("\\.\\w+")) {
            _acceptTypes = getMimeTypeFromExtension(acceptTypes.replace(".", ""));
        }
        Intent intent = new Intent(Intent.ACTION_GET_CONTENT);
        intent.addCategory(Intent.CATEGORY_OPENABLE);
        intent.setType(_acceptTypes);
        return intent;
    }

    @RequiresApi(api = Build.VERSION_CODES.KITKAT)
    private Intent getFileChooserIntent(String[] acceptTypes, boolean allowMultiple) {
        Intent intent = new Intent(Intent.ACTION_GET_CONTENT);
        intent.addCategory(Intent.CATEGORY_OPENABLE);
        intent.setType("*/*");
        intent.putExtra(Intent.EXTRA_MIME_TYPES, getAcceptedMimeType(acceptTypes));
        intent.putExtra(Intent.EXTRA_ALLOW_MULTIPLE, allowMultiple);
        return intent;
    }

    private Boolean acceptsAny(String[] types) {
        if (isArrayEmpty(types)) {
            return true;
        }

        for (String type : types) {
            if (type.equals("*/*")) {
                return true;
            }
        }

        return false;
    }

    private Boolean acceptsImages(String types) {
        String mimeType = types;
        if (types.matches("\\.\\w+")) {
            mimeType = getMimeTypeFromExtension(types.replace(".", ""));
        }
        return mimeType.isEmpty() || mimeType.toLowerCase().contains("image");
    }

    private Boolean acceptsImages(String[] types) {
        String[] mimeTypes = getAcceptedMimeType(types);
        return acceptsAny(types) || arrayContainsString(mimeTypes, "image");
    }

    private Boolean acceptsVideo(String types) {
        String mimeType = types;
        if (types.matches("\\.\\w+")) {
            mimeType = getMimeTypeFromExtension(types.replace(".", ""));
        }
        return mimeType.isEmpty() || mimeType.toLowerCase().contains("video");
    }

    private Boolean acceptsVideo(String[] types) {
        String[] mimeTypes = getAcceptedMimeType(types);
        return acceptsAny(types) || arrayContainsString(mimeTypes, "video");
    }

    private Boolean arrayContainsString(String[] array, String pattern) {
        for (String content : array) {
            if (content.contains(pattern)) {
                return true;
            }
        }
        return false;
    }

    private String[] getAcceptedMimeType(String[] types) {
        if (isArrayEmpty(types)) {
            return new String[]{DEFAULT_MIME_TYPES};
        }
        String[] mimeTypes = new String[types.length];
        for (int i = 0; i < types.length; i++) {
            String t = types[i];
            // convert file extensions to mime types
            if (t.matches("\\.\\w+")) {
                String mimeType = getMimeTypeFromExtension(t.replace(".", ""));
                mimeTypes[i] = mimeType;
            } else {
                mimeTypes[i] = t;
            }
        }
        return mimeTypes;
    }

    private String getMimeTypeFromExtension(String extension) {
        String type = null;
        if (extension != null) {
            type = MimeTypeMap.getSingleton().getMimeTypeFromExtension(extension);
        }
        return type;
    }

    private Uri getOutputUri(String intentType) {
        File capturedFile = null;
        try {
            capturedFile = getCapturedFile(intentType);
        } catch (IOException e) {
            Log.e(LOG_TAG, "Error occurred while creating the File", e);
            e.printStackTrace();
        }

        // for versions below 6.0 (23) we use the old File creation & permissions model
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
            return Uri.fromFile(capturedFile);
        }

        Activity activity = plugin.activity;
        // for versions 6.0+ (23) we use the FileProvider to avoid runtime permissions
        String packageName = activity.getApplicationContext().getPackageName();
        return FileProvider.getUriForFile(activity.getApplicationContext(), packageName + "." + fileProviderAuthorityExtension, capturedFile);
    }

    private File getCapturedFile(String intentType) throws IOException {
        String prefix = "";
        String suffix = "";
        String dir = "";

        if (intentType.equals(MediaStore.ACTION_IMAGE_CAPTURE)) {
            prefix = "image";
            suffix = ".jpg";
            dir = Environment.DIRECTORY_PICTURES;
        } else if (intentType.equals(MediaStore.ACTION_VIDEO_CAPTURE)) {
            prefix = "video";
            suffix = ".mp4";
            dir = Environment.DIRECTORY_MOVIES;
        }

        // for versions below 6.0 (23) we use the old File creation & permissions model
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
            // only this Directory works on all tested Android versions
            // ctx.getExternalFilesDir(dir) was failing on Android 5.0 (sdk 21)
            File storageDir = Environment.getExternalStoragePublicDirectory(dir);
            String filename = String.format("%s-%d%s", prefix, System.currentTimeMillis(), suffix);
            return new File(storageDir, filename);
        }

        Activity activity = plugin.activity;
        File storageDir = activity.getApplicationContext().getExternalFilesDir(null);
        return File.createTempFile(prefix, suffix, storageDir);
    }

    private Boolean isArrayEmpty(String[] arr) {
        // when our array returned from getAcceptTypes() has no values set from the webview
        // i.e. <input type="file" />, without any "accept" attr
        // will be an array with one empty string element, afaik
        return arr.length == 0 || (arr.length == 1 && arr[0].length() == 0);
    }

    @Override
    public void onPermissionRequest(final PermissionRequest request) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            Map<String, Object> obj = new HashMap<>();
            obj.put("origin", request.getOrigin().toString());
            obj.put("resources", Arrays.asList(request.getResources()));
            channel.invokeMethod("onPermissionRequest", obj, new MethodChannel.Result() {
                @Override
                public void success(Object response) {
                    if (response != null) {
                        Map<String, Object> responseMap = (Map<String, Object>) response;
                        Integer action = (Integer) responseMap.get("action");
                        List<String> resourceList = (List<String>) responseMap.get("resources");
                        if (resourceList == null)
                            resourceList = new ArrayList<String>();
                        String[] resources = new String[resourceList.size()];
                        resources = resourceList.toArray(resources);
                        if (action != null) {
                            switch (action) {
                                case 1:
                                    request.grant(resources);
                                    return;
                                case 0:
                                default:
                                    request.deny();
                                    return;
                            }
                        }
                    }
                    request.deny();
                }

                @Override
                public void error(String errorCode, @Nullable String errorMessage, @Nullable Object errorDetails) {
                    Log.e(LOG_TAG, errorCode + ", " + ((errorMessage != null) ? errorMessage : ""));
                    request.deny();
                }

                @Override
                public void notImplemented() {
                    request.deny();
                }
            });
        }
    }

    public void dispose() {
        if (plugin != null && plugin.activityPluginBinding != null) {
            plugin.activityPluginBinding.removeActivityResultListener(this);
        }
        plugin = null;
    }

    // @Override
    // public void onGeolocationPermissionsShowPrompt(final String origin, final GeolocationPermissions.Callback callback) {
    //     //        Log.e("--------------->","获取地图允许定位权限");
    //     callback.invoke(origin, true, true);
    // }
}
