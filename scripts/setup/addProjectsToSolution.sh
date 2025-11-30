#1 /bin/bash
#


find . -type f -name *.csproj | while read -r file; do
  dotnet sln $1 add $file -s $2
done
