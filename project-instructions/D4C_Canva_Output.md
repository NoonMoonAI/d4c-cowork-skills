# D4C Mood Board — Canva Output Guide

Use this document when the designer's output format preference (Phase 2, question 6) is **Canva**.

Deliver three things:
1. `[PROJECT]_[BOARDTYPE]_[DATE].png` — full-resolution composite (the board, finished)
2. `[PROJECT]_[BOARDTYPE]_[DATE].pdf` — client-ready delivery file
3. `[PROJECT]_[BOARDTYPE]_[DATE]_canva_assets/` — folder of individual fitted images for Canva re-composition

---

## When to Use This Path

A Canva-path designer typically wants to:
- Upload the composite PNG directly as a finished board (most common)
- OR re-build the layout in Canva natively using individual assets (less common, but possible)

Ask in Phase 2: "Do you want just the composite PNG, or also individual assets for Canva?"

If they want just the PNG: deliver PNG + PDF. No assets folder needed.
If they want the assets folder: follow the full process below.

---

## What the Assets Folder Contains

Each fitted image exported at its final cropped size, named with its position on the board:

```
[PROJECT]_[BOARDTYPE]_[DATE]_canva_assets/
├── 001_LIFESTYLE_r1_x280_y220.jpg        (row 1, position 1)
├── 002_LIFESTYLE_r1_x1420_y220.jpg
├── 003_LIFESTYLE_r1_x2560_y220.jpg
├── 004_TEXTURE_r1_x3660_y220.jpg
├── 005_LIFESTYLE_r2_x280_y1033.jpg       (row 2 / anchors)
├── 006_LIFESTYLE_r2_x1791_y1033.jpg
├── 007_LIFESTYLE_r2_x3295_y1033.jpg
├── 008_LIFESTYLE_r3_x280_y2106.jpg       (row 3)
├── 009_TEXTURE_r3_x1695_y2106.jpg
├── 010_LIFESTYLE_r3_x2806_y2106.jpg
└── _layout_reference.png                 (thumbnail of the composite for reference)
```

**Naming convention:** `[sequence]_[CATEGORY]_r[row]_x[left]_y[top].jpg`

The x/y coordinates in the filename are the pixel positions on the 5100×3300 canvas. The designer can use these as a reference when manually placing images in Canva.

---

## Exporting the Assets Folder

```python
import os

assets_dir = f"{OUT_DIR}/{PROJECT}_{BOARD_TYPE}_{DATE}_canva_assets"
os.makedirs(assets_dir, exist_ok=True)

# Save each fitted image using its layer info
for seq, (fitted_img, x, y, layer_name) in enumerate(layers_info, start=1):
    cat = layer_name.split('_')[1]   # LIFESTYLE, TEXTURE, etc.
    row = 1 if y < row2_y else (2 if y < row3_y else 3)
    filename = f"{seq:03d}_{cat}_r{row}_x{x}_y{y}.jpg"
    fitted_img.save(os.path.join(assets_dir, filename), 'JPEG', quality=92)

# Save layout reference thumbnail
thumbnail = board.resize((1020, 660), Image.LANCZOS)
thumbnail.save(os.path.join(assets_dir, '_layout_reference.png'))

print(f"Assets folder: {assets_dir}")
print(f"  {len(layers_info)} image files + 1 layout reference")
```

---

## How the Designer Uses This in Canva

**Option A — Upload the composite PNG (most common):**
1. Create a new Canva design at 17×11" (or upload and resize)
2. Upload `[PROJECT]_[BOARDTYPE]_[DATE].png`
3. Set it as the full-bleed background or center it on the canvas
4. Board is complete — no assembly needed

**Option B — Re-compose in Canva using individual assets:**
1. Create a new Canva design at 5100×3300px (or 17×11" at 300 DPI)
2. Upload all images from the `_canva_assets/` folder
3. Use `_layout_reference.png` as a visual guide for placement
4. Position each image using the x/y coordinates in the filename
5. Add a text box for the title block fields using Canva's text tools

**Canva text note:** Canva does not have Flux Architect installed by default. The designer will need to upload the font via Canva's Brand Kit (Settings → Brand Kit → Upload a font). Font files are in `D4C Brand Guildelines_Brand Book/Fonts/flux_architect/`.

---

## Limitations vs. Photoshop

| | Photoshop | Canva |
|---|---|---|
| Per-image layers | ✓ Named, moveable | ✗ Must place manually |
| Text editability | Rasterized (retype to edit) | ✓ Live text boxes |
| Font control | Flux Architect loaded | Requires Brand Kit upload |
| Precision repositioning | Pixel-exact | Approximate |
| Client PDF export | ✓ Print-ready | ✓ Download as PDF |
| Best for | Final layout control | Quick delivery, lightweight editing |

---

## PDF Generation

Same as Photoshop path:
```python
board_png.save(OUT_PDF, 'PDF', resolution=300)
```

---

## Delivery Note (include with Canva delivery)

> **D4C Mood Board — [BOARD TYPE] — [PROJECT NAME]**
> Board type: VIBES / CONCEPT / PLAN
> Build date: [DATE]
> Images placed: [N]
>
> **Files delivered:**
> - `[FILENAME].png` — composite board, ready to upload to Canva
> - `[FILENAME].pdf` — client-ready delivery
> - `[FILENAME]_canva_assets/` — individual images for Canva re-composition (if requested)
>
> **To use in Canva:**
> Upload the PNG directly as a finished board, or use the individual assets to re-compose.
> See `_layout_reference.png` in the assets folder for placement guidance.
> To edit title block text: use Canva's text tool. Font: Flux Architect Bold (upload via Brand Kit if not already installed). ALL CAPS, tracked.
