# Async

Use `asyncio` when the work is I/O-bound and concurrency matters. Keep the boundary between sync and async explicit; never sprinkle `async` through code that does not await.

## Rules

- Structured concurrency only: `asyncio.TaskGroup` for fan-out, `asyncio.timeout()` for deadlines. Do not create fire-and-forget tasks with `create_task` unless you hold a reference and handle its result.
- Never block the loop. CPU-heavy or blocking library calls go through `asyncio.to_thread()`; true CPU parallelism goes to a `ProcessPoolExecutor` via `loop.run_in_executor`.
- Bound concurrency with `asyncio.Semaphore` when fanning out over many I/O calls.
- Use async-native libraries at the boundary: `httpx.AsyncClient`, `asyncpg` or `aiosqlite`, `anyio` file operations. Sync clients inside `async def` are a bug.
- Async resources are opened with `async with` and closed deterministically. One client per application, passed in, not created per call.
- Cancellation is a normal exit path. Let `CancelledError` propagate; clean up in `finally`. Do not catch and swallow it.
- Async generators feed streams; `async for` consumes them. Prefer them to accumulating a full list when the consumer can stream.
- Expose a sync entry point that calls `asyncio.run(main())` exactly once, at the top of the program.

## Fan-out with limits

```python
async def fetch_all(client: httpx.AsyncClient, urls: Sequence[str], *, limit: int) -> list[httpx.Response]:
    """Fetch every URL concurrently, at most ``limit`` in flight."""
    gate = asyncio.Semaphore(limit)

    async def fetch(url: str) -> httpx.Response:
        async with gate:
            response = await client.get(url)
            response.raise_for_status()
            return response

    async with asyncio.TaskGroup() as group:
        tasks = [group.create_task(fetch(url)) for url in urls]
    return [task.result() for task in tasks]
```

A `TaskGroup` cancels its siblings on the first failure and raises an `ExceptionGroup`. Handle categories with `except*` at the boundary.

## Deadlines

```python
async with asyncio.timeout(30):
    manifest = await client.get(manifest_url)
```

`asyncio.timeout` raises `TimeoutError` in the caller's frame, which composes with `TaskGroup` cleanly. Prefer it to `wait_for`.

## Sync and async boundaries

```python
async def checksum(path: Path) -> str:
    """Hash ``path`` without blocking the event loop."""
    return await asyncio.to_thread(_checksum_sync, path)
```

- Name the blocking implementation with a `_sync` suffix when both exist.
- Do not call `asyncio.run` from inside a running loop. Libraries accept a loop implicitly; only the application entry point owns it.

## Testing async code

- `pytest-asyncio` in `asyncio_mode = "auto"`; write `async def test_...` directly.
- Inject a `Clock` or use `asyncio.sleep(0)` to yield; never sleep real time in tests.
- Fakes implement the same async interface as the real client so the code under test does not change shape between test and production.
