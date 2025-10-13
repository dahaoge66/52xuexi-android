# 🚀 Android Studio 完整构建指南

## 📦 当前状态

✅ **已完成**
- Android Studio 2023.3.1.19 已下载并解压到 `/home/android-studio/`
- 完整的 Android WebView 项目已创建 (`/home/learning-platform-android/`)
- Java 11 和 Gradle 4.4.1 构建环境已配置
- Android SDK 已安装 (平台27, 构建工具27.0.3)

## 🎯 三种构建方案

### 方案一：使用 Android Studio GUI (推荐)

#### 1. 设置远程桌面 (VNC)
```bash
# 安装 VNC 服务器
sudo apt update
sudo apt install -y ubuntu-desktop-minimal
sudo apt install -y tightvncserver

# 启动 VNC 服务器
vncserver :1

# 设置密码 (按提示操作)
```

#### 2. 连接和使用
```bash
# 本地电脑安装 VNC Viewer
# 连接到：服务器IP:5901

# 或者使用 SSH X11 转发
ssh -X root@服务器IP
cd /home/android-studio/bin
./studio.sh
```

#### 3. 导入项目
1. 启动 Android Studio
2. 选择 "Open an existing Android Studio project"
3. 导航到 `/home/learning-platform-android`
4. 点击 "OK"

#### 4. 自动处理依赖
Android Studio 会自动：
- 检测并下载缺少的 SDK 组件
- 配置 Gradle 版本
- 解决依赖冲突
- 生成签名密钥

#### 5. 构建 APK
1. 点击 "Build" → "Build Bundle(s) / APK(s)" → "Build APK(s)"
2. 等待构建完成
3. 点击 "locate" 查看生成的 APK 文件

---

### 方案二：命令行构建 (当前可用)

```bash
cd /home/learning-platform-android

# 使用系统 Gradle + Java 11
export ANDROID_HOME=/home/android-sdk
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64

# 构建调试版 APK
gradle clean assembleDebug

# 构建发布版 APK
gradle clean assembleRelease
```

**注意**：我们已经配置了兼容的环境，命令行构建应该可以正常工作。

---

### 方案三：Docker 构建 (隔离环境)

#### 创建 Dockerfile
```dockerfile
FROM ubuntu:20.04

# 安装依赖
RUN apt-get update && apt-get install -y \
    openjdk-11-jdk \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# 设置 Android SDK
ENV ANDROID_HOME=/opt/android-sdk
ENV PATH=$PATH:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools

# 复制项目文件
COPY . /app
WORKDIR /app

# 构建
RUN gradle assembleDebug
```

#### 使用 Docker 构建
```bash
cd /home/learning-platform-android
docker build -t android-app .
docker run --rm -v $(pwd)/app/build/outputs:/output android-app \
  cp -r /app/app/build/outputs/apk /output/
```

---

## 🔧 故障排除

### 常见问题解决

#### 1. SDK 许可证问题
```bash
cd /home/android-sdk/tools/bin
yes | ./sdkmanager --licenses
```

#### 2. Gradle 版本不兼容
修改 `gradle/wrapper/gradle-wrapper.properties`：
```properties
distributionUrl=https\://services.gradle.org/distributions/gradle-4.4.1-bin.zip
```

#### 3. 构建工具版本问题
修改 `app/build.gradle`：
```gradle
android {
    compileSdkVersion 27
    buildToolsVersion "27.0.3"
    
    defaultConfig {
        targetSdkVersion 27
        minSdkVersion 21
    }
}
```

#### 4. 内存不足
添加到 `gradle.properties`：
```properties
org.gradle.jvmargs=-Xmx2048m -XX:MaxPermSize=512m
```

---

## 📱 APK 安装和测试

### 1. 生成的 APK 位置
```
app/build/outputs/apk/debug/app-debug.apk
app/build/outputs/apk/release/app-release.apk
```

### 2. 安装到设备
```bash
# 通过 ADB 安装
adb install app-debug.apk

# 或者直接复制到设备内存卡安装
```

### 3. 测试功能
- ✅ APP 启动
- ✅ 加载 www.52xuexi.art
- ✅ 视频播放
- ✅ 文件下载
- ✅ 深度链接

---

## 🎨 自定义配置

### 更改 APP 信息
编辑 `app/src/main/res/values/strings.xml`：
```xml
<string name="app_name">52学习</string>
```

### 更改域名
编辑 `MainActivity.kt`：
```kotlin
private val baseUrl = "https://www.52xuexi.art"
```

### 更改图标
替换 `app/src/main/res/mipmap-*/ic_launcher.png`

---

## 📞 技术支持

如果遇到问题：
1. 检查日志：`adb logcat | grep LearningPlatform`
2. 清理项目：`gradle clean`
3. 重新构建：`gradle assembleDebug`
4. 查看详细错误：`gradle assembleDebug --stacktrace`

---

## ✅ 推荐方案

**最佳选择：方案一 (Android Studio)**
- 自动处理所有依赖和版本冲突
- 图形界面友好
- 完整的调试和分析工具
- 一键生成签名 APK

**备选方案：方案二 (命令行)**
- 环境已配置完成
- 适合自动化部署
- 资源占用低
