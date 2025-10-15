package com.xuexiweb.app;

import android.app.Activity;
import android.os.Bundle;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.SslErrorHandler;
import android.net.http.SslError;
import android.webkit.WebResourceRequest;
import android.webkit.WebResourceResponse;
import android.view.View;
import android.widget.FrameLayout;

public class MainActivity extends Activity {
    
    private WebView webView;
    private FrameLayout customViewContainer;
    private WebChromeClient.CustomViewCallback customViewCallback;
    private View customView;
    
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        // 创建WebView
        webView = new WebView(this);
        
        // 配置WebView - 增强视频播放支持
        WebSettings webSettings = webView.getSettings();
        webSettings.setJavaScriptEnabled(true);
        webSettings.setDomStorageEnabled(true);
        webSettings.setDatabaseEnabled(true);
        webSettings.setLoadWithOverviewMode(true);
        webSettings.setUseWideViewPort(true);
        webSettings.setBuiltInZoomControls(true);
        webSettings.setDisplayZoomControls(false);
        
        // 启用媒体播放支持
        webSettings.setMediaPlaybackRequiresUserGesture(false);
        webSettings.setJavaScriptCanOpenWindowsAutomatically(true);
        
        // 超级宽松的混合内容模式 - 强制允许所有内容
        webSettings.setMixedContentMode(WebSettings.MIXED_CONTENT_ALWAYS_ALLOW);
        
        // 最大化的网络和文件访问权限
        webSettings.setAllowFileAccess(true);
        webSettings.setAllowContentAccess(true);
        webSettings.setAllowUniversalAccessFromFileURLs(true);
        webSettings.setAllowFileAccessFromFileURLs(true);
        
        // 启用缓存和存储功能
        webSettings.setCacheMode(WebSettings.LOAD_DEFAULT);
        webSettings.setDatabaseEnabled(true);
        
        // 地理位置和通知支持
        webSettings.setGeolocationEnabled(true);
        
        // 设置伪装的用户代理 - 模拟主流浏览器
        String customUserAgent = "Mozilla/5.0 (Linux; Android 10; SM-G975F) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.120 Mobile Safari/537.36 52XuexiApp/1.0";
        webSettings.setUserAgentString(customUserAgent);
        
        // 超级增强的媒体支持设置
        webSettings.setLoadWithOverviewMode(true);
        webSettings.setUseWideViewPort(true);
        webSettings.setBuiltInZoomControls(false);
        webSettings.setDisplayZoomControls(false);
        webSettings.setSupportZoom(false);
        
        // 禁用WebView的安全特性以支持媒体加载
        webSettings.setAllowFileAccessFromFileURLs(true);
        webSettings.setAllowUniversalAccessFromFileURLs(true);
        
        // 启用所有Web功能
        webSettings.setJavaScriptCanOpenWindowsAutomatically(true);
        webSettings.setLoadsImagesAutomatically(true);
        webSettings.setBlockNetworkImage(false);
        webSettings.setBlockNetworkLoads(false);
        
        // 设置WebViewClient - 增强媒体加载支持
        webView.setWebViewClient(new WebViewClient() {
            @Override
            public boolean shouldOverrideUrlLoading(WebView view, String url) {
                view.loadUrl(url);
                return true;
            }
            
            @Override
            public void onReceivedSslError(WebView view, SslErrorHandler handler, SslError error) {
                // 允许SSL错误以支持自签名证书的媒体服务器
                handler.proceed();
            }
            
            @Override
            public WebResourceResponse shouldInterceptRequest(WebView view, WebResourceRequest request) {
                // 处理媒体资源请求，允许HTTP媒体内容
                String url = request.getUrl().toString();
                if (url.contains(".mp4") || url.contains(".jpg") || url.contains(".png") || url.contains(".gif")) {
                    // 对于媒体文件，允许HTTP协议
                    return super.shouldInterceptRequest(view, request);
                }
                return super.shouldInterceptRequest(view, request);
            }
            
            @Override
            public void onPageFinished(WebView view, String url) {
                super.onPageFinished(view, url);
                
                // 强力JavaScript注入 - 解决所有媒体加载问题
                String mediaFixScript = 
                    "console.log('52学习APP: 超级媒体支持已激活');" +
                    
                    // 移除所有CSP限制
                    "var metaTags = document.getElementsByTagName('meta');" +
                    "for(var i = 0; i < metaTags.length; i++) {" +
                    "  if(metaTags[i].getAttribute('http-equiv') === 'Content-Security-Policy') {" +
                    "    metaTags[i].remove();" +
                    "  }" +
                    "}" +
                    
                    // 强制允许混合内容
                    "if(typeof window.mixedContentPolicy !== 'undefined') {" +
                    "  window.mixedContentPolicy = 'allow';" +
                    "}" +
                    
                    // 增强所有视频元素
                    "function enhanceMediaElements() {" +
                    "  var videos = document.querySelectorAll('video');" +
                    "  videos.forEach(function(video) {" +
                    "    video.setAttribute('crossorigin', 'anonymous');" +
                    "    video.setAttribute('preload', 'auto');" +
                    "    video.setAttribute('controls', 'true');" +
                    "    video.setAttribute('playsinline', 'true');" +
                    "    video.muted = false;" +
                    "    console.log('视频元素增强:', video.src);" +
                    "  });" +
                    
                    // 增强所有图片元素
                    "  var images = document.querySelectorAll('img');" +
                    "  images.forEach(function(img) {" +
                    "    img.setAttribute('crossorigin', 'anonymous');" +
                    "    if(img.src && img.src.startsWith('http://')) {" +
                    "      console.log('强制加载HTTP图片:', img.src);" +
                    "    }" +
                    "  });" +
                    "}" +
                    
                    // 立即执行和延迟执行
                    "enhanceMediaElements();" +
                    "setTimeout(enhanceMediaElements, 1000);" +
                    "setTimeout(enhanceMediaElements, 3000);" +
                    
                    // 监听动态添加的媒体元素
                    "var observer = new MutationObserver(function(mutations) {" +
                    "  mutations.forEach(function(mutation) {" +
                    "    if(mutation.addedNodes) {" +
                    "      mutation.addedNodes.forEach(function(node) {" +
                    "        if(node.tagName === 'VIDEO' || node.tagName === 'IMG') {" +
                    "          enhanceMediaElements();" +
                    "        }" +
                    "      });" +
                    "    }" +
                    "  });" +
                    "});" +
                    "observer.observe(document.body, {childList: true, subtree: true});" +
                    
                    "console.log('52学习APP: 媒体增强脚本执行完成');";
                
                view.evaluateJavascript(mediaFixScript, null);
            }
        });
        
        // 设置WebChromeClient - 支持HTML5视频全屏播放
        webView.setWebChromeClient(new WebChromeClient() {
            @Override
            public void onShowCustomView(View view, CustomViewCallback callback) {
                if (customView != null) {
                    onHideCustomView();
                    return;
                }
                
                customView = view;
                customViewCallback = callback;
                
                if (customViewContainer == null) {
                    customViewContainer = new FrameLayout(MainActivity.this);
                }
                
                customViewContainer.addView(view);
                setContentView(customViewContainer);
            }
            
            @Override
            public void onHideCustomView() {
                if (customView == null) {
                    return;
                }
                
                setContentView(webView);
                customViewContainer.removeView(customView);
                customViewCallback.onCustomViewHidden();
                customView = null;
                customViewCallback = null;
            }
        });
        
            // 加载网站 - 使用IP地址访问
            webView.loadUrl("http://81.71.85.120");
        
        // 设置为内容视图
        setContentView(webView);
    }
    
    @Override
    public void onBackPressed() {
        if (webView.canGoBack()) {
            webView.goBack();
        } else {
            super.onBackPressed();
        }
    }
}
