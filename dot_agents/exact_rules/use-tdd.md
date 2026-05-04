# Use TDD

Default to red-green TDD for any change to behavior — features, bug fixes, API evolution. Skip only when the project says otherwise or the work is too small to justify a test (a typo fix, a config nudge).

## The loop

1. **Red** — write a failing test that captures the requirement. Run it; confirm it fails for the *right* reason (asserts the behavior, not a missing import).
2. **Refine** — sharpen the test before writing implementation. Wrong test wording produces wrong code.
3. **Green** — write the minimum implementation to pass.
4. **Repeat** for the next requirement or edge case.

Don't write the implementation first and back-fill tests. That's not TDD; it's checking your own homework.

## Match the existing suite

Mirror the framework, style (BDD, property-based, table-driven), file layout, and naming conventions already in use. Consistency is the point — divergent style fragments the suite.

## Scope discipline

- Test only the current requirement and its in-scope edge cases.
- No speculative parameters, fixtures, or capabilities for "future needs" — they become dead code and flake vectors.
- New requirements get new tests when they arrive, not now.

## Coverage gaps

If you spot a significant gap, **report it before filling it**. There may be a reason. Get confirmation, then add tests as their own task — don't bundle into unrelated work.

## Test names

Descriptive, literate, state condition + expected behavior. `returns 413 when upload exceeds size limit` beats `test_upload_2`. Defer to suite convention if it diverges.
