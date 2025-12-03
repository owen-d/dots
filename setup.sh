# Links everything from the home directory appropriately
find -X home -type f | xargs -I {} -- echo {} | sed 's|home/||' | xargs -n 1 -I {} -- bash -c 'mkdir -p ~/$(dirname {}) && ln -s -f $(pwd)/home/{} ~/{}'

# Copy reference/vscode folder to /Users/owen/Library/Application Support/Code/User/
cp -R reference/vscode/* "/Users/owen/Library/Application Support/Code/User/"
