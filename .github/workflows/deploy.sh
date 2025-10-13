#!/bin/bash

# 52学习 Android APP - 一键构建并部署脚本
# 使用方法: ./deploy.sh

set -e

echo "======================================"
echo "  52学习 Android APP 一键部署"
echo "======================================"
echo ""

# 颜色
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# 检查 Java
echo -e "${YELLOW}1. 检查 Java 环境...${NC}"
if ! command -v java &> /dev/null; then
    echo -e "${RED}❌ 未找到 Java，请先安装 JDK 11+${NC}"
    echo "安装命令: sudo apt update && sudo apt install openjdk-11-jdk"
    exit 1
fi
echo -e "${GREEN}✅ Java 已安装${NC}"
echo ""

# 构建 APK
echo -e "${YELLOW}2. 构建 Debug APK...${NC}"
./build.sh debug
echo ""

# 检查 APK 是否生成
APK_PATH="app/build/outputs/apk/debug/app-debug.apk"
if [ ! -f "$APK_PATH" ]; then
    echo -e "${RED}❌ APK 构建失败${NC}"
    exit 1
fi

APK_SIZE=$(ls -lh "$APK_PATH" | awk '{print $5}')
echo -e "${GREEN}✅ APK 构建成功！大小: $APK_SIZE${NC}"
echo ""

# 复制到网站目录
echo -e "${YELLOW}3. 部署到网站...${NC}"
WEB_DIR="/home/online-learning-platform/dist"
if [ -d "$WEB_DIR" ]; then
    cp "$APK_PATH" "$WEB_DIR/"
    echo -e "${GREEN}✅ APK 已复制到网站目录${NC}"
    echo ""
    echo "📱 下载地址:"
    echo "   http://www.52xuexi.art/app-debug.apk"
else
    echo -e "${RED}⚠️  网站目录不存在: $WEB_DIR${NC}"
    echo "   APK 位置: $(realpath $APK_PATH)"
fi

echo ""
echo "======================================"
echo -e "${GREEN}🎉 部署完成！${NC}"
echo "======================================"
echo ""
echo "📱 安装方法:"
echo "   1. 手机浏览器访问: http://www.52xuexi.art/app-debug.apk"
echo "   2. 下载并安装"
echo ""
echo "🔍 APK 信息:"
echo "   位置: $(realpath $APK_PATH)"
echo "   大小: $APK_SIZE"
echo ""

