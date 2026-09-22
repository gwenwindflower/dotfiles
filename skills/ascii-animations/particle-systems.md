# Particle Systems

For effects like fire, explosions, sparks, or confetti — fine-grained control over individual elements with position, velocity, and lifecycle.

## Particle Structure

```typescript
type Particle = {
  x: number; y: number;
  vx: number; vy: number;
  life: number;     // remaining frames
  maxLife: number;
  char: string;
};
```

The grid is cleared each frame and particles are plotted onto it by rounding positions to integer cells.

## Fire

Fire particles rise from a source, decelerate via air resistance, and drift with turbulence. Character changes as the particle ages — dense near the source, sparse as it fades.

```typescript
function spawnFireParticle(sourceX: number, sourceY: number): Particle {
  return {
    x: sourceX + (Math.random() - 0.5) * 3,
    y: sourceY,
    vx: (Math.random() - 0.5) * 0.3,
    vy: -(0.5 + Math.random() * 0.5), // rises
    life: 15 + Math.floor(Math.random() * 10),
    maxLife: 25,
    char: "█",
  };
}

function updateParticle(p: Particle): void {
  p.x += p.vx;
  p.y += p.vy;
  p.vy *= 0.98;                              // air resistance
  p.vx += (Math.random() - 0.5) * 0.1;       // turbulence
  p.life--;

  // Character changes as particle ages (dense -> sparse)
  const age = 1 - p.life / p.maxLife;
  if (age < 0.3) p.char = "█";
  else if (age < 0.5) p.char = "▓";
  else if (age < 0.7) p.char = "▒";
  else if (age < 0.85) p.char = "░";
  else p.char = "·";
}
```

Fire benefits from **columnar noise** — a vertical noise field that shifts horizontally over time, causing flames to lean and dance rather than rise straight up.

## Sparks and Explosions

High initial velocity, strong gravity, short life. Spawn a burst of particles from a single point with random directions.

```typescript
function spawnSpark(originX: number, originY: number): Particle {
  const angle = Math.random() * Math.PI * 2;
  const speed = 0.5 + Math.random() * 1.5;
  return {
    x: originX, y: originY,
    vx: Math.cos(angle) * speed,
    vy: Math.sin(angle) * speed,
    life: 5 + Math.floor(Math.random() * 8),
    maxLife: 13,
    char: "*",
  };
}
```

For explosions, spawn 20-50 sparks simultaneously. The `char` can shift from `*` to `·` to ` ` as life decreases.

## Confetti

Similar to sparks but with slower velocity, mild gravity, and horizontal drift. Use colorful characters and wider spread.

```typescript
const CONFETTI_CHARS = ["█", "▓", "▒", "░", "◆", "◇", "●", "○"];

function spawnConfetti(x: number, y: number): Particle {
  return {
    x, y,
    vx: (Math.random() - 0.5) * 2,
    vy: -(1 + Math.random() * 2),
    life: 30 + Math.floor(Math.random() * 20),
    maxLife: 50,
    char: CONFETTI_CHARS[Math.floor(Math.random() * CONFETTI_CHARS.length)],
  };
}
```

Confetti works well with per-particle color — assign a random hue at spawn and render each particle with its own `<span>` color in the final grid composite.

## Particle System Management

```typescript
class ParticleSystem {
  particles: Particle[] = [];
  
  spawn(factory: () => Particle, count: number) {
    for (let i = 0; i < count; i++) {
      this.particles.push(factory());
    }
  }

  update() {
    for (const p of this.particles) {
      updateParticle(p);
    }
    // Remove dead particles
    this.particles = this.particles.filter(p => p.life > 0);
  }

  render(grid: string[][]) {
    for (const p of this.particles) {
      const rx = Math.round(p.x);
      const ry = Math.round(p.y);
      if (ry >= 0 && ry < grid.length && rx >= 0 && rx < grid[0].length) {
        grid[ry][rx] = p.char;
      }
    }
  }
}
```

### Performance Notes

- Keep particle count under control — for fire, 100-200 active particles is plenty. For confetti bursts, cap at 50-80.
- Reuse particle objects from a pool rather than allocating/GCing each frame if you're running at high particle counts.
- The `filter` for dead particles creates a new array each frame. For hot paths, swap-remove dead particles in-place instead.
