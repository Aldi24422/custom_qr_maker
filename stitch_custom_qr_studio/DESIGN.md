# Design System: Precision & Ethereal Logic

## 1. Overview & Creative North Star
**Creative North Star: The Digital Architect**
This design system moves away from the "utility-tool" aesthetic of typical generators and toward a "high-end studio" experience. We are not just building a QR code maker; we are building a precision instrument. The system is defined by **Ethereal Logic**: a combination of rigid, mathematical spacing (Logic) and soft, glass-like textures (Ethereal). 

To break the "template" look, we utilize **Intentional Asymmetry**. For example, a heavy `display-lg` headline should be anchored on the left, balanced by a generous "void" of white space on the right, or a floating QR preview card that overlaps two different surface tiers. This system values the "silence" of the page as much as the content.

---

## 2. Colors & Surface Philosophy
The palette is rooted in a deep, authoritative Indigo (`primary`) and a sophisticated Teal (`secondary`). The goal is depth, not flatness.

*   **The "No-Line" Rule:** 1px solid borders are strictly prohibited for sectioning. To separate the "Generator" sidebar from the "Preview" canvas, use a shift from `surface` to `surface-container-low`. Boundaries are felt, not seen.
*   **Surface Hierarchy & Nesting:** Use the surface tiers to create physical depth. 
    *   **Background:** `surface` (#f8f9fa).
    *   **The Canvas:** `surface-container-lowest` (#ffffff) for the main workspace cards.
    *   **Interactive Modals:** `surface-container-high` to create a "lifted" feel.
*   **The "Glass & Gradient" Rule:** All hover states on interactive cards should utilize Glassmorphism. Apply a `backdrop-blur` of 12px with a 60% opacity fill of `surface-container-lowest`.
*   **Signature Textures:** For primary CTAs (e.g., "Download QR"), use a subtle linear gradient from `primary` (#24389c) to `primary_container` (#3f51b5) at a 135-degree angle. This adds a "jewel-like" quality that feels premium.

---

## 3. Typography: Editorial Authority
We use a dual-font strategy to balance character with readability.

*   **Display & Headlines (Manrope):** This is our "Editorial" voice. Manrope’s geometric yet warm curves provide a modern, high-fashion tech feel. Use `display-lg` for hero moments with tight letter-spacing (-0.02em).
*   **Body & Labels (Inter):** Inter is our "Functional" voice. It provides maximum legibility for complex settings like "Error Correction Level" or "Data Input."
*   **Hierarchy as Identity:** Use high contrast in scale. Pair a `headline-lg` title with a `label-md` uppercase subtitle in `on_surface_variant` to create an authoritative, organized hierarchy.

---

## 4. Elevation & Depth
We eschew traditional "box shadows" in favor of **Tonal Layering**.

*   **The Layering Principle:** A card containing the QR code should be `surface-container-lowest`. It sits on a workspace of `surface-container-low`. The 5-nit difference in hex value creates a "natural" edge.
*   **Ambient Shadows:** For floating elements (like a color picker popover), use a "Cloud Shadow": 
    *   `box-shadow: 0 20px 40px rgba(25, 28, 29, 0.06);` (using a tinted `on_surface` color).
*   **The "Ghost Border" Fallback:** If a divider is required for accessibility in data-heavy tables, use `outline-variant` at 15% opacity. It should be a suggestion of a line, not a hard stop.

---

## 5. Components

### Buttons
*   **Primary:** Gradient fill (`primary` to `primary_container`), `xl` (1.5rem) roundedness. No border.
*   **Secondary:** `surface-container-high` background with `on_secondary_container` text. High-polish glass effect on hover.
*   **Tertiary:** Ghost style. No background, `primary` text. Becomes `surface-container-low` on hover.

### The "QR Workspace" Card
*   The centerpiece of the UI. Must use `xl` (1.5rem) roundedness. 
*   **Style:** `surface-container-lowest` with a 4% `on_surface` "Ghost Border."
*   **Interaction:** On hover, the card should scale slightly (1.02x) and gain an Ambient Shadow.

### Input Fields & Controls
*   **Inputs:** Background should be `surface-container-highest`. On focus, the background shifts to `surface-container-lowest` with a 2px `primary` "underlight" (a border only on the bottom).
*   **Checkboxes/Radios:** Use `secondary` (#14696d) for "on" states to provide a professional teal accent that distinguishes functional choices from primary actions.

### QR Customization Chips
*   Use `md` (0.75rem) roundedness. 
*   Active state: `primary` background with `on_primary` text.
*   Inactive state: `surface-container-high` with no border.

---

## 6. Do's and Don'ts

### Do:
*   **Do** use asymmetrical padding. Give the top of a section 120px of space while the bottom has 80px to create a sense of upward "lift."
*   **Do** use `secondary` (Teal) for success states and confirmation icons to keep the palette sophisticated.
*   **Do** embrace "The Void." If a screen only has one input, let it sit in the center of a massive `surface` field.

### Don't:
*   **Don't** use black (#000000). Use `on_surface` (#191c1d) for all "black" text to maintain tonal softness.
*   **Don't** use 1px dividers to separate list items in the "History" tab. Use 12px of vertical white space and a subtle background shift on hover.
*   **Don't** use "Standard" blue. Stick strictly to the Sleek Indigo (`primary`) to avoid looking like a generic Bootstrap site.