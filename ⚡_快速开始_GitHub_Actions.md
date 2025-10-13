# ⚡ GitHub Actions 快速开始 - 3分钟构建APK

## 🎯 超简单3步骤

### 步骤1：创建GitHub仓库 (1分钟)
1. 访问 https://github.com
2. 点击右上角 `+` → `New repository`
3. 填写信息：
   - **Repository name**: `52xuexi-android`
   - **Description**: `52学习Android应用`
   - **Public** ✅ (必须公开才能使用免费Actions)
4. 点击 `Create repository`

### 步骤2：上传项目 (1分钟)
两种方式任选一种：

#### 方式A：直接上传文件 📁
1. 下载: http://52xuexi.art/52学习-Android项目-完整版.tar.gz
2. 解压后，拖拽所有文件到GitHub仓库页面
3. 填写提交信息: `初始化52学习Android项目`
4. 点击 `Commit changes`

#### 方式B：使用命令行 💻
```bash
cd /home/learning-platform-android
git init
git add .
git commit -m "初始化项目"
git remote add origin https://github.com/你的用户名/52xuexi-android.git
git push -u origin main
```

### 步骤3：启动自动构建 (1分钟)
1. 进入你的仓库页面
2. 点击 `Actions` 标签
3. GitHub检测到workflow，点击 `I understand my workflows, go ahead and enable them`
4. 点击 `构建52学习Android APP` → `Run workflow` → `Run workflow`

## ✅ 完成！

**5-10分钟后**，你将获得：
- ✅ **调试版APK**: `52学习-debug.apk` (用于测试)
- ✅ **发布版APK**: `52学习-release.apk` (用于分发)

## 📥 下载APK

构建完成后：
1. 在Actions页面找到绿色✅的构建记录
2. 点击进入详情页面
3. 滚动到底部 `Artifacts` 区域
4. 下载APK文件

## 🎊 就是这么简单！

**每次你修改代码并提交，GitHub会自动构建新的APK！**

---

### 💡 小贴士
- 构建过程全自动，无需任何手动操作
- 每个月有2000分钟免费构建时间
- 支持同时构建多个版本
- APK会自动优化和压缩

### 🆘 需要帮助？
查看完整指南：`🚀_GitHub_Actions_构建指南.md`
