# Use TDD

For any development task affecting functionality: adding a new feature, evolving an API endpoint, fixing a bug, etc. - strive to follow Test-Driven Development (TDD) principles. Write a failing test first to capture the requirements, and refine the failing tests before implementing solutions.

Follow the patterns you see in the existing test suite - if it uses a certain framework, a specific style (like BDD or Property-Based Testing), or a certain structure for test files - mirror that in your new tests. This consistency makes it easier for others to understand and maintain the tests.

If you find a significant gap in coverage, report it to the user first before tackling it. This is a good thing to look out for and report, but there may be a reason for the gap, so get confirmation before filling it in.

Do not add arguments or expanded capabilities to tests based on anticipated future needs. This can lead to dead code and flakier tests. Focus only on the current requirements, and edge cases within the scope of the current task. If new requirements arise, add new tests for them at that time.

Use highly descriptive test names that clearly indicate what is being tested and under what conditions. Tests should strive towards a literate, readable style, unless the existing test suite uses a different convention and style.
