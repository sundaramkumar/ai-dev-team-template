# Everything from the Claude Code prompt

Start Claude Code in your `~/projects` folder (desktop app: New session -> choose `~/projects`).
Lines that start with `!` run directly in the prompt (needed only for GitHub login). Everything else is a normal message or slash command.

## A. One-time install (each person, once)
Paste this message:

    Install my AI dev team kit. The kit folder is at <KIT LOCATION>. Move it to ~/ai-dev-team-template if it is not there already,
    then run `bash ~/ai-dev-team-template/install.sh` and show me the output. If gh (GitHub CLI) or Homebrew is missing, tell me.

Teammates (kit published at github.com/sundaramkumar/project-template) paste this instead:

    Clone https://github.com/sundaramkumar/project-template.git into ~/ai-dev-team-template, then run
    `bash ~/ai-dev-team-template/install.sh` and show me the output. If gh or Homebrew is missing, tell me.

Then restart Claude Code so `/new-project`, `/team-access` and `/update-kit` appear. Later, `/update-kit` pulls the latest kit.

## A2. Publish the kit (kit owner, once)
Needs section B (GitHub login) first. Paste:

    Publish my AI dev team kit to https://github.com/sundaramkumar/project-template (branch master). Clone that repo to
    /tmp/pt-publish, copy everything from ~/projects/zamzam_am/ai-dev-team-template into it (skip _to_delete, .DS_Store and .git;
    my README.md replaces the placeholder one), show me `git status --short` and wait for my OK, then commit with the message
    "Add AI dev team kit" and push to master.

The repo is PUBLIC: anyone can read the kit (agents, skills, scripts). The Symatis application template stays private. To keep the kit
private too: GitHub -> repo Settings -> Danger zone -> Change visibility, then run /team-access (it adds teammates as collaborators).

## B. GitHub login (each person, once)
    ! gh auth login
Choose GitHub.com -> HTTPS -> yes to "authenticate Git" -> login with the browser. If `gh` is missing: ask Claude "install gh with Homebrew".
If the organisation uses SAML SSO, also authorise your login for Symatis-Solutions (GitHub -> Settings -> Configure SSO).

## C. Give the team access (GitHub org owner, once per person)
    ! gh auth refresh -h github.com -s admin:org -s repo
    /team-access developers alice bob carol
Claude shows the plan (team, users, repos, read-only) and waits for your yes. New people get an invite email to accept.
Not an org owner? Ask one to run the command.

## D. Start a project (every time)
    /new-project my_app
Claude then, in this one session:
1. checks GitHub access to the template and tells you exactly what to fix if it fails
2. creates ~/projects/my_app with the AI team, wiki, requirements folders and the application template
3. asks where your requirements are: a file/folder path, a link, pasted text, or only a rough idea
4. shows ONE table of software to install (Bun, PostgreSQL...), installs after your yes, creates the database, migrates, seeds, starts the app
5. reads the requirements and writes TASKS.md
Options: `/new-project my_app --no-wiki`, `--no-app-template`. Requirements can be given up front:
`/new-project my_app requirements: ~/Downloads/spec.pdf`.

## E. Build (every task)
Open `~/projects/my_app` as the working folder in a NEW Claude Code session (desktop app: New session -> choose the folder).
This loads the three agents. Then:

    /agents                  (check: tech-lead, developer, tester)
    /task T-002              (plan -> build -> test -> review; 5-line report)
    /clear
    /add-task <what you want>      /requirements <new file or link or pasted text>      /wiki-sync

Open http://localhost:5175 and log in as admin / admin123 (change it).

## Why E needs a new session
Claude Code loads a project's agents, skills and CLAUDE.md when a session starts in that folder. `/new-project` runs from `~/projects`,
so it can create and set up the project, but the team only loads when you open the project itself.
