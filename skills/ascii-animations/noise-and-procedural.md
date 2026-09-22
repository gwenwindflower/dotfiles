# Noise Fields and Procedural Generation

Noise is the foundation of organic-looking ASCII animation. From simple per-cell flicker to spatially coherent Perlin fields, noise controls how "alive" the grid feels.

## Procedural Flicker

The simplest noise: each frame, a small percentage of cells re-randomize. Creates a living, static-like texture.

- **5%** probability: gentle shimmer
- **15-20%**: active, buzzing texture
- **30%+**: chaotic boil

Flicker probability can vary spatially — higher in "active" regions, lower in calm areas — to direct the viewer's attention.

## Perlin / Simplex Noise Fields

For spatially coherent noise (smooth blobs of activity rather than uniform static), sample a 2D noise function at each cell's position.

```typescript
function noiseAt(x: number, y: number, t: number): number {
  return simplex3(x * 0.1, y * 0.1, t * 0.05);
}

const DENSITY = " .:-=+*#%@";

function noiseChar(value: number): string {
  const i = Math.floor(((value + 1) / 2) * (DENSITY.length - 1));
  return DENSITY[i];
}
```

### Animating Over Time

The `t` parameter creates flowing, organic movement. Offsetting `t` per row or column creates directional flow:

- **Smoke rising**: offset `t` by `-y * 0.1` so higher rows are "ahead" in the noise field
- **Water flowing**: offset `t` by `x * 0.05` for horizontal drift
- **Breathing/pulsing**: use `sin(t)` to modulate the noise scale, making patterns expand and contract

## Noise as a Modulator

Noise doesn't have to directly control character choice. It can modulate any property:

| Property | Application | Example |
| --- | --- | --- |
| Timing | Add `noise(x, y) * 200` to cell animation delay | Organic staggering in reveals |
| Color | Shift hue within a range per cell | Subtle color variation across the grid |
| Sway intensity | High-noise regions sway more | Pockets of activity in settled art |
| Density/visibility | Threshold noise to show/hide cells | Organic shapes, fog, clouds |
| Character weight | Map noise to density ramp position | Smooth visual gradients |

## Layered Noise

Combine multiple noise samples at different frequencies (octaves) for richer texture:

```typescript
function fractalNoise(x: number, y: number, t: number): number {
  let value = 0;
  let amplitude = 1;
  let frequency = 1;

  for (let octave = 0; octave < 4; octave++) {
    value += simplex3(x * 0.1 * frequency, y * 0.1 * frequency, t * 0.05) * amplitude;
    amplitude *= 0.5;   // each octave contributes less
    frequency *= 2;     // each octave is higher frequency
  }

  return value;
}
```

- **1 octave**: smooth, blobby shapes
- **2-3 octaves**: more detail, cloud-like
- **4+ octaves**: turbulent, smoky texture

## Domain Warping

Feed one noise field's output as the input coordinates to another noise field. Creates swirling, organic distortions:

```typescript
function warpedNoise(x: number, y: number, t: number): number {
  const warpX = simplex3(x * 0.05, y * 0.05, t * 0.02) * 4;
  const warpY = simplex3(x * 0.05 + 100, y * 0.05 + 100, t * 0.02) * 4;
  return simplex3((x + warpX) * 0.1, (y + warpY) * 0.1, t * 0.03);
}
```

The `+ 100` offset ensures the two warp fields sample from different regions of the noise space, avoiding correlated distortion.

## Practical Notes

- **Library choice**: any simplex/Perlin noise library works. For browser use, `simplex-noise` (npm) is small and fast. For Node/Deno, same package works.
- **Performance**: noise sampling is cheap per-cell but adds up at scale. For grids >5000 cells, consider sampling at half resolution and bilinearly interpolating, or caching the noise field and updating it every 2-3 frames instead of every frame.
- **Determinism**: seed the noise generator if you want reproducible animations (useful for testing or recorded demos).
