import { type Mode, type Palette, type RenderMode, theme } from "./theme.ts";

export interface ClassSelectors {
  shape: (cls: string) => string;
  text: (cls: string) => string;
}

export function classRules(palette: Palette, selectors: ClassSelectors): string {
  return Object.entries(palette.classes).map(([name, style]) => {
    const dash = style.dash ? `stroke-dasharray:${style.dash} !important;` : "";
    return `${
      selectors.shape(name)
    }{fill:${style.fill} !important;stroke:${style.stroke} !important;${dash}}` +
      `${selectors.text(name)}{fill:${style.text} !important}`;
  }).join("");
}

export function themeCss(mode: RenderMode, paletteCss: (palette: Palette) => string): string {
  if (mode !== "auto") return paletteCss(theme.modes[mode]);
  const secondary: Mode = theme.primary === "dark" ? "light" : "dark";
  return paletteCss(theme.modes[theme.primary]) +
    `@media (prefers-color-scheme: ${secondary}){${paletteCss(theme.modes[secondary])}}`;
}

export function injectStyle(svg: string, css: string): string {
  const openEnd = svg.indexOf(">", svg.indexOf("<svg")) + 1;
  return svg.slice(0, openEnd) + `<style>${css}</style>` + svg.slice(openEnd);
}
