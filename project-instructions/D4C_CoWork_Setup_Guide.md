# D4C CoWork — New Designer Setup Guide

This guide gets you from zero to building mood boards with Claude in about 10 minutes. Do this once per machine.

---

## Step 1 — Install the D4C Mood Board Skill

Skills are small instruction files that teach Claude your specific workflow. Copy this command into your terminal:

```bash
mkdir -p ~/.claude/skills/d4c-moodboard
curl -fsSL https://raw.githubusercontent.com/[D4C-REPO]/main/skills/d4c-moodboard/SKILL.md \
  -o ~/.claude/skills/d4c-moodboard/SKILL.md
```

> **Note for Nathan:** Replace `[D4C-REPO]` with the actual GitHub repo path once you've published it (e.g., `design4corners/claude-skills`). Until then, manually copy the SKILL.md from the project folder.

**Manual install (until the repo is live):**
```bash
mkdir -p ~/.claude/skills/d4c-moodboard
cp "/path/to/D4C_mood_boards:/D4C Moodboard_Claude Cowork Files/skills/d4c-moodboard/SKILL.md" \
   ~/.claude/skills/d4c-moodboard/SKILL.md
```

Once installed, you can type `/d4c-moodboard` in any Claude CoWork session to activate the full mood board workflow.

---

## Step 2 — Install the Adobe Plugin (for background removal)

This gives Claude access to Adobe's production-grade background removal — much cleaner than the fallback method.

1. Open Claude Code (CoWork)
2. Run: `/install adobe-for-creativity`
3. Or add this to your `~/.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "adobe-skills": {
      "source": {
        "source": "github",
        "repo": "adobe/skills"
      }
    }
  },
  "enabledPlugins": {
    "adobe-for-creativity@adobe-skills": true
  }
}
```

**Why you want this:** Phase 3 of the mood board workflow removes backgrounds from product shots. The Adobe MCP does this at Photoshop quality. The fallback (Python flood-fill) works but can leave fringing on complex images.

---

## Step 3 — Install Python Dependencies

Claude builds the board using Python. These two packages are required:

```bash
pip3 install pillow psd-tools
```

Verify:
```bash
python3 -c "import PIL, psd_tools; print('Ready')"
```

If you get an error, try `pip install` instead of `pip3`, or ask your IT setup person.

---

## Step 4 — Optional: Install the Banana Skill (AI Image Generation)

If a client's image collection has gaps — missing a kitchen shot, need a texture image — `banana` can generate one using AI.

```bash
# Banana requires the NanoBanana MCP server (needs a Google AI API key)
# Ask Nathan for the team API key before installing
```

Once configured, you can say "generate a warm neutral kitchen atmosphere image" and Claude will create one using the Gemini image model.

---

## Step 5 — Verify Your Setup

Open a new CoWork session and run:

```
/d4c-moodboard
```

Claude should respond by reading the project instruction files and running the dependency check. If it says "All Python dependencies ready" — you're set.

---

## What You Have After Setup

| What | How to use it |
|------|---------------|
| `/d4c-moodboard` skill | Type this at the start of any mood board session |
| Adobe background removal | Say "remove backgrounds" in Phase 3 — Claude uses Adobe automatically |
| `banana` AI images | Say "generate a [description] image" if you need to fill a gap |
| Full workflow | Just say "let's build a mood board for [client]" — Claude asks the right questions |

---

## The Folder Structure Claude Expects

Claude reads the project files from this location on your Desktop:

```
~/Desktop/D4C_mood_boards:/
├── D4C Brand Guildelines_Brand Book/
│   ├── Fonts/flux_architect/         ← Flux Architect font files
│   ├── Logos/                        ← D4C logo files
│   └── Moodboard Template/           ← Template PNGs
├── Project Instructions & References/ ← All the .md instruction files
└── [Client_Project_Name]/
    └── [image folders]
```

If your folder is in a different location, tell Claude at the start of the session: "The project folder is at [path]."

---

## Common First-Session Questions

**"Can I use Canva instead of Photoshop?"**
Yes. In Phase 2 Claude will ask which you prefer. The Canva path delivers a full-resolution PNG + a folder of individual images you can upload separately.

**"Do I have to know Python?"**
No. Claude writes and runs all the Python code. You just answer the questions and approve the preview.

**"What if it can't find my images?"**
Make sure your project folder is on your Desktop and matches the expected structure above. If it's somewhere else, just tell Claude the path at the start of the session.

**"The font looks wrong in the title block."**
The Flux Architect font files need to be in `D4C Brand Guildelines_Brand Book/Fonts/flux_architect/`. If they're missing, Claude will warn you and ask where to find them.

**"Can I change the layout after seeing the preview?"**
Yes — the PNG preview is shown before the PSD/PDF are generated. You can ask Claude to swap an image, change a row proportion, or adjust the title block text. It rebuilds in under a minute.

---

## Getting Help

If Claude seems confused or asks questions that don't make sense for the mood board workflow:
1. Type `/d4c-moodboard` to re-activate the skill context
2. Say "re-read the project instructions" — Claude will reload the .md files
3. If something is genuinely broken, flag it in the project Slack/email chain so the instructions can be updated
