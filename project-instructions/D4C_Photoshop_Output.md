# D4C Mood Board — Photoshop Output Guide

Use this document when the designer's output format preference (Phase 2, question 6) is **Photoshop**.

Deliver three files:
1. `[PROJECT]_[BOARDTYPE]_[DATE].png` — full-resolution preview
2. `[PROJECT]_[BOARDTYPE]_[DATE].pdf` — client-ready delivery file
3. `[PROJECT]_[BOARDTYPE]_[DATE].psd` — layered file for Photoshop finishing

---

## Tool: psd-tools

Use `psd-tools` for PSD generation. ImageMagick is not reliably available on macOS without Homebrew. psd-tools is the confirmed working tool in this environment.

Install if needed: `pip3 install psd-tools`

**Do not use pytoshop.** Its group-folder records are rejected by Photoshop's strict parser and its compressors are broken.

---

## Layer Structure

Build layers bottom to top in this order:

```
Title-Block-Field-Values   ← RGBA transparent overlay, text only
SANCTUARY_LIFESTYLE_008    ← last image placed
...
SANCTUARY_LIFESTYLE_001    ← first image placed
Template-Reference         ← full template PNG (border, VIBES header, title block)
[PSD canvas background]    ← off-white fill (#FEFEFE), auto-created by PSDImage.new()
```

**Layer naming convention:** `[PROJECT]_[CATEGORY]_[###]`
- PROJECT = client name in CAPS (e.g., SANCTUARY, PERSALL)
- CATEGORY = LIFESTYLE / TEXTURE / PRODUCT / SWATCH / FLOORPLAN
- \### = zero-padded sequence within category
- ASCII only — no em-dashes, smart quotes, or diacritics

---

## PSD Build Recipe

```python
from PIL import Image, ImageDraw, ImageFont
from psd_tools import PSDImage
from psd_tools.constants import Compression

COMP = Compression.RLE   # Faster than ZIP for large layers; Photoshop reads both

# 1. Create canvas — off-white background prevents Photoshop opening as Gray/8
psd = PSDImage.new('RGB', (5100, 3300), color=(254, 254, 254))

# 2. Template layer — full 5100×3300 PNG at position (0, 0)
template_img = Image.open(TEMPLATE_PATH).convert('RGB')
psd.create_pixel_layer(template_img,
    name='Template-Reference', top=0, left=0, compression=COMP)

# 3. Image layers — each already fitted to its final (width, height)
#    x, y are the pixel coordinates of the top-left corner on the canvas
for fitted_img, x, y, layer_name in layers_info:
    psd.create_pixel_layer(fitted_img,
        name=layer_name, top=y, left=x, compression=COMP)

# 4. Title block text overlay — RGBA TRANSPARENT (not full white)
#    Only text pixels are opaque. Everything else is clear.
#    This is critical: a full-white RGB overlay at top will wipe the board.
text_overlay = Image.new('RGBA', (5100, 3300), (0, 0, 0, 0))
tdraw = ImageDraw.Draw(text_overlay)
tdraw.text((x_pos, y_pos), "CLIENT NAME", fill=(26, 26, 26, 255), font=font)
tdraw.text((x_pos, y_pos2), "ADDRESS LINE", fill=(26, 26, 26, 255), font=font)
# Convert to RGB for psd-tools (it accepts RGB; transparency is preserved via layer mask if needed)
# Simpler approach: just place on a crop of the title block zone, not the full canvas
text_crop = text_overlay.crop((TB_DIV_X, TB_Y0, CX1, TB_Y1)).convert('RGB')
psd.create_pixel_layer(text_crop,
    name='Title-Block-Field-Values',
    top=TB_Y0, left=TB_DIV_X, compression=COMP)

# 5. Save
psd.save(OUT_PSD)
```

**Critical: use a cropped text layer, not a full-canvas layer.**
Place the text overlay at `top=TB_Y0, left=TB_DIV_X` — not at (0, 0). This means the layer only covers the right zone of the title block, so it cannot accidentally obscure images even if blend modes change.

---

## Title Block Text Placement

Right zone coordinates (Template 1 — CONCEPTVIBES):
```
RZ_LEFT  = 4003 + 35 = 4038   # 35px inset from vertical divider
RZ_RIGHT = 4824 - 30 = 4794   # 30px inset from right border
MAX_W    = 4794 - 4038 = 756 px
TB_Y0    = 2916
TB_Y1    = 3169
tb_h     = 253 px
```

Always auto-size font to fit MAX_W. Never hardcode a size:
```python
def fit_font(text, font_path, max_w, start_size=100):
    size = start_size
    while size > 20:
        font = ImageFont.truetype(font_path, size)
        bb   = draw.textbbox((0, 0), text, font=font)
        if (bb[2] - bb[0]) <= max_w:
            return font
        size -= 2
    return ImageFont.truetype(font_path, 20)

f_client = fit_font("SANCTUARY LOT 5",           FONT_BOLD, MAX_W, start_size=100)
f_addr   = fit_font("RANCHO SANTA FE, CA 92067",  FONT_BOLD, MAX_W, start_size=60)
```

Vertically center text in the title block:
```python
line_heights = [draw.textbbox((0,0), t, font=f)[3] - draw.textbbox((0,0), t, font=f)[1]
                for t, f in lines]
total_text_h = sum(line_heights) + LINE_GAP * (len(lines) - 1)
text_y_start = TB_Y0 + (tb_h - total_text_h) // 2
```

---

## File Size and Timing Expectations

At 5100×3300 with 12 layers and RLE compression:
- PSD file size: ~65–90 MB — this is normal
- Save time: ~60–90 seconds — do not interrupt

If the save appears to hang past 3 minutes, something is wrong. Cancel and check for memory issues.

---

## Validation

After saving, re-open the PSD and assert before delivering:

```python
from psd_tools import PSDImage

check = PSDImage.open(OUT_PSD)
assert check.width == 5100 and check.height == 3300, "Canvas size mismatch"
assert str(check.color_mode) in ('ColorMode.RGB', 'RGB', '3'), f"Wrong color mode: {check.color_mode}"
layer_names = [l.name for l in check]
print(f"Layers ({len(layer_names)}): {layer_names}")
```

If color_mode is Gray/1: the off-white background trick failed. Set `color=(254, 254, 254)` — not `(255, 255, 255)` — in `PSDImage.new()`.

---

## PDF Generation

```python
board_png.save(OUT_PDF, 'PDF', resolution=300)
```

PIL's built-in PDF output is sufficient for client delivery. The resolution=300 parameter embeds correct DPI metadata for 17×11" print dimensions.

---

## What the Designer Does in Photoshop

When the designer opens the PSD they should expect:
- Board 80–90% finished — not a blank canvas, not a locked file
- Every image on its own named layer at the correct position
- Room to reposition 2–4 elements before considering it done
- Editable text via Type tool (retype any rasterized labels)

Typical adjustments (15–20 min): reposition 2–4 images, scale one or two, retype any labels, confirm title block fields.

---

## Delivery Note (include with every PSD)

> **D4C Mood Board — [BOARD TYPE] — [PROJECT NAME]**
> Board type: VIBES / CONCEPT / PLAN
> Build date: [DATE]
> Images placed: [N]
>
> **Files delivered:**
> - `[FILENAME].png` — full-resolution preview
> - `[FILENAME].pdf` — client-ready delivery
> - `[FILENAME].psd` — layered Photoshop file
>
> **To edit in Photoshop:**
> All text layers are rasterized. To change any title block text, delete the `Title-Block-Field-Values` layer and retype using the Photoshop Type tool.
> Font: Flux Architect Bold. Client name: ALL CAPS, ~70pt, tracked. Address: ALL CAPS, ~42pt.
> Font files: `D4C Brand Guildelines_Brand Book/Fonts/flux_architect/`
