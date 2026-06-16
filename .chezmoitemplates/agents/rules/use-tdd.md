### Use TDD

Default to red-green TDD for behavior changes: features, bug fixes, API changes, and user-facing workflows. Skip only for tiny non-behavior edits or when the project says otherwise.

Loop:

1. Write a failing test for the requirement.
2. Run it and confirm it fails for the intended reason.
3. Refine the test if its wording or assertion is wrong.
4. Implement the smallest passing change.
5. Repeat for the next in-scope edge case.

Match the existing suite's framework, layout, naming, and style. Test only current requirements; do not add speculative fixtures or parameters.

If you find a major unrelated coverage gap, report it before filling it. Use descriptive test names that state condition and expected behavior.
