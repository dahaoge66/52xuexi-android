#!/bin/bash

echo "========================================"
echo "  使用Android Studio命令行工具构建52学习APP"
echo "========================================"
echo

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 设置Android Studio环境
export ANDROID_STUDIO_HOME="/home/android-studio"
export ANDROID_HOME="/home/android-sdk"
export JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"
export PATH=$PATH:$ANDROID_STUDIO_HOME/bin:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools

log "设置Android Studio环境..."
echo "ANDROID_STUDIO_HOME=$ANDROID_STUDIO_HOME"
echo "ANDROID_HOME=$ANDROID_HOME"
echo "JAVA_HOME=$JAVA_HOME"
echo

# 检查Android Studio
if [ ! -d "$ANDROID_STUDIO_HOME" ]; then
    error "Android Studio 未找到在 $ANDROID_STUDIO_HOME"
    exit 1
fi

# 使用Android Studio的gradle wrapper
log "准备使用Android Studio的构建系统..."

# 创建gradle wrapper配置
mkdir -p gradle/wrapper
cat > gradle/wrapper/gradle-wrapper.properties << EOF
distributionBase=GRADLE_USER_HOME
distributionPath=wrapper/dists
distributionUrl=https\://services.gradle.org/distributions/gradle-4.4.1-all.zip
zipStoreBase=GRADLE_USER_HOME
zipStorePath=wrapper/dists
EOF

# 创建优化的gradle.properties
cat > gradle.properties << EOF
# Android Studio构建优化
org.gradle.jvmargs=-Xmx2048m -XX:MaxPermSize=512m
android.useDeprecatedNdk=true
android.enableJetifier=true
android.useAndroidX=true
android.suppressUnsupportedCompileSdk=27

# 使用Android Studio的SDK
sdk.dir=$ANDROID_HOME
EOF

# 创建local.properties
cat > local.properties << EOF
sdk.dir=$ANDROID_HOME
EOF

# 下载gradle wrapper
log "下载Gradle Wrapper..."
if [ ! -f "gradle/wrapper/gradle-wrapper.jar" ]; then
    curl -L -o gradle/wrapper/gradle-wrapper.jar https://github.com/gradle/gradle/raw/v4.4.1/gradle/wrapper/gradle-wrapper.jar
fi

# 创建gradlew脚本
cat > gradlew << 'EOF'
#!/usr/bin/env sh

GRADLE_APP_NAME="Gradle"

# Resolve links: $0 may be a link
PRG="$0"
# Need this for relative symlinks.
while [ -h "$PRG" ] ; do
    ls=`ls -ld "$PRG"`
    link=`expr "$ls" : '.*-> \(.*\)$'`
    if expr "$link" : '/.*' > /dev/null; then
        PRG="$link"
    else
        PRG=`dirname "$PRG"`"/$link"
    fi
done
SAVED="`pwd`"
cd "`dirname \"$PRG\"`/" >/dev/null
APP_HOME="`pwd -P`"
cd "$SAVED" >/dev/null

APP_BASE_NAME=`basename "$0"`

# Add default JVM options here. You can also use JAVA_OPTS and GRADLE_OPTS to pass JVM options to this script.
DEFAULT_JVM_OPTS="-Xmx1024m -Xms512m"

# Use the maximum available, or set MAX_FD != -1 to use that value.
MAX_FD="maximum"

warn ( ) {
    echo "$*"
}

die ( ) {
    echo
    echo "$*"
    echo
    exit 1
}

# OS specific support (must be 'true' or 'false').
cygwin=false
msys=false
darwin=false
nonstop=false
case "`uname`" in
  CYGWIN* )
    cygwin=true
    ;;
  Darwin* )
    darwin=true
    ;;
  MINGW* )
    msys=true
    ;;
  NONSTOP* )
    nonstop=true
    ;;
esac

CLASSPATH=$APP_HOME/gradle/wrapper/gradle-wrapper.jar

# Determine the Java command to use to start the JVM.
if [ -n "$JAVA_HOME" ] ; then
    if [ -x "$JAVA_HOME/jre/sh/java" ] ; then
        # IBM's JDK on AIX uses strange locations for the executables
        JAVACMD="$JAVA_HOME/jre/sh/java"
    else
        JAVACMD="$JAVA_HOME/bin/java"
    fi
    if [ ! -x "$JAVACMD" ] ; then
        die "ERROR: JAVA_HOME is set to an invalid directory: $JAVA_HOME

Please set the JAVA_HOME variable in your environment to match the
location of your Java installation."
    fi
else
    JAVACMD="java"
    which java >/dev/null 2>&1 || die "ERROR: JAVA_HOME is not set and no 'java' command could be found in your PATH.

Please set the JAVA_HOME variable in your environment to match the
location of your Java installation."
fi

# Increase the maximum file descriptors if we can.
if [ "$cygwin" = "false" -a "$darwin" = "false" -a "$nonstop" = "false" ] ; then
    MAX_FD_LIMIT=`ulimit -H -n`
    if [ $? -eq 0 ] ; then
        if [ "$MAX_FD" = "maximum" -o "$MAX_FD" = "max" ] ; then
            MAX_FD="$MAX_FD_LIMIT"
        fi
        ulimit -n $MAX_FD
        if [ $? -ne 0 ] ; then
            warn "Could not set maximum file descriptor limit: $MAX_FD"
        fi
    else
        warn "Could not query maximum file descriptor limit: $MAX_FD_LIMIT"
    fi
fi

# For Darwin, add options to specify how the application appears in the dock
if [ "$darwin" = "true" ]; then
    GRADLE_OPTS="$GRADLE_OPTS \"-Xdock:name=$APP_BASE_NAME\" \"-Xdock:icon=$APP_HOME/media/gradle.icns\""
fi

# For Cygwin or MSYS, switch paths to Windows format before running java
if [ "$cygwin" = "true" -o "$msys" = "true" ] ; then
    APP_HOME=`cygpath --path --mixed "$APP_HOME"`
    CLASSPATH=`cygpath --path --mixed "$CLASSPATH"`
    JAVACMD=`cygpath --unix "$JAVACMD"`
fi

exec "$JAVACMD" $DEFAULT_JVM_OPTS $JAVA_OPTS $GRADLE_OPTS "-Dorg.gradle.appname=$APP_BASE_NAME" -classpath "$CLASSPATH" org.gradle.wrapper.GradleWrapperMain "$@"
EOF

chmod +x gradlew

# 开始构建
log "🚀 开始使用Android Studio构建系统构建52学习APP..."
echo

BUILD_TYPE=${1:-debug}

if [ "$BUILD_TYPE" = "release" ]; then
    log "构建发布版APK..."
    ./gradlew clean assembleRelease --stacktrace --info
    APK_PATH="app/build/outputs/apk/release/app-release.apk"
else
    log "构建调试版APK..."
    ./gradlew clean assembleDebug --stacktrace --info
    APK_PATH="app/build/outputs/apk/debug/app-debug.apk"
fi

# 检查构建结果
if [ -f "$APK_PATH" ]; then
    log "🎉 52学习APP构建成功！"
    echo
    echo "📱 APK信息:"
    ls -lh "$APK_PATH"
    
    # 计算APK大小
    APK_SIZE=$(du -h "$APK_PATH" | cut -f1)
    echo "📦 APK大小: $APK_SIZE"
    
    # 复制到Web目录
    if [ -d "/home/online-learning-platform/dist" ]; then
        cp "$APK_PATH" "/home/online-learning-platform/dist/52学习.apk"
        log "✅ APK已部署到Web服务器"
        echo "🌐 下载链接: http://52xuexi.art/52学习.apk"
    fi
    
    # 显示安装说明
    echo
    log "📲 安装说明："
    echo "1. 在手机浏览器打开: http://52xuexi.art/52学习.apk"
    echo "2. 下载APK文件到手机"
    echo "3. 设置 → 安全 → 允许未知来源应用"
    echo "4. 点击APK文件安装"
    echo "5. 打开'52学习'APP开始使用！"
    
    # 显示APP功能
    echo
    log "📱 APP功能特性："
    echo "• APP名称: 52学习"
    echo "• 加载网站: www.52xuexi.art"
    echo "• 支持功能: 在线学习、视频播放、进度同步"
    echo "• 兼容设备: Android 5.0+ (API 21+)"
    echo "• 下载支持: 课程资料下载"
    echo "• 深度链接: 支持外部调用"
else
    error "❌ 构建失败！"
    echo
    warn "可能的解决方案："
    echo "1. 检查Android SDK配置"
    echo "2. 确保网络连接正常(下载依赖)"
    echo "3. 查看详细构建日志"
    echo "4. 尝试手动运行: ./gradlew assembleDebug --info"
    exit 1
fi

echo
log "🎯 52学习APP构建完成！享受移动学习体验！"
