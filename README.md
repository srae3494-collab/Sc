# RAEZHY VIOLENCE DISTRICT HD

**Version:** 2.1  
**Language:** Luau / Roblox Lua  
**Interface:** Dark futuristic UI with purple accents

A client-side visual utility for Roblox experiences that you own or are authorized to modify. It provides a customizable screen crosshair and local lighting presets.

> This project uses standard Roblox APIs and is intended to run as a `LocalScript`. It is not an executor script and does not include aim assist, ESP, hitbox modification, or gameplay automation.

## Features

### Crosshair Studio
- Toggle the crosshair on or off.
- Six selectable layouts: Neon Vortex, Cyber X, Precision, Tactical, Orbital, and Rainbow Star.
- Six color themes (Neon, Rainbow, Toxic, Fire, Ice, Royal) with a smooth, continuous color flow.
- Neon-tube look: colored body, white core, soft glow halo, and a thin dark outline for contrast on any background.
- Spinning gradient ring (arcs), orbiting dots, and a rotating star, plus a subtle breathing ring.
- Click bloom: the crosshair briefly expands and settles back (visual only).
- Optional center dot and outer ring.
- Adjustable size, gap, thickness, glow level, and opacity.

### HD Graphics Booster
- Local lighting presets: Low, Medium, High, and Ultra.
- Performance preset that disables the script's post-processing effects and global shadows.
- Restore the lighting values and post-effect enabled states captured when the script starts.

### Interface and configuration
- Draggable panel with mouse and touch input.
- Scrollable settings panel.
- Minimize and close controls.
- Save and load a configuration snapshot during the current session.
- Reset settings to defaults.
- Cleanup of the render and drag connections when the GUI is destroyed.

## Installation

1. Open your Roblox experience in **Roblox Studio**.
2. In **Explorer**, locate `StarterPlayer` → `StarterPlayerScripts`.
3. Insert a **LocalScript**.
4. Open `RAEZHY_VIOLENCE_DISTRICT_HD_V2_1.lua` and copy its full contents.
5. Paste the code into the LocalScript.
6. Press **Play** in Studio to test.

The script accesses `Players.LocalPlayer`, `PlayerGui`, `RunService`, and `Lighting`, so it must run on the client as a LocalScript. Do not place it in a server `Script`.

## Important limitations

- The graphics presets adjust local `Lighting` properties and add local post-processing effects. They do **not** increase texture resolution, change mesh detail, force a higher Roblox rendering quality level, or guarantee higher FPS.
- Visual results depend on the experience's lighting setup, device, and Roblox rendering settings.
- `Save Settings (this session)` stores an in-memory snapshot only. It does not persist after the session ends.
- The script is not confirmed compatible with third-party executors. Its supported setup is Roblox Studio in an experience you own or are authorized to modify.
- Test in a separate development place before using it in a live experience.

## Repository contents

```text
RAEZHY-VIOLENCE-DISTRICT-HD/
├── RAEZHY_VIOLENCE_DISTRICT_HD_V2_1.lua
├── README.md
├── CHANGELOG.md
├── LICENSE.txt
└── .gitignore
```

## Testing status

The source has been reviewed for its declared features and structure. It has **not** been runtime-tested in Roblox Studio across devices or experiences. Please report reproducible errors with:
- Roblox Studio version / platform.
- Steps to reproduce.
- Exact Output-window error text.
- A screenshot, if useful.

## Contributions and issue reports

Please include clear reproduction steps and avoid sharing private account information, credentials, or private game assets in public issues.

## Author

**RAEZHY**
