---
name: nano-banana-pro
description: Generate or edit images via Gemini 3.1 Flash Image (Nano Banana 3.1). Use for image create/modify requests. Supports text-to-image and image-to-image editing at 1K/2K/4K resolution.
---

# Nano Banana 3.1 (Gemini 3.1 Flash Image)

Use the bundled script to generate or edit images.

## Generate

```bash
uv run {baseDir}/scripts/generate_image.py --prompt "your image description" --filename "output.png" --resolution 1K
```

## Edit

```bash
uv run {baseDir}/scripts/generate_image.py --prompt "edit instructions" --filename "output.png" --input-image "/path/in.png" --resolution 2K
```

## API Key

Set `GEMINI_API_KEY` as an environment variable.

## Notes

- Resolutions: `1K` (default), `2K`, `4K`.
- Use timestamps in filenames: `yyyy-mm-dd-hh-mm-ss-name.png`.
- The script prints a `MEDIA:` line for auto-attachment on supported chat providers.
- Do not read the image back; report the saved path only.
