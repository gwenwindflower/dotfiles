#!/usr/bin/env -S deno run --allow-env

/**
 * Converts $LS_COLORS environment variable to TOML format (rn mainly for yazi theming)
 *
 * Usage: deno run --allow-env lscolors_to_toml.ts
 */

type Color = ColorHex | ColorNamed;
type ColorHex = `#${string}`;
type ColorNamed =
  | "black"
  | "red"
  | "green"
  | "yellow"
  | "blue"
  | "magenta"
  | "cyan"
  | "gray"
  | "darkgray"
  | "lightred"
  | "lightgreen"
  | "lightyellow"
  | "lightblue"
  | "lightmagenta"
  | "lightcyan";

type Style = {
  fg?: Color;
  bg?: Color;
  bold?: boolean;
  underline?: boolean;
  blink?: boolean;
  blink_rapid?: boolean;
  reversed?: boolean;
  hidden?: boolean;
  crossed?: boolean;
};

const MODES = [
  "bold",
  "underline",
  "blink",
  "blink_rapid",
  "reversed",
  "hidden",
  "crossed",
] as const;

type Mode = (typeof MODES)[number];

const modes: Record<number, Mode> = {
  1: "bold",
  4: "underline",
  5: "blink",
  6: "blink_rapid",
  7: "reversed",
  8: "hidden",
  9: "crossed",
};

const fgColors: Record<number, ColorNamed> = {
  30: "black",
  31: "red",
  32: "green",
  33: "yellow",
  34: "blue",
  35: "magenta",
  36: "cyan",
  37: "gray",
  90: "darkgray",
  91: "lightred",
  92: "lightgreen",
  93: "lightyellow",
  94: "lightblue",
  95: "lightmagenta",
  96: "lightcyan",
};

const bgColors: Record<number, ColorNamed> = {
  40: "black",
  41: "red",
  42: "green",
  43: "yellow",
  44: "blue",
  45: "magenta",
  46: "cyan",
  47: "gray",
  100: "darkgray",
  101: "lightred",
  102: "lightgreen",
  103: "lightyellow",
  104: "lightblue",
  105: "lightmagenta",
  106: "lightcyan",
};

// Helper function to convert RGB to Hex
export function rgbToHex(r: number, g: number, b: number): ColorHex {
  return `#${[r, g, b].map((x) => x.toString(16).padStart(2, "0")).join("")}`;
}

// Generate the 256-color palette
function generate256ColorPalette(): Record<number, ColorHex> {
  const palette: Record<number, ColorHex> = {};

  // Generate the 6x6x6 color cube (colors 16-231)
  for (let r = 0; r < 6; r++) {
    for (let g = 0; g < 6; g++) {
      for (let b = 0; b < 6; b++) {
        const index = 16 + r * 36 + g * 6 + b;
        palette[index] = rgbToHex(
          r ? 55 + r * 40 : 0,
          g ? 55 + g * 40 : 0,
          b ? 55 + b * 40 : 0
        );
      }
    }
  }

  // Generate the grayscale spectrum (colors 232-255)
  for (let i = 0; i < 24; i++) {
    const shade = 8 + i * 10;
    const index = 232 + i;
    palette[index] = rgbToHex(shade, shade, shade);
  }

  return palette;
}

const palette = generate256ColorPalette();

// Function to convert ANSI code to style object
export function ansiCodeToStyle(code: string): Style {
  let style: Style = {};
  if (!code) {
    return {};
  }

  const parts = code.split(";").map((p) => parseInt(p, 10));

  for (let i = 0; i < parts.length; i++) {
    const part = parts[i];

    // 38 = foreground color
    if (part === 38) {
      // 5 = 256 color palette
      if (parts[i + 1] === 5) {
        const colorIndex = parts[i + 2];
        if (!isNaN(colorIndex)) {
          style.fg = palette[colorIndex] ?? "#ffffff";
          i += 2;
        }
      }
      // 2 = 24-bit RGB color
      else if (parts[i + 1] === 2) {
        const [r, g, b] = parts.slice(i + 2, i + 5);
        style.fg = rgbToHex(r, g, b);
        i += 4;
      }
    }
    // 48 = background color
    else if (part === 48) {
      // 5 = 256 color palette
      if (parts[i + 1] === 5) {
        const colorIndex = parts[i + 2];
        if (!isNaN(colorIndex)) {
          style.bg = palette[colorIndex] ?? "#ffffff";
          i += 2;
        }
      }
      // 2 = 24-bit RGB color
      else if (parts[i + 1] === 2) {
        const [r, g, b] = parts.slice(i + 2, i + 5);
        style.bg = rgbToHex(r, g, b);
        i += 4;
      }
    }
    // 0 = reset
    else if (part === 0) {
      style = {};
    }
    // Check for mode (bold, underline, etc.)
    else if (part in modes) {
      const mode = modes[part];
      style[mode] = true;
    }
    // Check for basic foreground color
    else if (part in fgColors) {
      style.fg = fgColors[part];
    }
    // Check for basic background color
    else if (part in bgColors) {
      style.bg = bgColors[part];
    }
  }

  return style;
}

type YaziPattern = { name: string; is?: string };

export function lsPatternToYazi(lsColorsPattern: string): YaziPattern {
  // Handle short special codes (di, ln, ex, etc.)
  if (lsColorsPattern.length < 3) {
    const patternMap: Record<string, YaziPattern | undefined> = {
      di: { name: "*/" },
      bd: { name: "*", is: "block" },
      cd: { name: "*", is: "char" },
      ex: { name: "*", is: "exec" },
      pi: { name: "*", is: "fifo" },
      ln: { name: "*", is: "link" },
      or: { name: "*", is: "orphan" },
      so: { name: "*", is: "sock" },
      st: { name: "*", is: "sticky" },
    };

    const mappedPattern = patternMap[lsColorsPattern];
    if (mappedPattern) {
      return mappedPattern;
    }

    // Unknown short pattern
    return { name: "" };
  } else {
    // Regular glob pattern (e.g., "*.ts", "Makefile")
    return { name: lsColorsPattern };
  }
}

// Parse LS_COLORS and convert to theme.toml content
export function convertLsColorsToToml(lsColors: string): string {
  const entries = lsColors.split(":");
  const rules = entries
    .map((entry) => {
      if (!entry || !entry.includes("=")) return null;

      const [pattern, codes] = entry.split("=", 2);

      const { name, is } = lsPatternToYazi(pattern);
      if (!name) return null;

      const style = ansiCodeToStyle(codes);
      const { fg, bg } = style;

      const ruleParts: string[] = [];
      ruleParts.push(`name = "${name}"`);
      if (is) ruleParts.push(`is = "${is}"`);
      if (fg) ruleParts.push(`fg = "${fg}"`);
      if (bg) ruleParts.push(`bg = "${bg}"`);
      for (const mode of MODES) {
        if (style[mode]) ruleParts.push(`${mode} = true`);
      }

      // Only produce a rule if there's more than just the name
      if (ruleParts.length > 1) {
        return `  { ${ruleParts.join(", ")} }`;
      } else {
        return null;
      }
    })
    .filter((rule): rule is string => rule !== null);

  return rules.join(",\n") + ",";
}

function main() {
  const lsColors = Deno.env.get("LS_COLORS");

  if (!lsColors) {
    console.error("Error: LS_COLORS environment variable is not set.");
    console.error(
      "Try running: eval $(dircolors) && deno run --allow-env ls-colors-to-toml.ts"
    );
    Deno.exit(1);
  }

  console.log("# Generated from LS_COLORS");
  console.log("# Add these rules to your yazi theme.toml under [rules]");
  console.log("");
  console.log("[rules]");
  console.log("prepend_rules = [");
  console.log(convertLsColorsToToml(lsColors));
  console.log("]");
}

if (import.meta.main) main();
