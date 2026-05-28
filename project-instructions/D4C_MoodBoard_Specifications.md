# D4C Mood Board Specifications

---

## Confirmed Template Geometry

These coordinates are verified against the actual template PNG files. Use them directly — do not re-detect on every run.

### Template 1: CONCEPTVIBES (`Moodboard Template 1_CONCEPTVIBES.png`)
Used for: VIBES boards and CONCEPT boards

| Zone | Pixel Value | Notes |
|------|-------------|-------|
| Canvas width | 5100 | Landscape — width > height always |
| Canvas height | 3300 | |
| Content left (CX0) | 280 | Inner left border |
| Content top (CY0) | 200 | Just below VIBES rule at y=184 |
| Content right (CX1) | 4824 | Inner right border |
| Content bottom (CY1) | 2916 | Title block divider |
| Content width | 4544 | CX1 − CX0 |
| Content height | 2716 | CY1 − CY0 |
| Title block top | 2916 | Horizontal divider line |
| Title block bottom | 3169 | Inner bottom border |
| Title block height | 253 | |
| Right zone divider (TB_DIV_X) | 4003 | Vertical line separating center from client zone |
| Right zone left inset | 35 | From TB_DIV_X → text starts at x=4038 |
| Right zone right inset | 30 | From CX1 → text ends at x=4794 |
| Right zone MAX_W | 756 | 4794 − 4038 — fit_font() uses this |

### Template 2: CONCEPT (`Moodboard Template 2_CONCEPT.png`)
Coordinates: TBD — scan on first use and add here.

### Template 3: PLAN (`Moodboard Template #3_PLAN.png`)
Coordinates: TBD — scan on first use and add here.

**To scan a new template for the first time:**
```python
import numpy as np
from PIL import Image

arr = np.array(Image.open(TEMPLATE_PATH))
W, H = arr.shape[1], arr.shape[0]

# Find horizontal dark lines (full-width)
for y in range(H):
    if arr[y, 100:W-100].mean() < 100:
        dark_px = (arr[y, 100:W-100].mean(axis=1) < 100).sum()
        if dark_px > 1000:
            print(f"Horizontal line at y={y}")

# Find vertical dark lines
for x in range(W):
    if arr[200:H-200, x].mean() < 100:
        print(f"Vertical line at x={x}")
```
Record the results here before building.

---

## Canvas & Dimensions

| Property | Value |
|----------|-------|
| Board size | 17" × 11" (landscape, tabloid) |
| Resolution | 300 DPI |
| Pixel dimensions | 5100 × 3300 px |
| Background | White (#FFFFFF) |
| Border | 1px black (#000000) inset 20px from all edges |
| Content margin | 40px from border on all sides |
| Title block height | 140px from bottom border |

All measurements below are in pixels at 150 DPI.

**Blank template:** `Mood_Board_TEMPLATE_11x17.pdf` is included as project knowledge. Use it as the visual reference for title block proportions, border weight, and overall layout. You can either composite onto this template directly or recreate its structure programmatically.

---

## Title Block (All Board Types)

The title block occupies the bottom 140px of the content area, separated from the board content by a thin horizontal rule. The entire title block is divided into zones by vertical lines.

### Layout (left to right):

**Left zone (~35% of width):**
- D4C logo mark: geometric four-square diamond, ~45×45px
- Below logo: "DESIGN 4 CORNERS" — tracked caps, small
- To the right of logo (same zone):
  - "DESIGN 4 CORNERS" (company name, slightly larger, ALL CAPS)
  - 5315 Avenida Encinas, Carlsbad, CA 92008
  - 760.696.0502
  - www.design4corners.com
- The logo file is included as project knowledge: `Design-4-Corners_Logo.png` (full logo with text) and `Design_4_Corners_logo.jpeg` (mark only)

**Center zone (~25% of width):**
- Two rows separated by horizontal line:
  - Row 1: "TITLE" label (left) | [board title value] (right)
  - Row 2: "DATE" label (left) | [date value] (right)
- All text: ALL CAPS, clean sans-serif
- Some boards use "SCALE" and "UPDATE" instead of "DATE" — use whatever fields the designer specifies

**Right zone (~40% of width):**
- Client name: LARGE ALL CAPS, bold weight (e.g., "GLEESON" or "PERSALL RESIDENCE")
- Address line 1: street number and street name
- Address line 2: city, state, zip
- All text: ALL CAPS, **left-justified** — flush to the left edge of the zone. Do not center.
- If no client address provided, leave this zone with client name only

---

## Type 1: Furniture Plan Board

### Layout Structure

```
+----------------------------------------------------------+
|                                                          |
|  [Product Photo]   [Product Photo]    [Product Photo]    |
|   LABEL              LABEL              LABEL            |
|                                                          |
|  [Product    +---------------------------+  [Product     |
|   Photo]     |                           |   Photo]      |
|   LABEL      |      FLOOR PLAN           |   LABEL       |
|              |      (centered)           |               |
|  [Product    |                           |  [Product     |
|   Photo]     +---------------------------+   Photo]      |
|   LABEL                                     LABEL        |
|                                                          |
|  [Product Photo]   [Product Photo]    [Product Photo]    |
|   LABEL              LABEL              LABEL            |
|                                                          |
|  [TITLE BLOCK                                         ]  |
+----------------------------------------------------------+
```

### Rules
- Floor plan gets the largest allocation: ~40-50% of content area, centered
- Product photos arranged around the perimeter, roughly equal sizes
- Each product photo: 200-380px on longest side (scale proportionally based on number of images)
- Labels placed directly below each image, centered to image width
- Label text: ALL CAPS, 12px, sans-serif, medium weight, color #333333
- Spacing between images: minimum 20px
- If more than 8 product images: reduce individual image sizes proportionally
- If fewer than 4 product images: increase sizes to fill space naturally

### Image Placement Algorithm
1. Count total product images (excluding floor plan)
2. Floor plan centered in content area
3. Distribute product images in a ring around the floor plan:
   - Top row: up to 3 images
   - Left column: up to 2 images
   - Right column: up to 2 images
   - Bottom row: up to 3 images
4. Balance distribution — prefer symmetry but allow asymmetry if image count requires it

---

## Type 2: Concept Board

### Layout Structure

```
+----------------------------------------------------------+
|                                                          |
|  ROOM TITLE ————————                    [callout text]   |
|    subtitle (script)                                     |
|                                                          |
|  Design statement      [Floor plan    [Inspiration       |
|  paragraph             sketch]         photo 1]          |
|                                                          |
|  keyword 1 (script)    [Inspiration   [Inspiration       |
|  keyword 2 (script)     photo 2]       photo 3]          |
|  keyword 3 (script)                                      |
|                                                          |
|  [Color palette        [Inspiration   [Inspiration       |
|   swatches]             photo 4]       photo 5]          |
|                                                          |
|  [TITLE BLOCK                                         ]  |
+----------------------------------------------------------+
```

### Rules
- Left column (~25% width): text content + color palette
  - Room title: ALL CAPS, spaced tracking, 20px, sans-serif
  - Subtitle: script/italic font, 14px
  - Design statement: regular weight, 11px, max 200px wide, left-aligned
  - Style keywords: script/italic, 16px, stacked vertically with 8px spacing
  - Color palette: horizontal bars, each 160px × 24px, stacked with 6px gaps
- Right area (~75% width): images in collage layout
  - Mix of sizes: 1-2 large (hero) images + 3-5 smaller supporting images
  - Allow overlapping edges by 10-15px for collage feel
  - Floor plan sketch (if included): medium size, upper portion
- Material callout text: ALL CAPS, small (9px), positioned near relevant images
  - Example: "CONCRETE FLOORS" or "ACCENT FURNITURE: LEATHER, WOOD AND METAL"

### Color Palette Extraction
When designer says "extract from images":
1. Sample all uploaded images
2. Run k-means clustering (k=5) on pixel colors
3. Sort by luminance (lightest to darkest)
4. Render as horizontal bars
5. Optionally include HEX values to the right of each bar (small text, #666666)

---

## Type 3: Vibes / Material Board

### Layout Structure

```
+----------------------------------------------------------+
|                                                          |
|  [img1]  [img2]    [img3]       [img4]  [img5]  [img6]  |
|                                                          |
|  [img7]       [img8]      [img9]      [img10]           |
|                                                          |
|          [img11]     [img12]      [img13]               |
|                                                          |
|  [TITLE BLOCK                                         ]  |
+----------------------------------------------------------+
```

### Rules
- NO labels on individual images
- Images fill the content area above the title block
- Layout is organic/asymmetric — NOT a rigid grid
- Mix 3 image sizes:
  - Large: ~450-600px on longest side (2-3 images)
  - Medium: ~250-400px (4-6 images)
  - Small: ~150-230px (2-4 images)
- Gaps between images: 12-20px (uniform per board)
- All images have clean square/rectangular edges
- Aim for visual balance: heavy items (large/dark images) distributed evenly
- Fill rate: ~85-90% of content area should be covered by images

### Placement Algorithm — Verified 3-Row Justified Layout

**Row height proportions (confirmed working):**
```
available_h = content_height - 2×MARGIN - 2×GAP
            = 2716 - 40 - 30 = 2646px  (Template 1)

Row 1 height = int(available_h × 0.30) = ~794px   ← supporting images
Row 2 height = int(available_h × 0.40) = ~1058px  ← ANCHOR images (tallest row)
Row 3 height = available_h − Row1 − Row2 = ~794px ← supporting images
GAP between rows = 15px
Top/bottom margin = 20px
```

**Image distribution (10 images):** 4 / 3 / 3 (anchors go in row 2)
**Image distribution (12 images):** 4 / 4 / 4
**Image distribution (14 images):** 5 / 4 / 5

**Justified row algorithm — fills content width exactly:**
```python
def layout_row(image_paths, row_h, content_w, gap=15):
    imgs     = [Image.open(p).convert('RGB') for p in image_paths]
    # Scale each image to row_h height; get natural widths
    nat_ws   = [max(1, int(img.width / img.height * row_h)) for img in imgs]
    # Scale all widths proportionally to fill content_w exactly
    img_area = content_w - gap * (len(imgs) - 1)
    scale    = img_area / sum(nat_ws)
    tws      = [int(w * scale) for w in nat_ws]
    tws[-1]  = img_area - sum(tws[:-1])   # absorb rounding in last image
    # Center-crop each image to its final (target_w, row_h)
    fitted   = [fit_image(img, tw, row_h) for img, tw in zip(imgs, tws)]
    return fitted, tws

def fit_image(img, tw, th):
    iw, ih = img.size
    scale  = max(tw / iw, th / ih)
    img    = img.resize((int(iw * scale), int(ih * scale)), Image.LANCZOS)
    nw, nh = img.size
    left   = (nw - tw) // 2
    top    = (nh - th) // 2
    return img.crop((left, top, left + tw, top + th))
```

This algorithm produces zero gaps at row edges and handles any aspect ratio mix. It is the confirmed correct method for VIBES boards.

---

## Typography

**Primary font:** Flux Architect — files at `D4C Brand Guildelines_Brand Book/Fonts/flux_architect/*.ttf`

Load Flux Architect TTFs at session start. If the font files are missing from that path, stop and ask the designer to confirm location before proceeding.

| Role | Primary | Fallback | Style |
|------|---------|----------|-------|
| Labels / Titles | Flux Architect Bold | Helvetica Neue, Arial | ALL CAPS, medium weight |
| Script / Keywords | Flux Architect Regular Italic | Georgia Italic, Times Italic | Italic, title case |
| Body text | Flux Architect Regular | Helvetica Neue Light, Arial | Regular weight |
| Title block info | Flux Architect Bold | Helvetica Neue, Arial | ALL CAPS, regular weight |

Letter-spacing for titles and labels: add 2-3px between characters for the tracked look.

---

## Color Reference

| Element | Color | HEX |
|---------|-------|-----|
| Background | White | #FFFFFF |
| Border | Black | #000000 |
| Label text | Dark charcoal | #333333 |
| Body text | Medium gray | #555555 |
| Title block text | Black | #1A1A1A |
| Title block lines | Medium gray | #AAAAAA |
| Palette swatch border | Light gray | #CCCCCC |

---

## D4C Logo Mark

Two logo files — use exact paths below. If files are missing, do not fabricate a placeholder. Ask the designer to confirm location.

1. **Full logo (use in title block):** `D4C Brand Guildelines_Brand Book/Logos/Design-4-Corners-Main_forweb.png` — geometric diamond mark + "DESIGN 4 CORNERS" text, transparent background.
2. **Mark only:** `D4C Brand Guildelines_Brand Book/Logos/Just the logo.jpeg` — diamond symbol alone, white background. Use only if the full logo file is unavailable.

Place the full logo in the left zone of the title block, scaled to fit within the allocated height (~100px tall). The logo's own text serves as the "DESIGN 4 CORNERS" label — do not duplicate it.

---

## Output Formats

Always produce PNG and PDF. The third deliverable depends on the designer's tool preference (ask in Phase 2):

| Format | Always? | Details |
|--------|---------|---------|
| PNG | ✓ | Full-resolution composite, 5100×3300. Present in chat first for review. |
| PDF | ✓ | `image.save(out, 'PDF', resolution=300)` — 17×11" at 300 DPI |
| Layered PSD | Photoshop path | See `D4C_Photoshop_Output.md` |
| Assets folder | Canva path | See `D4C_Canva_Output.md` |

Present PNG first. Accept revision requests and rebuild before delivering PSD/PDF/assets.

---

## Error Handling

- If fewer than 8 images provided for a VIBES board: ask for more before proceeding
- If more than 14 images provided for a VIBES board: trigger curation (see D4C_Curation_Guide.md)
- If more than 10 images provided for a CONCEPT or PLAN board: trigger curation
- If no floor plan provided for a CONCEPT or PLAN board: ask. Do not fabricate a stand-in unless designer explicitly says "fabricate for test."
- If image resolution is very low (<800px on longest side): warn the designer it may appear pixelated at 17×11" print size
- If font files are missing from `D4C Brand Guildelines_Brand Book/Fonts/flux_architect/`: stop and ask before proceeding
- If logo file is missing from `D4C Brand Guildelines_Brand Book/Logos/`: stop and ask. Do not use a geometric placeholder.
