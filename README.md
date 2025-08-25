# Pwsh Matrix Animation

Matrix Animation in your Terminal (cross-platform in PowerShell). With lots of rendering options below!

## Demo

Matrix in Unix Renderer (WinTerm) | Matrix in Windows Renderer (WinTerm)
--- | ---
![Animation](https://github.com/user-attachments/assets/ca0086ca-4406-436b-97d2-8e7acd31e911) | ![Animation](https://github.com/user-attachments/assets/38b35d4e-8e69-4e70-a631-3df72a97917d)
<!-- <img width="767" alt="Screenshot 2024-08-27 at 8 18 08 PM" src="https://github.com/user-attachments/assets/9242e402-442a-4a8b-98d9-5550c1b1c854"> -->

Matrix with Retro Effect in WinTerm |
--- |
![Image](https://github.com/user-attachments/assets/03e6b645-3f24-42fc-8472-81872f8c5ff9) |

_**Note:** Iterm2 is perfectly supported! This entire file is cross-platform!_

## Features

Written to be quite flexible, featuring:
- Cross-platform rendering systems (Switchable with `-Renderer [Windows, Unix]`)
  - Windows mode: Uses PowerShell's native console manipulation capabilities through `System.Management.Automation.Host` namespace. It utilizes `Place-BufferedContent` for precise character placement and supports Windows console color schemes.
  - Unix mode: Employs ANSI escape sequences for text positioning and coloring, providing compatibility with a wide range of Unix-based terminals. This mode offers more fine-grained color control, enabling smoother color transitions and a more vibrant "glow" effect for the leading characters.
- Adjustable sparsity of the matrix effect with `-Sparsity`
- Customizable animation speed with `-SleepTime`
- Option to use special characters for a **more authentic Matrix look** with `-SpecialChars` (works best with Unicode-compatible terminals)
- Debug mode for troubleshooting with `-Debug`
- Dynamic resizing to fit the terminal window

## Requirements

- PowerShell 5.1 or later (PowerShell Core 6.0+ recommended for cross-platform use)

## Usage

Run the script using PowerShell:

```powershell
Matrix.ps1 [[-Sparsity] <double>] [[-SleepTime] <int>] [[-Renderer] <string>] [-SpecialChars] [-Debug]
```

### Parameters
- `-Sparsity`: Density of the matrix effect (range: 0.0001 to 1, default: 0.1)
- `-SleepTime`: Animation speed in milliseconds (default: 50)
- `-Renderer`: Choose between "Windows" or "Unix" rendering (default: "Unix")
- `-SpecialChars`: Use special characters for a more authentic Matrix look
- `-Debug`: Enable debug mode for troubleshooting

### Examples

1. Run with default settings:
   ```powershell
   .\Matrix.ps1
   ```

2. Full feature demo:
   ```powershell
   .\Matrix.ps1 -SpecialChars -Sparsity 1 -Renderer Unix
   ```

3. Use Windows on old terminals (like `conhost`, `cmd`)
   ```powershell
   .\Matrix.ps1 -SleepTime 20 -Renderer Windows
   ```

### In case you've never setup powershell
- Run this: `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned` (Allows you to run powershell scripts)
- Cd to the path where you cloned this project
- Run `./Matrix.ps1`

## How It Works
The script creates a matrix-like animation by:
1. Generating random characters (including optional special characters)
2. Creating vertical lines of these characters
3. Animating the lines to fall down the screen
4. Adjusting colors to create a glowing effect

The animation adapts to the terminal window size and can handle window resizing.

## Known Issues
- Performance may vary depending on terminal and system specifications
- Some terminals may not support all color features

## License
[MIT License](LICENSE)

## Acknowledgements
Inspired by the iconic digital rain effect from "The Matrix" film series.
