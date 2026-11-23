---
description: (GitHub org owner) Give a team read access to the application template and kit repos
argument-hint: <team-slug> <github-username> [<github-username> ...]
---
Grant GitHub access: $ARGUMENTS
Org: Symatis-Solutions. Repo for the team: application-template. Role: pull (read-only).
Kit repo sundaramkumar/project-template: a personal repo cannot be shared with an org team. If it is private, add each user as a
collaborator instead (`gh api -X PUT repos/sundaramkumar/project-template/collaborators/<user> -f permission=pull`; only its owner can do this).
If it is public, nothing is needed.
This changes organisation membership and permissions. Do steps 1-2, then show me the exact plan (team, users, repos, role)
and wait for my yes before step 3.

1. `gh auth status` must show a login with the `admin:org` and `repo` scopes. If a scope is missing, tell me to type
   `! gh auth refresh -h github.com -s admin:org -s repo`. If gh is missing: offer `brew install gh`.
2. Check I am an org owner: `gh api orgs/Symatis-Solutions/memberships/$(gh api user --jq .login) --jq .role` must be `admin`.
   If not, stop and say an org owner has to run this.
3. After my yes:
   - Team exists? `gh api orgs/Symatis-Solutions/teams/<slug>`. If 404, create it: `gh api -X POST orgs/Symatis-Solutions/teams -f name=<slug> -f privacy=closed`.
   - For each user: `gh api -X PUT orgs/Symatis-Solutions/teams/<slug>/memberships/<user> -f role=member`
     (a user outside the org gets an invitation by email).
   - Give the team the org repo: `gh api -X PUT orgs/Symatis-Solutions/teams/<slug>/repos/Symatis-Solutions/application-template -f permission=pull`.
4. Verify: list team members and check application-template shows the team with pull permission.
5. Reply in max 8 lines: what changed, who is pending an invite, and what each member must do next:
   accept the invite email, then `! gh auth login`, then SAML SSO authorisation if the org requires it.
