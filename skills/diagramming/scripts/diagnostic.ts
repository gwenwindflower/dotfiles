export interface Diagnostic {
  code: string;
  line: number;
  column: number;
  message: string;
  snippet: string;
}

export class DiagramError extends Error {
  constructor(readonly diagnostic: Diagnostic) {
    super(diagnostic.message);
    this.name = "DiagramError";
  }
}

export function formatDiagnostic(path: string, d: Diagnostic): string {
  const head = `${path}:${d.line}:${d.column} [${d.code}] ${d.message}`;
  return d.snippet ? `${head}\n${d.snippet.replace(/^/gm, "    ")}` : head;
}
