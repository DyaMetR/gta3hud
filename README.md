# Grand Theft Auto 3D Universe HUD

![](https://img.shields.io/github/v/release/DyaMetR/gta3hud)
![](https://img.shields.io/steam/views/3068556242)
![](https://img.shields.io/steam/downloads/3068556242)
![](https://img.shields.io/steam/favorites/3068556242)
![](https://img.shields.io/github/issues/DyaMetR/gta3hud)
![](https://img.shields.io/github/license/DyaMetR/gta3hud)

This addon for Garry's Mod that ports over the Heads Up Display feature from Grand Theft Auto games of the PlayStation 2 era.

## Installation

### Steam Workshop

+   Go to the addon's [Steam Workshop page](https://steamcommunity.com/sharedfiles/filedetails/?id=3068556242) and **subscribe** to it.

### Legacy install

#### Cloning the repository

+   Go to your Garry's Mod `addons` folder.
+   Open a _terminal_.
+   `git clone git@github.com:DyaMetR/gta3hud.git`

#### Download latest release

+   **Download** the [latest release](https://github.com/DyaMetR/gta3hud/releases).
+   Go to your Garry's Mod `addons` folder.
+   Unzip the _downloaded `.zip` file_ there.

## How to use

Once installed you can find the options at:

`Build menu (Q by default) -> Utilities -> GTA 3D Universe HUD`

Here you can find the following options:

+   `Enabled` toggles the HUD entirely.
+   `Texture filtering` will soften texture edges.
+   `Scale` will resize the HUD.
+   `Allow minimap` will allow the radar background to be rendered.
    +   Uncheck it if you're experiencing performance issues. This will prevent any configuration from rendering the background.
+   `Quick HUD variant swap` will allow you to change HUD variants quickly. Beware: this will reset your current configuration!
+   The `Presets` list lets you to quickly swap between registered configuration presets.
+   `Open customization menu` will open the HUD properties menu, where you will be able to customize your HUD to your liking.
+   `Reset to default` will reset your configuration to default values.

## Console variables

| Variable                       | Default | Description                                                                           |
|--------------------------------|---------|---------------------------------------------------------------------------------------|
| gta3hud_superadminonly         | 1       | Restricts server configuration override capabilities to super admins only.            |
| gta3hud_showplayersonradar     | 1       | Allows players to see other nearby players on their radar.                            |
| gta3hud_showteamplayersonradar | 0       | Allows players to see team members on their radar. Regardless of distance.            |
| gta3hud_shownpcsonradar        | 1       | Allows players to see nearby NPCs on their radar.                                     |
| gta3hud_wantedsystem           | 1       | Enables the symbolic wanted system.                                                   |
| gta3hud_wantedsystempvponly    | 0       | Makes wanted system react exclusively to player versus player interactions.           |
| gta3hud_wantedsystemexpire     | 180     | How long it takes for a player that has stopped violence to lose their wanted status. |

## DarkRP console variables

### Server

| Variable                       | Default | Description                                                                           |
|--------------------------------|---------|---------------------------------------------------------------------------------------|
| gta3hud_darkrp_hidejob         | 0       | Hides the job/salary component on all players' screens.                               |
| gta3hud_darkrp_hidehitresult   | 0       | Does not play the 'Mission passed!' sequence when completing a hit.                   |

### Client

| Variable                       | Default | Description                                                                           |
|--------------------------------|---------|---------------------------------------------------------------------------------------|
| gta3hud_darkrp_showjob         | 1       | Shows the job/salary component.                                                       |
| gta3hud_darkrp_showhitresult   | 1       | Plays the 'Mission passed!' sequence when completing a hit.                           |

## Documentation

If you're interested in _developer documentation_ for your game mode or server, head to the [documentation page](https://github.com/DyaMetR/gta3hud/tree/main/DOCUMENTATION.md).
