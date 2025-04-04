# 🐍 Python Environment Creator for Windows

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)  
[![License: PSFL](https://img.shields.io/badge/License-PSFL-blue.svg)](https://docs.python.org/3/license.html)

A powerful yet simple tool to create, manage, and activate Python virtual environments on Windows with a single command from anywhere in your system.

## 🚀 Features

- **Automatic Python Detection**: Scans your system for all installed Python versions  
- **Environment Organization**: Creates environments in a structured directory  
- **Command Line Shortcuts**: Generates custom activation commands that work from anywhere  
- **PATH Management**: Automatically handles PATH updates for seamless environment activation  
- **User-Friendly Interface**: Simple prompts guide you through the entire setup process  
- **Existing Environment Detection**: Prevents accidental overwriting of existing environments  

## 📋 How It Works

When you run `create_venv.bat`:

1. The script locates all Python installations on your system  
2. You select which Python version to use (or specify a custom path)  
3. You name your environment and choose where to store it  
4. The script creates the virtual environment using Python's built-in `venv` module  
5. A command shortcut is created in your selected Python directory 
6. This shortcut is automatically added to your PATH when used  

## 🛠️ Usage

### Creating a New Environment

1. **Download and run** `create_venv.bat`  
2. **Select** a Python version from the displayed list  
3. **Enter** a name for your environment  
4. **Specify** a storage location (or accept the default)  
5. **Decide** whether to create a command line shortcut  

### Activating Your Environment

After setup, you can activate your environment from any command prompt:

```bash
C:\Users\YourName> dataproject
(dataproject) C:\Users\YourName>
```

Your prompt will change to indicate the active environment, and `python` and `pip` commands will now use the environment's versions.

## 💡 Value Added

This tool solves several common issues with Python environment management on Windows:

- No more complex PATH navigation: Activate your environment from any directory  
- Consistent environment naming: Keep track of your environments easily  
- Cross-terminal compatibility: Works in Command Prompt, PowerShell, and other terminals  
- Self-contained shortcuts: Each environment has its own activation command  

## 🔮 Future Vision: Python Environment Manager

This tool is a first step toward a complete Python environment management solution for Windows (Feel free to contact me and to contribute):

- Environment listing: View all created environments  
- Package management: Install, update, and remove packages across environments  
- Environment cloning: Quickly duplicate environments with the same packages  
- Requirements management: Import/export environment specifications  
- Integration with IDEs: Seamless connection to popular development tools  
- Graphical interface: Optional GUI for visual environment management  

## 📚 Dependencies

This project utilizes Python's built-in `venv` module, which is part of the Python Standard Library.

## 📄 License

This project is licensed under the [MIT License](https://opensource.org/licenses/MIT).  
The `venv` module is licensed under the [Python Software Foundation License (PSFL)](https://docs.python.org/3/license.html).

## 🤝 Contributing

Your contributions are welcome! Feel free to fork, modify, and submit pull requests to enhance this tool.
