#!/bin/bash

# Exit immediately if a command fails
set -e

# 1️⃣ Delete local gh-pages branch if it exists
if git show-ref --verify --quiet refs/heads/gh-pages; then
    echo "Deleting local gh-pages branch..."
    git branch -D gh-pages
fi

# 2️⃣ Delete remote gh-pages branch if it exists
if git ls-remote --exit-code --heads origin gh-pages; then
    echo "Deleting remote gh-pages branch..."
    git push origin --delete gh-pages
fi

# 3️⃣ Build Flutter web app with correct base href
echo "Building Flutter web app..."
flutter build web --base-href=/tip_calculator/

# 4️⃣ Create a new orphan gh-pages branch
echo "Creating new gh-pages branch..."
git checkout --orphan gh-pages
git reset --hard

# 5️⃣ Copy build files into branch
echo "Copying build/web files to gh-pages..."
cp -r build/web/* .

# 6️⃣ Commit and push
git add .
git commit -m "Deploy Flutter web to GitHub Pages"
git push origin gh-pages --force

# 7️⃣ Switch back to main branch
git checkout main

echo "✅ Deployment complete! Your site should be live at https://<your-username>.github.io/tip_calculator/"
