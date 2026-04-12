# Color Integration, Gradients, and Glow Effects

## CSS Variable Integration

For themed sites, derive animation colors from existing CSS variables so the animation adapts to any theme automatically.

```typescript
const style = getComputedStyle(document.documentElement);
const fg = style.getPropertyValue("--foreground").trim();
const muted = style.getPropertyValue("--muted-foreground").trim();
```

For static color (all characters the same), set `color` on the `<pre>` via CSS. For per-character color, you need `<span>` wrapping — but only apply it at the settled state. Wrapping every character in a span during cycling rebuilds hundreds of DOM nodes per frame. Use plain `textContent` during animation, then swap to `innerHTML` with spans for the final colored state.

## Gradient Color by Position

Assign color based on position for spatial gradients that feel three-dimensional.

```typescript
function rowColor(y: number, totalRows: number): string {
  const t = y / totalRows;
  const h = lerp(120, 280, t); // green at bottom -> purple at top
  const s = lerp(60, 40, t);
  const l = lerp(45, 70, t);
  return `hsl(${h}, ${s}%, ${l}%)`;
}
```

**HSL** is the right color space for hue interpolation — smooth, predictable gradients through the color wheel. For perceptually uniform gradients (where a "halfway" color actually looks halfway), use **OKLCH** instead.

## Color Cycling During Animation

Characters that are cycling (not yet settled) can shift hue over time for a shimmering effect. The Charm `mods` tool uses this — characters cycle through a gradient while also cycling through random glyphs, settling to both final character and final color simultaneously.

```typescript
function cyclingColor(elapsed: number): string {
  const hue = (elapsed * 0.1) % 360;
  return `hsl(${hue}, 50%, 65%)`;
}
```

Keep saturation and lightness moderate during cycling — the color shift should be a subtle shimmer, not a rave. The final settled color should be the most saturated/intentional.

## Radial Brightness Falloff (Glow)

A "glow" in ASCII is done by choosing brighter/denser characters near a focal point, fading to dimmer/sparser characters further away.

```typescript
const BRIGHTNESS = " ·.:-=+*#%@█";

function glowChar(dist: number, radius: number): string {
  const t = Math.max(0, 1 - dist / radius);
  const i = Math.floor(t * t * (BRIGHTNESS.length - 1)); // quadratic falloff
  return BRIGHTNESS[i];
}
```

Quadratic falloff (`t * t`) looks more natural than linear — concentrates brightness at the center and fades quickly.

## CSS Text Shadow for Glow

When the grid is settled and you've switched to span-per-character rendering, CSS `text-shadow` adds a real glow that ASCII alone can't achieve:

```css
.glow-char {
  text-shadow:
    0 0 4px currentColor,
    0 0 8px currentColor;
}
```

Apply sparingly — to focal characters, not the whole grid. A few glowing characters against a matte field is far more striking than everything glowing.

## Animated Glow via Noise

A single noise field moves across the grid, and characters "glow" (brighten, shift color, gain CSS shadow) as the noise wave passes. Creates the illusion of light playing across a surface.

```typescript
function glowIntensity(x: number, y: number, time: number): number {
  const n = simplex3(x * 0.08, y * 0.08, time * 0.03);
  return Math.max(0, n); // only positive values glow
}
```

Map intensity to opacity, text-shadow blur radius, or color shift. The movement of the noise field makes the glow feel alive without any character actually changing.

### Combining Glow with State Machines

The glow system works independently from the per-character state machine. During cycling/settling, characters use `textContent` rendering. After all characters settle, switch to span rendering and layer glow on top. This two-phase approach (animation phase -> glow phase) avoids the performance cost of per-character DOM nodes during the high-churn animation phase.
