import asyncio

async def create_solution(output_path: str, solution_name: str) -> int:
    # Create the subprocess
    process = await asyncio.create_subprocess_exec(
        'dotnet','new', 'sln', '-n', solution_name, '-o', output_path,
        stdout=asyncio.subprocess.PIPE,
        stderr=asyncio.subprocess.PIPE
    )

    # Wait for the subprocess to complete and capture output
    stdout, stderr = await process.communicate()

    # Print output and error messages
    print("Error Output:\n", stderr.decode() if stderr else "No Errors")
    return process.returncode
# Run the asynchronous command
asyncio.run(create_solution())
