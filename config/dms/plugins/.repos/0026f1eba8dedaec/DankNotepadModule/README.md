# DankNotepadModule Plugin

Chroma-based inline preview and syntax highlighting for Notepad.

## Features

- Inline preview (split or full)
- Chroma syntax highlighting for many languages
- Markdown rendering with highlighted fenced code blocks

## Usage

- Click **Preview** in Notepad to toggle: off → split → full → off
- Highlighting is automatic based on file extension

## Settings

Settings → Plugins → Notepad Module

- **Chroma Style** (e.g., github-dark, dracula, monokai)

## Notes

- Requires the `dms chroma` CLI command.
- If `dms chroma` is missing, preview HTML will not render.

## Files

- `plugin.json` – manifest
- `DankNotepadModule.qml` – chroma render daemon
- `DankNotepadModuleSettings.qml` – settings UI
- `qmldir` – module definition

## Hot Reload

```bash
dms ipc call plugins reload dankNotepadModule
```
