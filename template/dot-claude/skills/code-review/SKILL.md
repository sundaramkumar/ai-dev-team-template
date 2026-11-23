---
name: code-review
description: Checklist for planning and reviewing changes in this Bun + Hono + Drizzle + React app. Use when planning a task or reviewing a diff.
---
# Plan and review checklist
Plan: acceptance criteria as testable bullets; name exact files per layer (shared, db, backend, frontend); flag migrations, new env vars, new RBAC modules.
Review (block on any of these):
1. Security: route without requirePermission; ownable module without scopeCondition; SQL built from strings; secrets or .env committed;
   unvalidated input; raw errors or stack traces to the client; default admin credentials in non-dev config.
2. Contract: request validated by the SHARED Zod schema (no per-feature copies); types from @shared on both sides; response envelope intact.
3. DB: schema change has a committed, reviewed migration; uuidPk, audit and soft-delete columns, partial unique indexes;
   deletes are soft and reads filter deleted_at; FKs indexed; multi-step writes in withTransaction with recordAudit.
4. Layering: routes -> controller -> service; no DB access in controllers; frontend calls only through features/*/api.
5. UI: loading/error/empty states; nav entry + guard() with module; forms use the shared schema.
6. Tests exist and pass; `bun run typecheck` and `bun run lint` pass.
Ignore style nits a linter catches. Use git diff; don't reread unchanged files.
