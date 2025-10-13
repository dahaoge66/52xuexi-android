#!/bin/bash

echo "=========================================="
echo "  🚀 GitHub Actions自动设置工具"
echo "=========================================="

# 颜色定义
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 检查git是否安装
if ! command -v git &> /dev/null; then
    echo -e "${RED}❌ 错误: Git未安装${NC}"
    echo "请先安装Git: sudo apt install git"
    exit 1
fi

echo -e "${BLUE}📋 请提供以下信息:${NC}"
echo ""

# 获取用户信息
read -p "🔑 GitHub用户名: " GITHUB_USERNAME
read -p "📦 仓库名称 (默认: 52xuexi-android): " REPO_NAME
REPO_NAME=${REPO_NAME:-52xuexi-android}

read -p "📝 您的姓名 (用于Git配置): " USER_NAME  
read -p "📧 您的邮箱 (用于Git配置): " USER_EMAIL

echo ""
echo -e "${YELLOW}⚙️  开始设置...${NC}"

# 设置Git配置
echo "🔧 配置Git用户信息..."
git config --global user.name "$USER_NAME"
git config --global user.email "$USER_EMAIL"

# 进入项目目录
PROJECT_DIR="/home/learning-platform-android"
cd "$PROJECT_DIR" || { echo -e "${RED}❌ 项目目录不存在${NC}"; exit 1; }

# 初始化Git仓库
echo "📁 初始化Git仓库..."
if [ ! -d ".git" ]; then
    git init
fi

# 添加所有文件
echo "📄 添加项目文件..."
git add .

# 提交代码
echo "💾 提交代码..."
git commit -m "✨ 初始提交: 52学习Android项目

🎯 项目特性:
- Android WebView应用
- Material Design界面  
- 支持离线缓存
- 响应式设计
- GitHub Actions自动构建

🔧 技术栈:
- Kotlin + Android SDK
- WebView + JavaScript Bridge
- Gradle 4.4.1
- Android SDK 27

🚀 自动构建:
- Debug APK (测试版)
- Release APK (发布版)
- 自动签名和优化

📱 立即使用: https://52xuexi.art"

# 设置远程仓库
REPO_URL="https://github.com/$GITHUB_USERNAME/$REPO_NAME.git"
echo "🌐 连接远程仓库: $REPO_URL"

if git remote get-url origin &> /dev/null; then
    git remote set-url origin "$REPO_URL"
else
    git remote add origin "$REPO_URL"
fi

echo ""
echo -e "${GREEN}✅ Git设置完成!${NC}"
echo ""
echo -e "${BLUE}📋 下一步操作:${NC}"
echo ""
echo "1️⃣  创建GitHub仓库:"
echo "   🌐 访问: https://github.com/new"  
echo "   📦 仓库名: $REPO_NAME"
echo "   📝 描述: 52学习Android应用"
echo "   🔓 设为Public (启用免费Actions)"
echo ""
echo "2️⃣  推送代码到GitHub:"
echo -e "   ${YELLOW}cd $PROJECT_DIR${NC}"
echo -e "   ${YELLOW}git push -u origin main${NC}"
echo ""
echo "3️⃣  启用GitHub Actions:"
echo "   🌐 访问: https://github.com/$GITHUB_USERNAME/$REPO_NAME/actions"
echo "   ▶️  点击 'I understand my workflows, go ahead and enable them'"
echo "   🚀 点击 'Run workflow' 开始构建"
echo ""
echo -e "${GREEN}⏰ 构建时间: 5-10分钟${NC}"
echo -e "${GREEN}📥 构建结果: Actions页面底部的Artifacts区域${NC}"
echo ""

# 创建推送脚本
cat > push_to_github.sh << 'EOF'
#!/bin/bash
echo "🚀 推送代码到GitHub..."
git push -u origin main
if [ $? -eq 0 ]; then
    echo "✅ 推送成功!"
    echo "📱 访问GitHub Actions查看构建进度"
    echo "🌐 https://github.com/$(git remote get-url origin | sed 's/.*github.com[:/]\([^/]*\/[^/.]*\).*/\1/')/actions"
else
    echo "❌ 推送失败，请检查仓库是否已创建"
fi
EOF

chmod +x push_to_github.sh

echo -e "${YELLOW}💡 提示: 创建GitHub仓库后，运行 ./push_to_github.sh 自动推送代码${NC}"
echo ""
echo -e "${BLUE}📖 更多帮助:${NC}"
echo "   📚 完整指南: cat 🚀_GitHub_Actions_构建指南.md"
echo "   ⚡ 快速开始: cat ⚡_快速开始_GitHub_Actions.md"
echo ""
echo -e "${GREEN}🎉 设置完成! 现在去GitHub创建仓库并推送代码吧!${NC}"
