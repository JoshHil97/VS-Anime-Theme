# AGENTS.md

> Context file for AI coding assistants (Claude Code, Cursor, Copilot, etc.).
> Symlink or copy to `CLAUDE.md` if your tool of choice reads that name.

## Who I am / what this is

A web & platform developer working across three ecosystems:

- **TypeScript** — application & tooling code (strict mode, no implicit `any`).
- **Shopify Liquid** — custom theme development (sections, blocks, snippets).
- **Wix Velo** — backend + frontend JavaScript/TypeScript on the Wix platform.

When you help, assume production code destined for real stores/sites. Prefer
correctness, accessibility, and readability over cleverness.

## Tech stack & tooling

| Area        | Choice                                                        |
| ----------- | ------------------------------------------------------------ |
| Language     | TypeScript (`strict: true`), modern ES modules               |
| Formatting   | Prettier — single quotes, semicolons, trailing commas, width 100 |
| Linting      | ESLint (typescript-eslint)                                   |
| Themes       | Shopify Online Store 2.0 (JSON templates, sections, blocks)  |
| Platform     | Wix Velo (`$w`, `wix-data`, `wix-fetch`, backend `.jsw`)     |
| Package mgr  | Prefer `pnpm`; fall back to `npm` if a lockfile dictates      |

## Coding conventions

### TypeScript

- **Strict mode always.** No `any` unless justified with a comment; prefer
  `unknown` + narrowing. Enable `strictNullChecks` reasoning everywhere.
- **Explicit return types** on exported functions.
- **`type` for unions/aliases, `interface` for object shapes** that may be
  extended or implemented.
- Favor **pure functions** and **early returns**; avoid deep nesting.
- Handle errors explicitly — no silently swallowed promises. Consider a
  `Result<T, E>` pattern for expected failures (see the `tsresult` snippet).
- Naming: `camelCase` for values, `PascalCase` for types/components,
  `SCREAMING_SNAKE_CASE` for module-level constants.
- Imports: use non-relative (path-alias) imports where a `tsconfig` `paths`
  mapping exists; organize imports on save.

### Shopify Liquid

- Target **Online Store 2.0**: JSON templates + sections with `{% schema %}`.
- Every section that appears in the theme editor must expose a **`{% schema %}`**
  with sensible `settings`, `blocks`, and a `presets` entry.
- Use **`{%- -%}` whitespace control** to keep rendered HTML clean.
- Always `| escape` user/merchant text; use `| money` for prices,
  `image_url` + `image_tag` for responsive, lazy-loaded images.
- Prefer `{% render %}` over the deprecated `{% include %}` (isolated scope).
- Keep logic in `{%- liquid -%}` blocks; keep markup readable.
- Respect `block.shopify_attributes` on editor blocks for live preview.
- Follow **Theme Check** rules; treat its warnings as errors.

### Wix Velo

- Backend files use the `.jsw` (web-module) / `.js` conventions; frontend code
  runs in page code with the `$w` selector API.
- Use `wix-data` for collections, `wix-fetch` for HTTP, `wix-secrets-backend`
  for secrets — **never hardcode API keys**.
- Keep backend logic in web modules and call it from the front end; don't put
  secrets or heavy logic in page code.
- Guard DOM/`$w` access inside `$w.onReady(() => { ... })`.
- Type Velo code with JSDoc or `.ts` where the project allows it.

## General expectations for AI assistants

- **Match the existing file's style** (indentation, quotes, naming) before
  imposing conventions from here.
- Prefer **small, reviewable diffs**; explain non-obvious choices briefly.
- Don't invent APIs — if unsure about a Shopify/Wix API, say so or check docs.
- Accessibility matters: semantic HTML, alt text, keyboard support, ARIA only
  when needed.
- 2-space indentation everywhere (TS, Liquid, JSON).
- Write comments that explain **why**, not **what**. Use Better Comments tags
  (`! important`, `? question`, `TODO`, `* highlight`) where helpful.

## Commit conventions

- Conventional-commit style: `feat:`, `fix:`, `chore:`, `refactor:`, `docs:`.
- Present tense, imperative mood, concise subject line.
