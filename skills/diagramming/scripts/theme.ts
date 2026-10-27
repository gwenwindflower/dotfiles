export type Mode = "light" | "dark";

export type RenderMode = Mode | "auto";

export type SemanticClass =
  | "accent"
  | "data"
  | "process"
  | "decision"
  | "good"
  | "warn"
  | "external";

export interface ClassStyle {
  fill: string;
  stroke: string;
  text: string;
  dash?: string;
}

export interface Palette {
  vars: Record<string, string>;
  classes: Partial<Record<SemanticClass, ClassStyle>>;
}

export interface Theme {
  primary: Mode;
  font: string;
  modes: Record<Mode, Palette>;
}

const frappe: Palette = {
  vars: {
    bg: "#303446",
    fg: "#c6d0f5",
    muted: "#b5bfe2",
    line: "#838ba7",
    surface: "#414559",
    "surface-alt": "#292c3c",
    border: "#737994",
    accent: "#babbf1",
    critical: "#e78284",
    error: "#e78284",
  },
  classes: {
    accent: { fill: "#414559", stroke: "#babbf1", text: "#c6d0f5" },
    data: { fill: "#414559", stroke: "#8caaee", text: "#c6d0f5" },
    decision: { fill: "#414559", stroke: "#e5c890", text: "#c6d0f5" },
    good: { fill: "#414559", stroke: "#a6d189", text: "#c6d0f5" },
    warn: { fill: "#414559", stroke: "#e78284", text: "#c6d0f5" },
    external: { fill: "#292c3c", stroke: "#737994", text: "#b5bfe2", dash: "4 3" },
  },
};

const dawn: Palette = {
  vars: {
    bg: "#faf4ed",
    fg: "#575279",
    muted: "#797593",
    line: "#9893a5",
    surface: "#f2e9e1",
    "surface-alt": "#fffaf3",
    border: "#cecacd",
    accent: "#907aa9",
    critical: "#b4637a",
    error: "#b4637a",
  },
  classes: {
    accent: { fill: "#f2e9e1", stroke: "#907aa9", text: "#575279" },
    data: { fill: "#f2e9e1", stroke: "#56949f", text: "#575279" },
    decision: { fill: "#f2e9e1", stroke: "#ea9d34", text: "#575279" },
    good: { fill: "#f2e9e1", stroke: "#286983", text: "#575279" },
    warn: { fill: "#f2e9e1", stroke: "#b4637a", text: "#575279" },
    external: { fill: "#fffaf3", stroke: "#9893a5", text: "#797593", dash: "4 3" },
  },
};

export const theme: Theme = {
  primary: "dark",
  font: "sans-serif",
  modes: { dark: frappe, light: dawn },
};
