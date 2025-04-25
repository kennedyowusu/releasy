# 📦 Releasy

**Releasy** is a developer-friendly CLI tool for Dart and Flutter projects that automates version bumping, Git tagging, and GitHub release creation. Built for developers who want to ship faster and smarter 🚀.

![Releasy CLI](https://img.shields.io/badge/dart-cli-blue?logo=dart&style=flat-square)
![MIT License](https://img.shields.io/badge/license-MIT-green.svg?style=flat-square)

---

## ✨ Features

- 🔖 Prompt for version (e.g. `v1.2.1`)
- 📝 Collect and attach markdown changelogs
- 📦 Auto-update `pubspec.yaml` with version + build number
- 🧠 Prevent unintentional releases with built-in checks:
  - Uncommitted changes
  - Unpushed commits
  - Duplicate tags
- 🏷️ Create annotated Git tags
- 🚀 Push tags and draft GitHub releases with title & notes

---

## 🚀 Usage

```bash
# Activate locally (in your Dart project root)
dart pub global activate --source path ./releasy

# Run it
releasy
```

You’ll be prompted to:

- Enter version and title
- Paste your changelog
- Confirm Git changes
- Automatically commit, tag, push, and draft a GitHub release

---

## 📸 Screenshot

> _A full CLI preview demo will go here when published._
> (You can add a `docs/cli-preview.png` and reference it)

---

## 🧪 Example Flow

```
📦 Releasy CLI — Your Dart Release Assistant
🔖 Enter release version: v1.2.1
📝 Enter release title: Update Loop Fix

✍️ Paste changelog below (Markdown). Press CTRL+D when done:

## What's New
- Fixed infinite update loop issue
- Improved release metadata from GitHub

✅ pubspec.yaml updated
✅ Git tag created
✅ GitHub release drafted
```

---

## 📂 File structure

```
releasy/
├── bin/                    # CLI entrypoint
│   └── releasy.dart
├── lib/                    # Core logic
│   └── releasy.dart
├── pubspec.yaml            # Dart package setup
├── README.md               # You're reading this
├── LICENSE                 # MIT licensed
```

---

## 🛡️ Requirements

- ✅ Git installed
- ✅ GitHub CLI (`gh`) installed and authenticated
  👉 [Install GitHub CLI](https://cli.github.com/)

---

## 👨🏽‍💻 About the Author

**Kennedy Owusu**
Frontend Engineer @ Kofa | Flutter, React & Laravel enthusiast
🔗 [kennedyowusu.com](https://kennedyowusu.com) · [GitHub](https://github.com/kennedyowusu)

---

## 📄 License

MIT © Kennedy Owusu
Free for personal and commercial use.

---

## ⭐️ Show Some Love

If you like it, star it ⭐ on GitHub. Contributions, issues, and PRs welcome!
