# mpv-subtitle-load

Automatically load subtitles from:

Subs/
    movie/
        01.ass
        02.ass

## Features

- Automatically detects subtitle directory
- Loads all subtitles
- Lightweight

## Installation

Copy subtitle_load.lua to:

~/.config/mpv/scripts/

## Directory Layout

Movies/
    movie.mp4

Subs/
    movie/
        01.ass
        02.ass

## Configuration

Create:

~/.config/mpv/script-opts/subtitle_load.conf

Options:

### subtitle_folders

Type: string

Default: Subs

Function: The script will scan the folders in order until it finds the first one that exists.

Example:

```ini
subtitle_folders=Subs,subs
```
