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

# Clear any stale git lock files (left by crashed processes)
rm -f .git/index.lock .git/HEAD.lock .git/MERGE_HEAD.lock .git/CHERRY_PICK_HEAD.lock 2>/dev/null || true

# Stage HTML files, simulator app, API function, and script docx
git add index.html adults_market_deepdives.html acquisition_insights.html intakes_50plus.html \
        sales-simulator.html script-viewer.html call-checklist.html EF_Evals_Dashboard.html \
        conversion_matrix.html \
        EF_Adults_Sales_Scripts_v5.5.docx \
        api/chat.js package.json vercel.json .gitignore deploy.sh 2>/dev/null || true

# Commit if there are staged changes
if ! git diff --staged --quiet; then
  DATE=$(date '+%Y-%m-%d %H:%M')
  git commit -m "Dashboard update — $DATE"
fi

# Always push (handles unpushed commits too)
git push origin main

echo ""
echo "✅  Done! Your dashboard is live on Vercel."
echo ""
