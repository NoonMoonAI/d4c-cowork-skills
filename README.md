# D4C CoWork Skills

Claude skills and workflow instructions for the Design 4 Corners mood board production pipeline.

## What this is

This repo contains the `d4c-moodboard` Claude skill — a self-contained workflow assistant that guides Claude through the complete D4C mood board build process: image ingest, layout, title block, and output to PNG / PDF / layered PSD or Canva assets.

Designed for D4C designers who are new to Claude CoWork. Once installed, Claude handles all the technical work. The designer just answers a few questions and approves the preview.

## Install (one command)

```bash
curl -fsSL https://raw.githubusercontent.com/NoonMoonAI/d4c-cowork-skills/main/install.sh | bash
```

This installs the skill, Python dependencies (Pillow + psd-tools), and checks your Adobe plugin config.

## What you need first

1. **Claude CoWork** — the desktop app (ask your project lead for access)
2. **The D4C project folder** on your Desktop — should be at `~/Desktop/D4C_mood_boards:/` with the brand guidelines, templates, and fonts inside
3. **Python 3** — comes with macOS. The installer handles the rest.

## Using the skill

Open Claude CoWork. Type:

```
/d4c-moodboard
```

Claude will run a setup check, tell you what's ready, and ask what you need to build. Follow the prompts.

## Supported board types

| Type | What it is | When to use |
|------|-----------|-------------|
| **VIBES** | 10–14 images, no labels, editorial collage | Start of project — establish mood and direction |
| **CONCEPT** | 6–10 images + floor plan + design statement | Mid-project — specific room direction |
| **PLAN** | 6–10 product images + floor plan + labels | Late project — FF&E presentation |

## Output formats

- **Photoshop path:** PNG preview + PDF + layered PSD (one named layer per image)
- **Canva path:** PNG preview + PDF + folder of individual fitted images

Claude asks which you prefer at the start of every session.

## Project instruction files

The `project-instructions/` folder contains the full reference docs:

| File | Purpose |
|------|---------|
| `D4C_MoodBoard_CoWork_Instructions_v4.md` | Complete Phase 1–6 workflow |
| `D4C_MoodBoard_Specifications.md` | Layout rules, confirmed template geometry, algorithms |
| `D4C_Photoshop_Output.md` | PSD build recipe with working Python code |
| `D4C_Canva_Output.md` | Canva assets folder delivery |
| `D4C_CoWork_Setup_Guide.md` | Step-by-step new designer setup |

These are read by Claude automatically when you start a session. You don't need to open them.

## Updating

The skill checks for updates automatically. To manually update:

```bash
curl -fsSL https://raw.githubusercontent.com/NoonMoonAI/d4c-cowork-skills/main/install.sh | bash
```

## Requirements

- macOS (tested on macOS 14+)
- Python 3.9+
- Claude CoWork desktop app
- `pip3` (comes with Python)

## Maintainer

Nathan Myers / NoonMoonAI  
For D4C internal use and authorized designers only.
