@echo off
echo Pushing Issue #1 to charityzarmai/PayFlow...
echo.

git checkout feature/issue-1-pending-upgrade-ui
git push -u charityzarmai feature/issue-1-pending-upgrade-ui

echo.
echo Done! Check https://github.com/charityzarmai/PayFlow/branches
pause
