# 发布到 GitHub

## 0. 准备

- GitHub 账号。
- Git（macOS 自带，或 `brew install git`）。
- 可选：GitHub CLI（`brew install gh`），后面创建仓库更快。

本目录已经在本地初始化好 Git，并完成首次提交。发布只需要创建远端仓库并 push。

## 1. 登录 GitHub

### 使用 GitHub CLI（推荐）

```bash
gh auth login
```

选择 `GitHub.com` → `HTTPS` → `Login with a web browser`，按提示完成授权。

### 或者使用 Git + Token

如果不用 `gh`，先在 GitHub 网页创建空仓库，然后：

```bash
git remote add origin https://github.com/<你的用户名>/<仓库名>.git
git branch -M main
git push -u origin main
```

Push 时用户名填 GitHub 用户名，密码填 **Personal Access Token**（不是账号密码）。

## 2. 创建仓库并发布

在项目根目录运行（把 `dsh-frame-id-photo` 换成你喜欢的仓库名）：

```bash
gh repo create dsh-frame-id-photo \
  --public \
  --source=. \
  --remote=origin \
  --push \
  --description "DeepSeek Harness 左侧工具栏证件照裁切插件"
```

完成后打开：

```text
https://github.com/<你的用户名>/dsh-frame-id-photo
```

## 3. 后续更新

```bash
git add .
git commit -m "feat: ..."
git push
```

## 4. 打一个 Release（可选）

```bash
git tag v1.0.0
git push origin v1.0.0
gh release create v1.0.0 --generate-notes
```

Release 页面可以附上 `dsh-plugin/` 目录的 zip 包，方便别人直接下载安装。

## 5. 让别人安装

别人 clone 后：

```bash
git clone https://github.com/<你的用户名>/dsh-frame-id-photo.git
cd dsh-frame-id-photo
node build-dsh-plugin.mjs
./install-dsh-plugin.sh
```

然后刷新 Harness。

## 6. 可选：GitHub Pages 在线预览

独立网页版在仓库根目录。进入仓库 **Settings → Pages**，选择 `Deploy from a branch`，分支选 `main`，目录选 `/ (root)`。GitHub 会发布：

```text
https://<你的用户名>.github.io/dsh-frame-id-photo/
```

这是独立网页版；DSH 左侧栏插件仍通过 `install-dsh-plugin.sh` 安装。

## 发布前检查

- `backup/`、`node_modules/`、`.DS_Store` 已被 `.gitignore` 忽略。
- 没有把 API Key、Token 或本机绝对路径提交进去。
- `screenshots/` 会随仓库公开，确认图片可以公开。
- README 中的仓库占位符 `<你的用户名>` 不需要改，最终链接由 GitHub 生成即可。
