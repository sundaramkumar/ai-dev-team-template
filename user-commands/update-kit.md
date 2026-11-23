---
description: Update the AI dev team kit to the latest version from GitHub
---
Update the kit in {{KIT}}.
1. `cd {{KIT}} && git status --short`. If there are local changes, show them and ask me before continuing.
2. `git -C {{KIT}} pull --ff-only`. If it fails (diverged or no access), explain why and stop.
3. `bash {{KIT}}/install.sh` to refresh the slash commands.
4. Reply in max 5 lines: new commits (`git log --oneline` of what changed), and remind me that existing projects keep their own
   copy of agents, skills and commands (copy a file over by hand if I want an improvement there too). Restart Claude Code if commands changed.
