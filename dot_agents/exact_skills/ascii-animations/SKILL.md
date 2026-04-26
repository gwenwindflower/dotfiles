---
name: ascii-animations
description: Build ASCII/Unicode animations: loading spinners, logo reveals, particle effects, terminal art. Covers character grids, frame loops, per-character state machines, ordering, performance. Use when designing any character-based visual animation.
---

# ASCII Animation Techniques

Patterns for building performant, beautiful ASCII/Unicode animations. Examples use TypeScript but every technique is language-agnostic.

## The Character Grid

Every ASCII animation reduces to a 2D grid of characters updated over time. Three representations, pick based on need:

```typescript
// Flat string — fastest for "write the whole frame at once"
let frame = rows.map((row) => row.join("")).join("\n");
pre.textContent = frame;

// 2D array — best for per-cell logic
const grid: string[][] = Array.from({ length: height }, () =>
  Array(width).fill(" "),
);

// 1D with stride — shader-like per-pixel operations
const cells = new Array(width * height).fill(" ");
const at = (x: number, y: number) => cells[y * width + x];
```

For DOM rendering, a single `<pre>` with one `textContent` assignment per frame is the gold standard — single reflow regardless of how many characters changed. Individual `<span>` per character collapses above ~500 elements.

## Frame Loops

`requestAnimationFrame` is the correct loop primitive. ASCII animations look better at 20-30fps than 60fps — the discrete nature of character changes reads as mechanical when updated too smoothly.

```typescript
const TARGET_MS = 1000 / 24;
let lastFrame = 0;
let animId = 0;

function loop(now: number) {
  if (now - lastFrame >= TARGET_MS) {
    lastFrame = now;
    updateGrid();
    render();
  }
  if (!settled) {
    animId = requestAnimationFrame(loop);
  } else {
    animId = 0;
  }
}

animId = requestAnimationFrame(loop);
```

The `if (!settled)` guard is critical — stop the loop entirely when done. A running rAF with an early-return check still costs a function call per frame forever. Zero the ID on settle so cleanup code can check `if (animId)` to know whether a loop is active.

## Lifecycle & Cleanup

The most common production performance bug with ASCII animations is **leaked rAF loops** — not the animation itself being expensive, but stale loops accumulating across page navigations or re-initializations.

### The problem

In SPA-style frameworks (Astro ClientRouter, React Router, Next.js, etc.), navigating away from a page doesn't necessarily destroy inline scripts or their closures. If the animation script runs again on re-entry without canceling the previous loop, you get multiple concurrent rAF callbacks. Each one updates the DOM independently — compounding frame cost and causing visible lag even after the animation has "finished."

The same applies to event listeners registered for replay/hide commands. Without cleanup, every re-initialization stacks new listeners.

### Return a cleanup function

Structure `initAnimation()` to return a teardown function. Call it before every re-init and on navigate-away:

```typescript
function initAnimation(): (() => void) | undefined {
  const el = document.getElementById("anim-target");
  if (!el) return;

  let animId = 0;

  function runLoop(timeOrigin: number) {
    function tick(now: number) {
      // ... update + render ...
      if (allSettled) {
        animId = 0;
        return;
      }
      animId = requestAnimationFrame(tick);
    }
    animId = requestAnimationFrame(tick);
  }

  runLoop(performance.now());

  function handleReplay() {
    if (animId) {
      cancelAnimationFrame(animId);
      animId = 0;
    }
    // ... reset state ...
    runLoop(performance.now());
  }

  window.addEventListener("anim-replay", handleReplay);

  // Return cleanup
  return () => {
    if (animId) {
      cancelAnimationFrame(animId);
      animId = 0;
    }
    window.removeEventListener("anim-replay", handleReplay);
  };
}
```

### Safe init wrapper

Prevent stacking by always tearing down before re-init:

```typescript
let cleanup: (() => void) | undefined;

function safeInit() {
  if (cleanup) {
    cleanup();
    cleanup = undefined;
  }
  cleanup = initAnimation();
}

safeInit();

// SPA navigation hook (Astro example — adapt for your router)
document.addEventListener("astro:after-swap", () => {
  if (window.location.pathname === "/") {
    safeInit();
  } else {
    if (cleanup) {
      cleanup();
      cleanup = undefined;
    }
  }
});
```

### Checklist

- rAF ID zeroed on natural settle (not just on cancel)
- Replay cancels any in-flight loop before starting a new one
- Event listeners for commands/interactions removed on teardown
- SPA navigate-away triggers teardown, not just navigate-to triggers init
- One `after-swap` / route-change listener, not one per `initAnimation()` call
- No `{ once: true }` on cleanup listeners unless you're sure they fire exactly once per lifecycle

## Charsets

Characters define the visual language. Useful palettes:

| Purpose              | Characters                    |
| -------------------- | ----------------------------- |
| Botanical / organic  | `·.,:;*+~'"`                 |
| Box drawing          | `│┤┐└┘├─┬┴┼╔╗╚╝═║`            |
| Dense / noisy        | `░▒▓█▄▀■□▪▫`                  |
| Dot density gradient | `.:-=+*#%@` (space to dense) |
| Sparkle / ethereal   | `·✦✧⋆˚°.`                     |
| Matrix / digital     | `ﾊﾐﾋｰｳｼﾅﾓﾆｻﾜﾂｵﾘ0123456789`    |

When cycling random characters before settling, pick from a charset visually similar to the final target. Cycling through box-drawing characters before settling on box-drawing looks intentional; cycling dense blocks before settling on a delicate dot looks like a glitch.

## Per-Character State Machines

The most versatile animation pattern: each cell gets its own state machine, decoupling timing from rendering.

```typescript
type CharState = {
  target: string; // final display character
  current: string; // current display character
  state: "blank" | "cycling" | "settling" | "settled";
  delay: number; // ms before animation starts
  cycleEnd: number; // timestamp: cycling -> settling
  settleEnd: number; // timestamp: settling -> settled
};
```

Frame update walks every cell, checks state against current timestamp, transitions as needed:

```typescript
function updateCell(cell: CharState, now: number, elapsed: number) {
  if (cell.state === "settled") return;

  if (cell.state === "blank" && elapsed >= cell.delay) {
    cell.state = "cycling";
    cell.cycleEnd = elapsed + randomBetween(CYCLE_MIN, CYCLE_MAX);
  }

  if (cell.state === "cycling") {
    if (elapsed >= cell.cycleEnd) {
      cell.state = "settling";
      cell.settleEnd = elapsed + randomBetween(SETTLE_MIN, SETTLE_MAX);
      cell.current = cell.target;
    } else if (Math.random() < FLICKER_PROB) {
      cell.current = pickRandom(CYCLING_CHARS);
    }
  }

  if (cell.state === "settling" && elapsed >= cell.settleEnd) {
    cell.state = "settled";
    cell.current = cell.target;
  }
}
```

## Cell Ordering

The delay assigned to each cell determines the visual shape of the reveal — this is where most artistic expression lives.

**Distance from a point** — Radial bloom/ripple. Origin can be center (explosion), bottom-center (growing), top-left (typewriter), or arbitrary.

```typescript
const origin = { x: width / 2, y: height - 1 };
const maxDist = Math.hypot(width, height);
for (const cell of cells) {
  const dist = Math.hypot(cell.x - origin.x, cell.y - origin.y);
  cell.delay = (dist / maxDist) * BLOOM_SPREAD_MS + randomJitter();
}
```

**Row-by-row** — Bottom to top for growing, top to bottom for cascading. Simple and reliable.

**Shuffled** — Random order, no spatial logic. Good for "materializing from noise" effects.

**Density-aware** — Animate denser regions first, creating a bloom that follows the shape of the art rather than a geometric pattern.

## Jitter

Always add random jitter to delays. Without it, characters at the same distance animate in lockstep, which looks mechanical. Even +/-30ms breaks the regularity enough to feel organic.

```typescript
const jitter = (Math.random() - 0.5) * 2 * JITTER_MS;
cell.delay = baseDelay + jitter;
```

## Performance

### Lifecycle (highest impact)

The single biggest cause of animation-related lag is leaked loops, not expensive frames. See [Lifecycle & Cleanup](#lifecycle--cleanup) above. A single rAF loop updating a 500-cell grid at 24fps costs <1ms per frame. Two or three stacked loops doing the same work cause jank. Always verify with DevTools that exactly one rAF callback is active during animation and zero after settle.

### Rendering

For grids larger than ~2000 cells at 24+ fps:

- **`textContent` over `innerHTML`** during animation — 5-10x faster, skips HTML parsing
- **`contain: layout style paint`** on the container isolates the animation from page layout
- **Cap active cells** — track which cells actually changed per frame, only re-render if dirty count justifies it
- **Batch the final settle** — when switching from `textContent` animation to `innerHTML` with colored spans, do it in `requestIdleCallback` or a 0ms `setTimeout`

### Memory

- **Typed arrays for numeric state** — `Float32Array` or `Uint8Array` per property beats array-of-objects for memory locality on large grids (2000+ cells)
- **Avoid allocations in the hot loop** — build the frame string with `join()` on pre-existing arrays, don't create new arrays each frame

### Profiling

- **Profile in the slow path** — Chrome Performance tab with 4-6x CPU throttle reveals issues invisible on fast hardware
- **Check for stacking** — in DevTools Performance recording, look for multiple `requestAnimationFrame` callbacks per vsync. One is correct. More than one means leaked loops

## Reference Modules

Deep-dives for specific techniques. Load when the task calls for it:

- [Wave patterns, sway, and physics-based movement](wave-and-movement.md)
- [Color integration, gradients, and glow effects](color-and-glow.md)
- [Particle systems (fire, sparks, confetti)](particle-systems.md)
- [Full-screen compositing, parallax, and cellular automata](full-screen-and-compositing.md)
- [UX flourishes: progress bars, spinners, typewriter, borders](ux-flourishes.md)
- [Noise fields and procedural generation](noise-and-procedural.md)
