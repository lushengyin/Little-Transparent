#!/bin/bash

# =============================================================
# 小透明 打包脚本
# 用法: ./scripts/release.sh [版本号]
# 示例: ./scripts/release.sh 1.1.0
#
# 功能: 更新版本号 → 编译 Release → 打包 zip/dmg
# 打包产物输出到项目目录下的 dist/ 文件夹
# =============================================================

set -e

# ---- 配置 ----
PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PROJECT_NAME="Little Transparent"
SCHEME="Little Transparent"
XCODEPROJ="$PROJECT_DIR/Little Transparent.xcodeproj"
BUILD_DIR="/tmp/LittleTransparent-build"
DIST_DIR="$PROJECT_DIR/dist"
APP_NAME="Little-Transparent"

# ---- 版本号 ----
if [ -n "$1" ]; then
    NEW_VERSION="$1"
else
    # 自动递增补丁版本
    CURRENT_VERSION=$(defaults read "$PROJECT_DIR/Little Transparent/Info.plist" CFBundleShortVersionString 2>/dev/null || echo "1.0.0")
    IFS='.' read -r MAJOR MINOR PATCH <<< "$CURRENT_VERSION"
    NEW_VERSION="$MAJOR.$MINOR.$((PATCH + 1))"
    echo "当前版本: $CURRENT_VERSION"
    echo "自动递增到: $NEW_VERSION"
fi

echo ""
echo "========================================="
echo "  小透明 打包脚本"
echo "  版本: $NEW_VERSION"
echo "========================================="
echo ""

# ---- 1. 更新版本号 ----
echo "[1/5] 更新版本号到 $NEW_VERSION ..."
/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $NEW_VERSION" "$PROJECT_DIR/Little Transparent/Info.plist"
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $NEW_VERSION" "$PROJECT_DIR/Little Transparent/Info.plist"

if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' "s/MARKETING_VERSION: \".*\"/MARKETING_VERSION: \"$NEW_VERSION\"/" "$PROJECT_DIR/project.yml"
    sed -i '' "s/CURRENT_PROJECT_VERSION: \".*\"/CURRENT_PROJECT_VERSION: \"$NEW_VERSION\"/" "$PROJECT_DIR/project.yml"
fi
echo "完成"

# ---- 2. 重新生成 Xcode 项目 ----
echo ""
echo "[2/5] 重新生成 Xcode 项目 ..."
cd "$PROJECT_DIR"
xcodegen generate
echo "完成"

# ---- 3. 编译 Release ----
echo ""
echo "[3/5] 编译 Release 版本 ..."
rm -rf "$BUILD_DIR"
xcodebuild -project "$XCODEPROJ" -scheme "$SCHEME" -configuration Release clean build CONFIGURATION_BUILD_DIR="$BUILD_DIR" 2>&1 | tail -3

if [ ! -d "$BUILD_DIR/$PROJECT_NAME.app" ]; then
    echo "编译失败，未找到 app"
    exit 1
fi
echo "完成"

# ---- 4. 打包 ----
echo ""
echo "[4/5] 打包 zip 和 dmg ..."
mkdir -p "$DIST_DIR"

ZIP_PATH="$DIST_DIR/${APP_NAME}-v${NEW_VERSION}-macOS.zip"
DMG_PATH="$DIST_DIR/${APP_NAME}-v${NEW_VERSION}-macOS.dmg"

rm -f "$ZIP_PATH" "$DMG_PATH"

# 创建 zip
cd "$BUILD_DIR"
ditto -c -k --keepParent "$PROJECT_NAME.app" "$ZIP_PATH"
echo "  ZIP: $(ls -lh "$ZIP_PATH" | awk '{print $5}')"

# 创建 dmg
hdiutil create -volname "$PROJECT_NAME" -srcfolder "$BUILD_DIR/$PROJECT_NAME.app" -ov -format UDZO "$DMG_PATH" -quiet
echo "  DMG: $(ls -lh "$DMG_PATH" | awk '{print $5}')"

# ---- 5. 清理构建目录 ----
echo ""
echo "[5/5] 清理构建缓存 ..."
rm -rf "$BUILD_DIR"
echo "完成"

echo ""
echo "========================================="
echo "  打包完成！"
echo "  版本: v$NEW_VERSION"
echo "  输出目录: $DIST_DIR/"
echo "    - ${APP_NAME}-v${NEW_VERSION}-macOS.zip"
echo "    - ${APP_NAME}-v${NEW_VERSION}-macOS.dmg"
echo "========================================="
