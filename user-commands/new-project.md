---
description: Create a new project with the AI dev team, the application template and the wiki, then kick it off
argument-hint: <project-name> [--no-wiki] [--no-app-template]
---
Create a new project: $ARGUMENTS
Kit: {{KIT}}. Projects live in ~/projects (create the folder if missing). Use absolute paths and `cd <abs> &&` inside each
Bash call (this session was not started inside the new project).

0. Preflight. Stop and fix before continuing:
   - Project name is lowercase letters, digits, - or _. If ~/projects/<name> already has files, ask me before using it.
   - {{KIT}}/new-project.sh exists. If not, say the kit is not installed and show {{KIT}}/BOOTSTRAP.md.
   - Unless --no-app-template: `git ls-remote https://github.com/Symatis-Solutions/application-template.git` must succeed.
     If it fails, explain the three usual causes and stop: (a) not logged in: I should type `! gh auth login` in this prompt
     (offer `brew install gh` if gh is missing); (b) no access: an org owner must run /team-access for me;
     (c) SAML single sign-on: authorise my login for Symatis-Solutions at GitHub -> Settings -> Personal access tokens / SSH keys -> Configure SSO.
1. Run `{{KIT}}/new-project.sh ~/projects/<name> <flags>`. Show me a short summary of what it did, not every line.
2. Requirements. Ask me with the question tool where they are: a file or folder path / a web link / pasted text / only a rough idea.
   File or folder: copy into ~/projects/<name>/docs/requirements/. Link or pasted text: handle it as .claude/commands/requirements.md describes.
   Rough idea: write it into docs/BRIEF.md. If I already gave requirements in the command arguments, skip the question.
3. Kick off. Read ~/projects/<name>/.claude/commands/kickoff.md and carry it out with ~/projects/<name> as the project root
   (app-setup, requirements, task plan). Its agents and CLAUDE.md are not loaded in this session yet; the kickoff does not need them.
   Ask me before installing any software, as app-setup says.
4. Finish with: the project path, what is running (URLs), the task list (ID + title), open questions, and the ONE remaining step:
   open ~/projects/<name> as the working folder in a new Claude Code session (desktop app: New session -> choose that folder),
   type /agents to check tech-lead, developer and tester are listed, then /task T-002.
