# UX Flourishes

Short-lived animations that add personality to interfaces — progress bars, spinners, borders, logo reveals, typewriter text.

## Progress Bars

A progress bar is a 1D slice of the character grid. The interesting part is the leading edge.

```typescript
const BAR_CHARS = "░▒▓█";

function progressBar(width: number, progress: number): string {
  const filled = Math.floor(progress * width);
  let bar = "";

  for (let i = 0; i < width; i++) {
    if (i < filled - 1) {
      bar += "█";
    } else if (i === filled - 1) {
      // Animated leading edge: cycle through density chars
      bar += BAR_CHARS[Math.floor(Math.random() * BAR_CHARS.length)];
    } else {
      bar += "░";
    }
  }
  return `[${bar}]`;
}
```

A cycling character at the leading edge makes the bar feel alive. For extra polish, the 2-3 characters behind the leading edge can also flicker slightly, creating a "wake" effect.

## Loading Spinners

Classic spinner frames, but with character cycling between them:

```typescript
const SPINNER = ["⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏"];
let frame = 0;

setInterval(() => {
  process.stdout.write(`\r${SPINNER[frame++ % SPINNER.length]} Loading...`);
}, 80);
```

For richer spinners, use the **Braille set** (`⠀`-`⣿`) — each Braille character is a 2x4 dot matrix, giving you 256 possible patterns in a single character cell. You can encode tiny animations (rotating dots, filling patterns) within a single character position.

## Decorative Borders

A border that "draws itself" around a panel, a divider that assembles from its center outward, or a title that materializes character by character.

Use the per-character state machine from the core skill. Set delays so characters propagate outward from a starting point.

```typescript
// Self-drawing horizontal rule: center-out
const rule = "════════════════════════════";
const mid = Math.floor(rule.length / 2);

for (let i = 0; i < rule.length; i++) {
  const distFromCenter = Math.abs(i - mid);
  cells[i].delay = distFromCenter * 20; // 20ms per character from center
}
```

For a box border, start from one corner and propagate along both edges simultaneously, or start from the center of each side and extend outward.

## Logo Animations

Company logos rendered in ASCII, materializing from noise. The approach:

1. Start with the logo grid, all cells blank.
2. Begin cycling all cells simultaneously with random characters (the whole field is "boiling").
3. Over 500-800ms, cells settle one by one in a shuffled (random) order.
4. The logo appears to crystallize from static — recognizable shapes emerge from chaos.

For a more directional reveal, combine shuffled order with a spatial bias: characters in the center of the logo have a higher probability of settling early, so the logo resolves from the inside out.

### Timing Guidelines

- **Cycling phase**: 200-400ms of pure randomization before any cells begin settling
- **Settling spread**: 400-800ms from first settle to last settle
- **Total duration**: 600-1200ms feels snappy without rushing

## Typewriter Effects

Characters appear one at a time, left to right, with optional cursor. The trick is variable delay per character:

```typescript
const CHAR_DELAY = 50;     // base ms per character
const SPACE_DELAY = 20;    // spaces are faster
const PUNCT_DELAY = 150;   // pause at punctuation

function typewriterDelay(char: string): number {
  if (char === " ") return SPACE_DELAY;
  if (".!?,:;".includes(char)) return PUNCT_DELAY;
  return CHAR_DELAY + (Math.random() - 0.5) * 20; // jitter
}
```

This mimics natural typing rhythm — humans don't type at a constant rate. Punctuation pauses especially sell the effect.

### Cursor Styles

- **Block cursor** (`█`): classic terminal feel
- **Underline** (`_`): lighter, less distracting
- **Blinking**: toggle visibility every 500-600ms after typing completes
- **Disappearing**: remove cursor 1-2s after the last character settles
