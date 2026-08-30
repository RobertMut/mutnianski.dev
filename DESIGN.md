---
name: Wayfinding Board
description: A legible personal-site system built from ink-blue fields, signal-yellow markers, condensed route type, and ruled destination rows.
colors:
  ink: "#10233f"
  ink-deep: "#09172b"
  paper: "#f4f5ef"
  white: "#fffef8"
  signal: "#ffd43b"
  signal-deep: "#8a6500"
  line: "#a9b2ac"
  muted: "#526173"
  ink-hover: "#1d385d"
  board-line: "#49607f"
  board-muted: "#d8e2ef"
typography:
  display:
    fontFamily: "Route Sans, Arial Narrow, sans-serif"
    fontSize: "clamp(3.5rem, 9vw, 6rem)"
    fontWeight: 800
    lineHeight: 0.92
    letterSpacing: "-0.035em"
  headline:
    fontFamily: "Route Sans, Arial Narrow, sans-serif"
    fontSize: "clamp(2rem, 4vw, 3.5rem)"
    fontWeight: 800
    lineHeight: 1
    letterSpacing: "-0.025em"
  title:
    fontFamily: "Route Sans, Arial Narrow, sans-serif"
    fontSize: "clamp(1.35rem, 3vw, 2rem)"
    fontWeight: 800
    lineHeight: 1.1
    letterSpacing: "-0.015em"
  body:
    fontFamily: "Aptos, Segoe UI, sans-serif"
    fontSize: "1rem"
    fontWeight: 400
    lineHeight: 1.65
    letterSpacing: "normal"
  label:
    fontFamily: "Route Sans, Arial Narrow, sans-serif"
    fontSize: "0.84rem"
    fontWeight: 800
    lineHeight: 1.65
    letterSpacing: "0.06em"
  action:
    fontFamily: "Aptos, Segoe UI, sans-serif"
    fontSize: "1rem"
    fontWeight: 800
    lineHeight: 1.65
    letterSpacing: "normal"
rounded:
  square: "0"
  signal: "50%"
spacing:
  compact: "0.8rem"
  base: "1rem"
  section-heading: "2rem"
components:
  primary-action:
    backgroundColor: "{colors.ink}"
    textColor: "{colors.white}"
    typography: "{typography.action}"
    rounded: "{rounded.square}"
    padding: "0.7rem 1rem"
    height: "3.25rem"
  primary-action-hover:
    backgroundColor: "{colors.signal}"
    textColor: "{colors.ink-deep}"
  status-board-header:
    backgroundColor: "{colors.signal}"
    textColor: "{colors.ink-deep}"
    rounded: "{rounded.square}"
    padding: "0.8rem 1rem"
  route-row:
    backgroundColor: "transparent"
    textColor: "{colors.ink-deep}"
    rounded: "{rounded.square}"
    padding: "1.25rem 0"
    height: "7rem"
---

# Design System: Wayfinding Board

## Overview

**Creative North Star: "Wayfinding Board"**

Wayfinding Board treats the personal site as a clear public directory rather than an avatar-led portfolio. Its visual language comes from transit and destination boards: compact mastheads, condensed uppercase type, dark information fields, signal markers, and horizontal rules that make choices easy to scan.

The system is direct, high-contrast, and deliberately flat. Writing and work remain equally legible destinations, while the primary dark action points visitors toward work. The established anti-reference is the avatar-led hero paired with an equal-card grid.

**Key Characteristics:**

- Ink-blue structure on a warm paper field.
- Signal yellow reserved for orientation, state, and emphasis.
- Condensed uppercase display type paired with a neutral system body face.
- Ruled destination rows instead of interchangeable cards.
- Square-edged, low-decoration components with visible keyboard focus.

## Colors

The palette behaves like printed signage: dark ink supplies structure, warm paper keeps long pages readable, and yellow acts as a scarce navigational signal.

### Primary

- **Ink Blue** (`#10233f`): Primary board, action, rule, and structural color.
- **Deep Ink** (`#09172b`): Main text and the page-edge background.

### Secondary

- **Signal Yellow** (`#ffd43b`): Orientation dot, selected navigation underline, board heading, project code, and interactive hover state.
- **Deep Signal** (`#8a6500`): Keyboard-focus outline and subdued signal text where yellow would not provide enough contrast.

### Neutral

- **Warm Paper** (`#f4f5ef`): Main page canvas.
- **Warm White** (`#fffef8`): Text on ink and the hover surface behind destination rows.
- **Route Line** (`#a9b2ac`): Dividers between destination rows.
- **Muted Slate** (`#526173`): Supporting copy and footer text.
- **Board Hover Ink** (`#1d385d`): Hover and focus fill inside dark status boards.
- **Board Rule Blue** (`#49607f`): Dividers inside dark status boards.
- **Board Muted White** (`#d8e2ef`): Secondary status labels on ink.

**The Signal Is Scarce Rule.** Use yellow for orientation and state, not as a general-purpose surface.

## Typography

**Display Font:** Route Sans (with Arial Narrow and sans-serif fallbacks)
**Body Font:** Aptos (with Segoe UI and sans-serif fallbacks)

**Character:** Route Sans provides the condensed, emphatic cadence of a transit board. The body stack stays familiar and highly legible so descriptive text does not compete with destinations.

### Hierarchy

- **Display** (800, `clamp(3.5rem, 9vw, 6rem)`, 0.92): Uppercase home and page headings, balanced and limited to 12 characters per line where practical.
- **Headline** (800, `clamp(2rem, 4vw, 3.5rem)`, 1): Uppercase section headings.
- **Title** (800, `clamp(1.35rem, 3vw, 2rem)`, 1.1): Uppercase destination titles inside route rows.
- **Body** (400, `1rem`, 1.65): General reading and descriptive content; prose is capped at 72 characters.
- **Label** (800, `0.84rem`, `0.06em`, uppercase): Route codes and destinations; status headings use the same character at smaller sizes and heavier weight.

**The Route-Type Rule.** Reserve condensed uppercase type for identity, headings, codes, and destinations; keep explanatory copy in the body face.

## Layout

The site sits in a centered shell capped at 1180px, with a 1rem minimum gutter on wide screens. The home introduction is a two-column grid: a larger copy column and a minimum-300px status board, separated by a fluid 3–8rem gap. Sections use generous fluid vertical padding and full-width horizontal rules rather than boxed cards.

At 760px, the shell gutter narrows to 0.625rem per side, the masthead and introduction stack, and route rows reduce from three columns to two. At 420px, route rows become a single column. Navigation remains a full-width horizontal choice set on narrow screens.

**The Destination-First Rule.** Preserve a single reading axis and let rules, alignment, and column changes express hierarchy.

## Elevation & Depth

The system uses no shadows. Depth comes from high-contrast tonal fields, one- and two-pixel rules, hover fills, and a small horizontal shift on route rows.

**The Flat Board Rule.** Keep surfaces flat at rest; communicate grouping and state through color, rules, and motion.

## Shapes

The dominant form language is square and rectilinear. Actions, boards, rows, and prose callouts use no corner radius. The only recurring curve is the circular signal marker (`50%` radius), which makes it read as an indicator rather than a container.

## Components

### Buttons

Primary and text actions feel like compact destination signs.

- **Shape:** Square corners, inline-flex layout, and a minimum height of 3.25rem.
- **Primary:** Ink Blue background with Warm White text and `0.7rem 1rem` padding.
- **Hover / Focus:** Hover reverses to Signal Yellow with Deep Ink text. Keyboard focus uses a 3px Deep Signal outline offset by 4px.

### Cards / Containers

Status boards are dark information fields; prose callouts are flat warm-white blocks.

- **Corner Style:** Square corners.
- **Background:** Ink Blue for status boards and Warm White for prose callouts.
- **Shadow Strategy:** None.
- **Border:** Status rows use Board Rule Blue dividers; route groups begin with a 2px Ink Blue rule.
- **Internal Padding:** Status rows use `0.8rem 1rem`; prose callouts use `1.25rem 1.5rem`.

### Navigation

The header pairs a condensed uppercase site mark and yellow indicator with a restrained three-link navigation. Links are unboxed; hover and current-page states use a thick inset Signal Yellow underline. On small screens, navigation spans the available width below the site mark.

### Status Board

The status board uses two aligned columns for destination and status. Its yellow uppercase header labels the columns, its dark rows maintain a minimum height of 3.75rem, and hover or keyboard focus shifts the row to Board Hover Ink.

### Route Row

The signature route row aligns a code or date, destination title and summary, and a terse action label. Rows are separated by Route Line rules, maintain a 7rem minimum height, and move 0.35rem to the right over a Warm White hover field when reduced motion is not requested.

## Do's and Don'ts

### Do:

- **Do** reserve Signal Yellow for navigation, focus, and state cues.
- **Do** use ruled destination rows for comparable writing and work entries.
- **Do** keep descriptive text within the established 55–72 character measures.
- **Do** preserve the visible 3px keyboard-focus outline and reduced-motion behavior.

### Don't:

- **Don't** introduce shadows, gradients, glass effects, or soft card elevation.
- **Don't** turn writing and work into an equal-card grid.
- **Don't** replace the wayfinding introduction with an avatar-led hero.
- **Don't** apply condensed uppercase display type to long-form body copy.
