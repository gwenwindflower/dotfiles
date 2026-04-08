# Full-Screen Compositing, Parallax, and Cellular Automata

Techniques for animations that are the primary visual content — landing pages, art installations, music visualizers, demo-scene effects.

## Multi-Layer Compositing

Like Photoshop layers but with characters. Each layer is a full grid, and a compositing function merges them into a single output per frame.

```typescript
type Layer = {
  grid: string[][];
  opacity: number;  // 0-1, controls whether this layer's char wins
  zIndex: number;
  blend: "over" | "add" | "mask";
};

function composite(layers: Layer[], width: number, height: number): string[][] {
  const sorted = [...layers].sort((a, b) => a.zIndex - b.zIndex);
  const output = Array.from({ length: height }, () => Array(width).fill(" "));

  for (const layer of sorted) {
    for (let y = 0; y < height; y++) {
      for (let x = 0; x < width; x++) {
        const char = layer.grid[y]?.[x];
        if (!char || char === " ") continue;

        if (layer.blend === "mask") {
          output[y][x] = " ";  // clears output
        } else if (layer.blend === "add") {
          if (charDensity(char) > charDensity(output[y][x])) {
            output[y][x] = char;  // denser character wins
          }
        } else {
          if (Math.random() < layer.opacity) {
            output[y][x] = char;  // top layer wins probabilistically
          }
        }
      }
    }
  }
  return output;
}
```

**Example scene**: static landscape (layer 0), drifting fog from noise (layer 1, low opacity), falling rain (layer 2), occasional lightning flashes (layer 3, triggered by events).

## Character Density Mapping

Every printable character has an approximate visual "density" — how much of its cell it fills. The basis for ASCII art image conversion, and equally powerful for procedural animation.

```typescript
const DENSITY_RAMP =
  " `.-':_,^=;><+!rc*/z?sLTv)J7(|Fi{C}fI31tlu[neoZ5Yxjya]2ESwqkP6h9d4VpOGbUAKXHm8RD#$Bg0MNWQ%&@";

function charForDensity(t: number): string {
  const i = Math.floor(t * (DENSITY_RAMP.length - 1));
  return DENSITY_RAMP[Math.min(i, DENSITY_RAMP.length - 1)];
}
```

Map any continuous value (noise, distance, time) to this ramp for smooth visual gradients rendered entirely in characters. This is the bridge between procedural math and character output.

## Parallax Scrolling

Multiple layers scrolling at different speeds create depth. Closer layers scroll faster.

```typescript
const layers = [
  { art: farMountains,    speed: 0.2 },
  { art: nearHills,       speed: 0.5 },
  { art: foregroundTrees, speed: 1.0 },
];

function renderParallax(elapsed: number, viewWidth: number): string[][] {
  const output = Array.from({ length: height }, () => Array(viewWidth).fill(" "));

  for (const layer of layers) {
    const offset = Math.floor(elapsed * layer.speed * 0.01) % layer.art[0].length;
    for (let y = 0; y < height; y++) {
      for (let x = 0; x < viewWidth; x++) {
        const srcX = (x + offset) % layer.art[0].length;
        const char = layer.art[y]?.[srcX];
        if (char && char !== " ") {
          output[y][x] = char;
        }
      }
    }
  }
  return output;
}
```

Each layer wraps horizontally. The speed ratio between layers determines how strong the depth illusion is — a 5:1 ratio (foreground:background) creates strong depth, 2:1 is more subtle.

## Cellular Automata

Conway's Game of Life is the classic, but any CA rule can drive an ASCII animation. Bending the rules creates more interesting visual output than pure simulation.

```typescript
function automataStep(grid: string[][], rules: RuleSet): string[][] {
  const next = grid.map(row => [...row]);

  for (let y = 1; y < grid.length - 1; y++) {
    for (let x = 1; x < grid[0].length - 1; x++) {
      const neighbors = countActiveNeighbors(grid, x, y);
      const alive = grid[y][x] !== " ";

      if (alive && (neighbors < 2 || neighbors > 3)) {
        next[y][x] = " ";
      } else if (!alive && neighbors === 3) {
        next[y][x] = pickRandom(ORGANIC_CHARS);
      }
    }
  }
  return next;
}
```

### Feedback Loop Variation

Take the output of the previous frame, blur it (spread each character's influence to neighbors), and use that as input to the next frame. Creates organic, flowing patterns that evolve continuously — useful for ambient backgrounds and generative art.

## Responsive Scaling

For art that works across viewport sizes, compute grid dimensions at runtime.

**Scaling pre-authored art**: horizontal scaling drops every Nth column, vertical scaling drops every Nth row. For art with fine detail, author separate versions for breakpoints (like responsive images) rather than trying to algorithmically scale.

**Procedural art scales naturally** — generate at the target size. This is one of the strongest arguments for procedural approaches in responsive contexts.
