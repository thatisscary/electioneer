import argparse
import asyncio
import os

parser = argparse.ArgumentParser(
    prog='create_structure.py',
    usage='%(prog)s [options]',
    description='Creates a default structure for uncovered domains. Creates default structure... ',
    epilog='''
            Example usage: create_structure.py --domain_root ./my_project/domains''')
parser.add_argument('-d','--domain_root', type=str, required=True, help='The domain root directory where the structure should be created.')
parser.add_argument('-l','--list',required=True,help='List of domains to create, ie: [customer,order].',nargs='*')
parser.add_argument('-a','--additional_subdirs', nargs='*', help='Additional subdirectories to create within each domain.')
args = parser.parse_args()
def check_arguments():
    if not args.domain_root or not args.list:
        parser.print_help()
        exit(1)
    if not os.path.exists(args.domain_root):
        print(f'Cannot locate the directory : {args.domain_root}')
        exit(1)
    if not args.domain_root.endswith('domains'):
        print(f'The specified domain root does not appear to be a valid domain root (should end with "domains"): {args.domain_root}')
        exit(1)

def create_domain_path(domain_name: str) -> str:
    domain_path = os.path.join(args.domain_root, domain_name)
    if not os.path.exists(domain_path):
        os.makedirs(domain_path)
        print(f'Created domain directory: {domain_path}')
        return domain_path
    
    print(f'Domain directory already exists: {domain_path}')
    return domain_path

async def create_solution(output_path: str, solution_name: str) -> int:
    # Create the subprocess
    if(solution_name + '.sln' in os.listdir(output_path)):
        print(f'  Solution file already exists: {solution_name}.sln')
        return 0
    process = await asyncio.create_subprocess_exec(
        'dotnet','new', 'sln', '-n', solution_name, '-o', output_path,
        stdout=asyncio.subprocess.PIPE,
        stderr=asyncio.subprocess.PIPE
    )

    # Wait for the subprocess to complete and capture output
    stdout, stderr = await process.communicate()

    # Print output and error messages
    print("Error Output:\n", stderr.decode() if stderr else f"Solution {solution_name}.sln created successfully.")
    return process.returncode


async def print_structure(domain_path: str) -> int:
    # Create the subprocess
    process = await asyncio.create_subprocess_exec(
        'ls','-lR', domain_path,
        stdout=asyncio.subprocess.PIPE,
        stderr=asyncio.subprocess.PIPE
    )

    
    # Print output and error messages
    
    return process.returncode


def create_subdirectories(domain_path: str):
    subdirs = ['src', 'tests', 'persistence','infra'] + (args.additional_subdirs or [])
    for subdir in subdirs:
        subdir_path = os.path.join(domain_path, subdir)
        if not os.path.exists(subdir_path):
            os.makedirs(subdir_path)
            print(f'  Created subdirectory: {subdir_path}')
        else:
            print(f'  Subdirectory already exists: {subdir_path}')




print(f'Creating structure in domain root: {args.domain_root}')

try:
    check_arguments()
    for domain in args.list:
        domain_path = create_domain_path(domain)
        asyncio.run(create_solution(domain_path, domain))
        create_subdirectories(domain_path)
        print(f'Finished creating structure {args.list} for domain: {domain}\n')
        #asyncio.run(print_structure(domain_path))
except Exception as e:
    print(f'An error occurred: {e}')
    


