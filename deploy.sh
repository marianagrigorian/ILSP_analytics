#!/bin/bash
# ─────────────────────────────────────────────────────────────
# EF Analytics — Dashboard Deploy Script
# Run this from Terminal each time you want to publish updates.
#
# Workflow:
#   1. Drop new data files into this Dash folder
#   2. Ask Claude (in Cowork) to "update the dashboard with the new files"
#   3. Once Claude confirms it's done, run this script:
#        cd "/Users/marianagrigorian/Documents/Claude/Projects/ILS strategy 27/Dash"
#        bash deploy.sh
# ─────────────────────────────────────────────────────────────

set -e

SITE_DIR="/Users/marianagrigorian/Documents/Claude/Projects/ILS strategy 27/Dash"

echo ""
echo "🚀  EF Analytics — Deploying dashboards to GitHub..."
echo ""

cd "$SITE_DIR"

# Stage only the HTML files
git add index.html adults_market_deepdives.html acquisition_insights.html .gitignore deploy.sh 2>/dev/null || true

# Check if there's anything to commit
if git diff --staged --quiet; then
  echo "ℹ️   No changes detected. Dashboard is already up to date."
  exit 0
fi

# Commit with today's date
DATE=$(date '+%Y-%m-%d %H:%M')
git commit -m "Dashboard update — $DATE"

# Push
git push origin main

echo ""
echo "✅  Done! Your dashboard is live on Vercel."
echo ""
