# 🐍 Easy Python Environment CLI Manager for Windows

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)  
[![License: PSFL](https://img.shields.io/badge/License-PSFL-blue.svg)](https://docs.python.org/3/license.html)

A powerful yet very simple and straigtforward CLI tool to create, manage, and activate Python virtual environments on Windows with a single command from anywhere in your system.


# 🚀 ManagePyEnvs
_A fun and friction-free CLI tool to create and delete Python virtual environments on Windows!_



## 🧼 Because Not All Windows Users Are Dirty!
Keep your development space spick and span with ManagePyEnvs—your environment janitor for Windows.
No more clutter, no more confusion: just clean, isolated Python environments at your fingertips!



## 🎯 Features

- 🐍 **Automatic Python Detection**  
  Scans your system (or lets you specify a custom path) for all installed `python.exe` executables.

- ⚡ **One-Step Environment Creation**  
  Name your environment, pick a storage folder, and let the script handle the rest using Python’s built-in `venv`.

- 🚦 **Instant Activation Shortcuts**  
  Automatically creates a `.bat` launcher in your Python directory and adds it to your `PATH`.  
  Activate environments from *anywhere*—no `cd` gymnastics needed!

- 🗑️ **Neat Deletion with Deletor**  
  Easily scans and removes your virtual environments and their activation shortcuts.

- 🎈 **Safe & User-Friendly**  
  Protects against overwrites, confirms actions clearly, and gracefully handles errors.



## 📖 How It Works

1. **🛠️ Select Mode**  
   On launch, choose **[1] Creator** or **[2] Deletor**.

2. **✨ Creator**  
   - **Scan**: Finds all Python versions on your PATH.
   - **List**: Displays Python versions (e.g. `Python 3.11.2`) and a "Custom" path option.
   - **Choose**: Pick a version or specify a custom path.
   - **Name & Store**: Give your environment a name and storage location (default: `%USERPROFILE%\Documents\PythonEnvs`).
   - **Create**: Sets up your environment via `python -m venv`.
   - **Shortcut**: Offers to create a handy activation `.bat` file, saved in your Python directory.

3. **🧹 Deletor**  
   - **Locate**: Finds environments in your specified root (default: `%USERPROFILE%\Documents\PythonEnvs`).
   - **List**: Shows all discovered environments clearly.
   - **Confirm**: You choose and confirm which environment to delete.
   - **Cleanup**: Removes environment files and activation shortcuts.



## 🚀 Installation & Usage

1. **📥 Download** `ManagePyEnvs.bat` to a location of your choice.
2. **🚀 Run** from any Command Prompt (or double-click):
   ```bat
   C:\> ManagePyEnvs.bat
   ```
3. **🎯 Follow prompts** to manage your environments!

**✨ Activate** your new environment instantly:
```bat
C:\> myenv         # runs generated shortcut
(myenv) C:\>       # environment activated!
```



## ⚙️ Technical Highlights

- **🐍 Dynamic Python Detection** with `where python` & version parsing.
- **🔄 Robust Variable Expansion** ensures reliable batch scripting.
- **📌 Smart PATH Integration** checks and updates environment PATH intelligently.
- **📁 Clean Metadata Management** keeps shortcut paths organized.
- **✅ Graceful Error Handling** catches common pitfalls early.



## 🤝 Contributing

Your contributions, issues, and ideas are always welcome!

1. Fork the repository 🍴
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request 📬



## 📄 License

This project is licensed under the **MIT License**.  
The Python Standard Library’s `venv` module is covered by the **PSF License**.
