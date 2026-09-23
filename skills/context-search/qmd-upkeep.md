# qmd corpus upkeep

Applies on top of [vendor/qmd](vendor/qmd/SKILL.md).

Maintaining the index is part of using the tool:

- **Stale index?** `qmd status` shows per-collection age. If content you'd expect is missing or the index is more than a few days old, run `qmd update` (re-index) then `qmd embed` (fills only missing vectors) before trusting results.
- **Embedding model changed?** (`QMD_EMBED_MODEL` points at a new file/revision): run `qmd embed -f` — vectors are not compatible across models, and stale-model search degrades silently. The model is the shared Qwen3 GGUF in the HF hub cache; the `llup` abbr (background llama-server) re-checks HF and updates the file on each start.
