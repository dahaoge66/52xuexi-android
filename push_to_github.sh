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
