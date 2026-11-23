| ID    | Task | Status | Notes |
|-------|------|--------|-------|
| T-001 | Install and run the application template (/app-setup) | todo | Acceptance: bun install done; project DB created, migrated, seeded; `bun run dev` serves API :3005 and UI :5175; login works |
| T-002 | Test setup | todo | Create frontend src/__tests__/setup.ts (jest-dom + msw); backend .env.test + separate `<project>_test` DB + smoke test via createApp().request('/api/health'); `bun run test` passes in backend and frontend |
| T-003 | Clean template leftovers and rebrand | todo | Remove CRM-leftover e2e specs, stale backend/frontend READMEs, warehouse types/constants; grep before removing unused deps (@hello-pangea/dnd, xlsx, redux-thunk, react-grid-layout); fix Playwright ports (3005/5175, /api/health); set product name/logo/API-docs title. Needs product name + logo from human |

Status values: todo -> in-progress -> testing -> done (or blocked)
