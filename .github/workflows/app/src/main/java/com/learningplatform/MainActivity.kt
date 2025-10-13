package com.learningplatform

import android.Manifest
import android.app.DownloadManager
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.Environment
import android.webkit.*
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import androidx.swiperefreshlayout.widget.SwipeRefreshLayout

class MainActivity : AppCompatActivity() {

    private lateinit var webView: WebView
    private lateinit var swipeRefreshLayout: SwipeRefreshLayout
    private val STORAGE_PERMISSION_CODE = 1000
    
    // 网站URL - 可以修改为你的域名
    private val BASE_URL = "http://www.52xuexi.art"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        // 初始化SwipeRefreshLayout
        swipeRefreshLayout = findViewById(R.id.swipeRefreshLayout)
        swipeRefreshLayout.setOnRefreshListener {
            webView.reload()
        }

        // 初始化WebView
        webView = findViewById(R.id.webView)
        setupWebView()

        // 加载网站
        webView.loadUrl(BASE_URL)

        // 请求存储权限（用于下载文件）
        checkStoragePermission()
    }

    private fun setupWebView() {
        webView.apply {
            settings.apply {
                // 启用JavaScript
                javaScriptEnabled = true
                
                // 启用DOM存储
                domStorageEnabled = true
                
                // 启用数据库
                databaseEnabled = true
                
                // 启用缓存
                cacheMode = WebSettings.LOAD_DEFAULT
                setAppCacheEnabled(true)
                
                // 支持缩放
                setSupportZoom(true)
                builtInZoomControls = true
                displayZoomControls = false
                
                // 自适应屏幕
                useWideViewPort = true
                loadWithOverviewMode = true
                
                // 支持自动播放媒体
                mediaPlaybackRequiresUserGesture = false
                
                // 允许混合内容（HTTP和HTTPS）
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                    mixedContentMode = WebSettings.MIXED_CONTENT_ALWAYS_ALLOW
                }
                
                // 设置User-Agent
                userAgentString = "$userAgentString LearningPlatformApp/1.0"
            }

            // 设置WebViewClient
            webViewClient = object : WebViewClient() {
                override fun shouldOverrideUrlLoading(view: WebView?, request: WebResourceRequest?): Boolean {
                    val url = request?.url.toString()
                    
                    // 在APP内打开本站链接
                    return if (url.startsWith(BASE_URL)) {
                        false
                    } else {
                        // 外部链接用浏览器打开
                        try {
                            val intent = Intent(Intent.ACTION_VIEW, Uri.parse(url))
                            startActivity(intent)
                        } catch (e: Exception) {
                            Toast.makeText(this@MainActivity, "无法打开链接", Toast.LENGTH_SHORT).show()
                        }
                        true
                    }
                }

                override fun onPageFinished(view: WebView?, url: String?) {
                    super.onPageFinished(view, url)
                    // 页面加载完成，停止刷新动画
                    swipeRefreshLayout.isRefreshing = false
                }

                override fun onReceivedError(view: WebView?, request: WebResourceRequest?, error: WebResourceError?) {
                    super.onReceivedError(view, request, error)
                    Toast.makeText(this@MainActivity, "页面加载失败", Toast.LENGTH_SHORT).show()
                }
            }

            // 设置WebChromeClient（支持文件上传、全屏视频等）
            webChromeClient = object : WebChromeClient() {
                // 进度条
                override fun onProgressChanged(view: WebView?, newProgress: Int) {
                    super.onProgressChanged(view, newProgress)
                    if (newProgress == 100) {
                        swipeRefreshLayout.isRefreshing = false
                    }
                }

                // 支持alert、confirm、prompt
                override fun onJsAlert(view: WebView?, url: String?, message: String?, result: JsResult?): Boolean {
                    android.app.AlertDialog.Builder(this@MainActivity)
                        .setMessage(message)
                        .setPositiveButton("确定") { _, _ -> result?.confirm() }
                        .setCancelable(false)
                        .create()
                        .show()
                    return true
                }

                override fun onJsConfirm(view: WebView?, url: String?, message: String?, result: JsResult?): Boolean {
                    android.app.AlertDialog.Builder(this@MainActivity)
                        .setMessage(message)
                        .setPositiveButton("确定") { _, _ -> result?.confirm() }
                        .setNegativeButton("取消") { _, _ -> result?.cancel() }
                        .setCancelable(false)
                        .create()
                        .show()
                    return true
                }
            }

            // 设置下载监听
            setDownloadListener { url, userAgent, contentDisposition, mimetype, contentLength ->
                downloadFile(url, userAgent, contentDisposition, mimetype)
            }
        }
    }

    // 下载文件
    private fun downloadFile(url: String, userAgent: String, contentDisposition: String, mimetype: String) {
        try {
            val request = DownloadManager.Request(Uri.parse(url))
            request.setMimeType(mimetype)
            request.addRequestHeader("User-Agent", userAgent)
            request.setDescription("正在下载...")
            request.setTitle(URLUtil.guessFileName(url, contentDisposition, mimetype))
            request.allowScanningByMediaScanner()
            request.setNotificationVisibility(DownloadManager.Request.VISIBILITY_VISIBLE_NOTIFY_COMPLETED)
            request.setDestinationInExternalPublicDir(Environment.DIRECTORY_DOWNLOADS, URLUtil.guessFileName(url, contentDisposition, mimetype))
            
            val dm = getSystemService(Context.DOWNLOAD_SERVICE) as DownloadManager
            dm.enqueue(request)
            
            Toast.makeText(this, "开始下载", Toast.LENGTH_SHORT).show()
        } catch (e: Exception) {
            Toast.makeText(this, "下载失败: ${e.message}", Toast.LENGTH_SHORT).show()
        }
    }

    // 检查存储权限
    private fun checkStoragePermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (ContextCompat.checkSelfPermission(this, Manifest.permission.WRITE_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
                ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.WRITE_EXTERNAL_STORAGE), STORAGE_PERMISSION_CODE)
            }
        }
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == STORAGE_PERMISSION_CODE) {
            if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                Toast.makeText(this, "存储权限已授予", Toast.LENGTH_SHORT).show()
            }
        }
    }

    // 处理返回键
    override fun onBackPressed() {
        if (webView.canGoBack()) {
            webView.goBack()
        } else {
            // 双击退出
            super.onBackPressed()
        }
    }

    // 保存WebView状态
    override fun onSaveInstanceState(outState: Bundle) {
        super.onSaveInstanceState(outState)
        webView.saveState(outState)
    }

    // 恢复WebView状态
    override fun onRestoreInstanceState(savedInstanceState: Bundle) {
        super.onRestoreInstanceState(savedInstanceState)
        webView.restoreState(savedInstanceState)
    }

    override fun onDestroy() {
        webView.clearCache(false)
        webView.destroy()
        super.onDestroy()
    }
}

