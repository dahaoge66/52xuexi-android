package com.xuexiweb;

import android.annotation.SuppressLint;
import android.content.pm.ActivityInfo;
import android.graphics.Bitmap;
import android.net.http.SslError;
import android.os.Bundle;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.SslErrorHandler;
import android.webkit.WebChromeClient;
import android.webkit.WebResourceRequest;
import android.webkit.WebResourceResponse;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.FrameLayout;

import androidx.appcompat.app.AppCompatActivity;

public class MainActivity extends AppCompatActivity {
    private WebView webView;
    private FrameLayout webViewContainer;
    private View customView;
    private WebChromeClient.CustomViewCallback customViewCallback;

    @SuppressLint({"SetJavaScriptEnabled", "SourceLockedOrientationActivity"})
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        webViewContainer = new FrameLayout(this);
        setContentView(webViewContainer);

        webView = new WebView(this);
        webViewContainer.addView(webView, new FrameLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.MATCH_PARENT
        ));

        WebSettings webSettings = webView.getSettings();
        webSettings.setJavaScriptEnabled(true);
        webSettings.setDomStorageEnabled(true);
        webSettings.setDatabaseEnabled(true);
        webSettings.setMediaPlaybackRequiresUserGesture(false);
        webSettings.setMixedContentMode(WebSettings.MIXED_CONTENT_ALWAYS_ALLOW);
        webSettings.setAllowFileAccess(true);
        webSettings.setAllowContentAccess(true);
        webSettings.setAllowUniversalAccessFromFileURLs(true);
        webSettings.setAllowFileAccessFromFileURLs(true);
        webSettings.setCacheMode(WebSettings.LOAD_DEFAULT);
        webSettings.setLoadsImagesAutomatically(true);
        webSettings.setJavaScriptCanOpenWindowsAutomatically(true);
        webSettings.setGeolocationEnabled(true);
        webView.setLayerType(View.LAYER_TYPE_HARDWARE, null);
        WebView.setWebContentsDebuggingEnabled(true);

        webView.setWebViewClient(new WebViewClient() {
            @Override
            public boolean shouldOverrideUrlLoading(WebView view, String url) {
                view.loadUrl(url);
                return true;
            }

            @Override
            public void onReceivedSslError(WebView view, SslErrorHandler handler, SslError error) {
                handler.proceed();
            }

            @Override
            public WebResourceResponse shouldInterceptRequest(WebView view, WebResourceRequest request) {
                return super.shouldInterceptRequest(view, request);
            }

            @Override
            public void onPageStarted(WebView view, String url, Bitmap favicon) {
                super.onPageStarted(view, url, favicon);
                if (customView != null) {
                    onHideCustomView();
                }
            }

            @Override
            public void onPageFinished(WebView view, String url) {
                super.onPageFinished(view, url);
                String mediaFixScript =
                        "console.log('52学习APP: 媒体增强启用');" +
                        "document.querySelectorAll('video').forEach(function(video){" +
                        "video.setAttribute('playsinline','');" +
                        "video.setAttribute('webkit-playsinline','');" +
                        "video.setAttribute('controls','');" +
                        "video.style.width='100%';" +
                        "video.style.height='100%';" +
                        "video.style.objectFit='contain';" +
                        "});";
                view.evaluateJavascript(mediaFixScript, null);
            }
        });

        webView.setWebChromeClient(new WebChromeClient() {
            @Override
            public void onShowCustomView(View view, CustomViewCallback callback) {
                if (customView != null) {
                    onHideCustomView();
                    return;
                }

                customView = view;
                customViewCallback = callback;

                webView.setVisibility(View.GONE);
                webViewContainer.addView(customView, new FrameLayout.LayoutParams(
                        ViewGroup.LayoutParams.MATCH_PARENT,
                        ViewGroup.LayoutParams.MATCH_PARENT
                ));
                setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE);
            }

            @Override
            public void onHideCustomView() {
                if (customView == null) {
                    return;
                }

                webViewContainer.removeView(customView);
                webView.setVisibility(View.VISIBLE);
                if (customViewCallback != null) {
                    customViewCallback.onCustomViewHidden();
                }
                customView = null;
                customViewCallback = null;
                setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
            }
        });

        webView.loadUrl("http://81.71.85.120");
    }

    @Override
    public void onBackPressed() {
        if (customView != null) {
            onHideCustomView();
        } else if (webView.canGoBack()) {
            webView.goBack();
        } else {
            super.onBackPressed();
        }
    }

    @Override
    protected void onDestroy() {
        if (webView != null) {
            webView.destroy();
        }
        super.onDestroy();
    }
}
