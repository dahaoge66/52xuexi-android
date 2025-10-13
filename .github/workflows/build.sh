#!/bin/bash

# 学习平台 Android APP 自动构建脚本
# 使用方法: ./build.sh [debug|release]

set -e

echo "======================================"
echo "  学习平台 Android APP 构建脚本"
echo "======================================"
echo ""

BUILD_TYPE=${1:-debug}

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 检查 Java 版本
echo -e "${YELLOW}检查 Java 环境...${NC}"
if ! command -v java &> /dev/null; then
    echo -e "${RED}❌ 未找到 Java，请先安装 JDK 11 或更高版本${NC}"
    echo ""
    echo "Ubuntu/Debian 安装命令:"
    echo "  sudo apt update"
    echo "  sudo apt install openjdk-11-jdk"
    exit 1
fi

JAVA_VERSION=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}' | cut -d'.' -f1)
if [ "$JAVA_VERSION" -lt 11 ]; then
    echo -e "${RED}❌ Java 版本过低（需要 11+，当前 $JAVA_VERSION）${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Java 版本: $(java -version 2>&1 | head -n 1)${NC}"
echo ""

# 检查是否有 gradlew
if [ ! -f "./gradlew" ]; then
    echo -e "${YELLOW}生成 Gradle Wrapper...${NC}"
    gradle wrapper
fi

# 赋予执行权限
chmod +x ./gradlew

# 清理旧构建
echo -e "${YELLOW}清理旧构建...${NC}"
./gradlew clean
echo ""

# 构建
echo -e "${YELLOW}开始构建 ${BUILD_TYPE} 版本...${NC}"
echo ""

if [ "$BUILD_TYPE" = "release" ]; then
    ./gradlew assembleRelease
    APK_PATH="app/build/outputs/apk/release/app-release.apk"
    if [ ! -f "$APK_PATH" ]; then
        APK_PATH="app/build/outputs/apk/release/app-release-unsigned.apk"
    fi
else
    ./gradlew assembleDebug
    APK_PATH="app/build/outputs/apk/debug/app-debug.apk"
fi

echo ""
echo "======================================"
if [ -f "$APK_PATH" ]; then
    echo -e "${GREEN}✅ 构建成功！${NC}"
    echo ""
    echo "APK 位置:"
    echo "  $(realpath $APK_PATH)"
    echo ""
    echo "APK 大小:"
    ls -lh "$APK_PATH" | awk '{print "  " $5}'
    echo ""
    echo "安装到设备:"
    echo "  adb install $APK_PATH"
    echo ""
    echo "或者将 APK 传到手机直接安装"
else
    echo -e "${RED}❌ 构建失败，未找到 APK 文件${NC}"
    exit 1
fi
echo "======================================"

