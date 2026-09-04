---
title: syvat.io
summary: Real time activity tracking software
code: WEB
order: 1
external_url: https://syvat.io
commercial: true
---

## Overview

syvat.io is a commercial real time activity tracking software similar to [ActivityWatch](https://activitywatch.net/) or [DeskTime](https://desktime.com/) focusing on privacy and modular approach.

## Technology and stack

Project consist of:

- syvat.io application:
    - Main application (Electron, React, Vite, DrizzleORM, SQLite) - stores, and displays gathered data. Heart of the project
    - Sidecar (.NET 10, ASP.NET, gRPC) - gathers data from user's PC
    - Browser extension (Typescript) - gathers information about currently used tab, sends domain name to sidecar
- syvat.io landing page:
    - UI (React + Vite) - just frontend that allows user to send feedback and download application
    - Backend (.NET 10, ASP.Net, REST) - backend, sends email with feedback, provides changelog
- syvat.io infrastructure:
    - VPS (Debian) - serves frontend and backend, executes pipeline to build and sign installer
    - Azure Artifact Signing - provides certificate to the installer
    - Microsoft Entra ID - authentication for Github Actions and Azure Artifact Signing