#!/bin/bash

echo "========================================"
echo "  52学习 Android APP - 一键部署脚本"
echo "========================================"
echo

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 设置环境变量
export ANDROID_HOME=/home/android-sdk
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
export PATH=$PATH:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools

log "设置环境变量..."
echo "ANDROID_HOME=$ANDROID_HOME"
echo "JAVA_HOME=$JAVA_HOME"
echo

# 检查必要文件
log "检查环境依赖..."

if [ ! -d "$JAVA_HOME" ]; then
    error "Java 11 未找到，正在安装..."
    sudo apt update
    sudo apt install -y openjdk-11-jdk
fi

if [ ! -d "$ANDROID_HOME" ]; then
    error "Android SDK 未找到在 $ANDROID_HOME"
    exit 1
fi

if ! command -v gradle &> /dev/null; then
    error "Gradle 未安装"
    exit 1
fi

log "✅ 环境检查通过"

# 创建必要的配置文件
log "创建 gradle.properties..."
cat > gradle.properties << EOF
# Project-wide Gradle settings.
org.gradle.jvmargs=-Xmx1536m
android.useDeprecatedNdk=true
android.enableJetifier=true
android.useAndroidX=true
android.suppressUnsupportedCompileSdk=27
EOF

log "创建 local.properties..."
cat > local.properties << EOF
sdk.dir=$ANDROID_HOME
EOF

# 修复权限
log "修复文件权限..."
chmod +x gradlew
chmod 755 .

# 清理构建
log "清理之前的构建..."
rm -rf app/build
rm -rf .gradle

# 开始构建
log "开始构建 Android APK..."
echo

BUILD_TYPE=${1:-debug}

if [ "$BUILD_TYPE" = "release" ]; then
    log "构建发布版 APK..."
    gradle clean assembleRelease --stacktrace
    APK_PATH="app/build/outputs/apk/release/app-release.apk"
else
    log "构建调试版 APK..."
    gradle clean assembleDebug --stacktrace
    APK_PATH="app/build/outputs/apk/debug/app-debug.apk"
fi

# 检查构建结果
if [ -f "$APK_PATH" ]; then
    log "🎉 APK 构建成功！"
    echo
    echo "APK 位置: $APK_PATH"
    
    # 复制到 Web 目录供下载
    if [ -d "/home/online-learning-platform/dist" ]; then
        cp "$APK_PATH" "/home/online-learning-platform/dist/52学习-app.apk"
        log "✅ APK 已复制到 Web 目录，可通过 http://52xuexi.art/52学习-app.apk 下载"
    fi
    
    # 显示 APK 信息
    ls -lh "$APK_PATH"
    echo
    
    log "🚀 安装说明："
    echo "1. 下载 APK 到手机"
    echo "2. 设置 → 安全 → 允许未知来源应用"
    echo "3. 点击 APK 文件安装"
    echo "4. 打开 APP 即可使用在线学习平台"
    
else
    error "❌ APK 构建失败！"
    echo
    warn "尝试解决方案："
    echo "1. 使用 Android Studio (推荐)"
    echo "2. 检查 Android SDK 版本"
    echo "3. 查看构建日志中的具体错误"
    exit 1
fi

echo
log "🎯 构建完成！"
