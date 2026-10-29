# Async

Use `asyncio` when the work is I/O-bound and concurrency matters. Keep the boundary between sync and async explicit; never sprinkle `async` through code that does not await.

## Rules

- Structured concurrency only: `asyncio.TaskGroup` for fan-out, `asyncio.timeout()` for deadlines. Not `gather` or `wait_for`. Do not create fire-and-forget tasks with `create_task` unless you hold a reference and handle its result.
- Never block the loop. CPU-heavy or blocking library calls go through `asyncio.to_thread()`; true CPU parallelism goes to a `ProcessPoolExecutor` via `loop.run_in_executor`.
- Bound fan-out over many I/O calls with an `asyncio.Semaphore` inside the task body.
- Use async-native libraries at the boundary: `httpx.AsyncClient`, `asyncpg` or `aiosqlite`, `anyio` file operations. Sync clients inside `async def` are a bug.
- One client per application, opened with `async with`, passed in, never created per call.
- Let `CancelledError` propagate; clean up in `finally`.
- Handle `TaskGroup` failures by category with `except*` at the boundary.
- Expose a sync entry point that calls `asyncio.run(main())` exactly once, at the top of the program.
- Name the blocking implementation with a `_sync` suffix when both exist (`checksum` awaits `asyncio.to_thread(_checksum_sync, path)`).
- Subprocesses use `asyncio.create_subprocess_exec` and `await process.communicate()`; never `subprocess.run` inside a coroutine.

## Testing async code

- `pytest-asyncio` in `asyncio_mode = "auto"`; write `async def test_...` directly.
- Inject a `Clock` or use `asyncio.sleep(0)` to yield; never sleep real time in tests.
- Fakes implement the same async interface as the real client so the code under test does not change shape between test and production.
