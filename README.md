# TicTacToe iOS — Build on Windows via GitHub Actions

Since Xcode only runs on macOS, this guide lets you build your iOS app for **free**
using GitHub's cloud Mac machines — no Mac needed on your end.

---

## Prerequisites

- A free [GitHub account](https://github.com)
- [Git for Windows](https://git-scm.com/download/win) installed on your PC

---

## Step-by-Step Setup

### 1. Create a GitHub Repository

1. Go to https://github.com/new
2. Name it `TicTacToe-iOS` (or anything you like)
3. Set it to **Private** (recommended) or Public
4. Click **Create repository**

---

### 2. Upload Your Project

Open **Git Bash** (installed with Git for Windows) and run:

```bash
# Navigate to your project folder
cd path/to/TicTacToe_iOS

# Copy the .github folder into your project root first!
# (copy the .github folder from this zip into TicTacToe_iOS/)

# Then initialize and push
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/TicTacToe-iOS.git
git push -u origin main
```

> Replace `YOUR_USERNAME` with your actual GitHub username.

---

### 3. Watch the Build Run

1. Go to your repository on GitHub
2. Click the **Actions** tab at the top
3. You'll see **"Build iOS TicTacToe"** running automatically
4. Click on it to watch the live logs
5. A green ✅ means your app compiled successfully!

If it fails, click the failed step to read the error log.

---

### 4. Trigger a Build Manually (Optional)

You don't have to push code every time.  
Go to **Actions → Build iOS TicTacToe → Run workflow** to trigger it manually.

---

## Project Structure Expected by the Workflow

```
TicTacToe_iOS/              ← your project root (push contents of this folder)
├── .github/
│   └── workflows/
│       └── ios-build.yml   ← the workflow file
├── TicTacToe.xcodeproj/
└── TicTacToe/
    ├── Controllers/
    ├── Models/
    ├── Views/
    └── Assets.xcassets/
```

> ⚠️ Make sure `TicTacToe.xcodeproj` is at the **root** of what you push,
> not inside a subfolder. The workflow looks for it there.

---

## What the Build Does

| Step | What happens |
|------|-------------|
| Checkout | Downloads your code on a cloud Mac |
| Select Xcode | Uses Xcode 15 (supports Swift 5, iOS 15+) |
| Build | Compiles your app for the iOS Simulator |
| Result | Green ✅ = your code is valid and compiles |

The simulator build requires **no Apple Developer account** and **no code signing**.

---

## Want a Real .ipa File to Install on a Device?

That requires an **Apple Developer account** ($99/year) and code-signing certificates.
The workflow file has commented-out steps for this — once you have a developer account,
open `ios-build.yml` and follow the comments to enable the `.ipa` export step.

Alternatively, use **[Codemagic](https://codemagic.io)** which has a free tier and
a guided UI for setting up signing without touching config files.

---

## Troubleshooting

**"No such file or directory: TicTacToe.xcodeproj"**  
→ Make sure you pushed from inside `TicTacToe_iOS/`, not from its parent folder.

**"xcode-select: error"**  
→ The Xcode version on the runner may have changed. Update the path in `ios-build.yml`
  by checking [available Xcode versions](https://github.com/actions/runner-images/blob/main/images/macos/macos-14-Readme.md).

**Build fails with a Swift error**  
→ Read the error in the Actions log — it will show the exact file and line number,
  just like a local Xcode build.
