# Wave Patterns, Sway, and Physics-Based Movement

## Sway / Breathing

After a character reaches its target, a brief "sway" phase where it occasionally flickers to a nearby character creates a living, breathing feel. Distinct from cycling — cycling uses random characters from a wide charset, while swaying uses characters visually close to the target.

```typescript
const SWAY_NEIGHBORS: Record<string, string[]> = {
  "*": ["+", "·", "°"],
  "|": ["/", "\\", "¦"],
  "/": ["|", "\\"],
  "^": ["~", "¨"],
};

function swayChar(target: string): string {
  const neighbors = SWAY_NEIGHBORS[target];
  if (!neighbors || Math.random() > 0.1) return target;
  return neighbors[Math.floor(Math.random() * neighbors.length)];
}
```

The 0.1 probability means 90% of the time the character stays put — just enough movement to feel alive without distracting from the settled state.

## Wave Propagation

A traveling wave that moves through the grid, causing each cell to briefly react as it passes. Used in the Amp Code startup animation — a glow ripples outward from a central point.

```typescript
const WAVE_SPEED = 0.3; // cells per ms
const WAVE_WIDTH = 8;   // cells wide

function waveInfluence(cell: Cell, waveOrigin: Point, elapsed: number): number {
  const dist = Math.hypot(cell.x - waveOrigin.x, cell.y - waveOrigin.y);
  const waveFront = elapsed * WAVE_SPEED;
  const delta = Math.abs(dist - waveFront);

  if (delta > WAVE_WIDTH) return 0;
  return 1 - delta / WAVE_WIDTH; // 1 at wave center, 0 at edges
}
```

The influence value (0-1) can drive any visual property: brightness, character choice, color shift, or whether the cell is "active" at all. This makes waves composable — layer multiple waves from different origins for interference patterns.

### Tuning Waves

- **WAVE_SPEED** controls how fast the ripple expands. 0.1-0.3 for gentle ambient waves, 0.5-1.0 for dramatic bursts.
- **WAVE_WIDTH** controls how wide the active band is. Narrow (3-5) for sharp pulses, wide (10-20) for soft washes.
- **Multiple waves**: spawn a new wave on each user interaction, let them overlap. The combined influence at each cell is `Math.min(1, wave1 + wave2)`.

## Gravity and Physics

For falling/rising effects (snow, rain, particles from fire), simple physics per particle:

```typescript
type Particle = {
  x: number; y: number;
  vx: number; vy: number;
  char: string;
};

function updateParticle(p: Particle, dt: number) {
  p.vy += GRAVITY * dt;           // gravity pulls down
  p.vx += wind(p.y) * dt;         // optional: wind varies by height
  p.x += p.vx * dt;
  p.y += p.vy * dt;
}
```

Particles are plotted onto the grid by rounding positions to integer cells. When multiple particles land on the same cell, pick the one with the highest priority (or most recently updated).

### Wind Functions

Wind that varies by height creates natural-looking drift:

```typescript
function wind(y: number): number {
  // Stronger wind higher up, with some noise
  const base = Math.sin(y * 0.1) * 0.05;
  const gust = Math.sin(Date.now() * 0.001 + y * 0.3) * 0.03;
  return base + gust;
}
```

### Collision and Accumulation

For effects like snow accumulation, track the lowest empty cell in each column:

```typescript
const ground: number[] = Array(width).fill(height - 1);

function landParticle(p: Particle) {
  const col = Math.round(p.x);
  if (col >= 0 && col < width && Math.round(p.y) >= ground[col]) {
    grid[ground[col]][col] = p.char;
    ground[col]--;
  }
}
```
