# claude-skills

Mis skills de Claude Code, para instalarlas en cualquier compu.

## Instalar en una compu nueva

```bash
git clone https://github.com/ignacioaguirrec11/claude-skills.git
cd claude-skills
```

- **Windows:** `powershell -ExecutionPolicy Bypass -File install.ps1`
- **Mac/Linux:** `./install.sh`

Despues reiniciar Claude Code.

## Actualizar

`git pull` y volver a correr el script. Para agregar una skill nueva: copiarla a `skills/`, commit y push.

## Contenido

**Locales (en `skills/`):**

- animate-expo
- animate
- animation-vocabulary
- apple-design
- ask-sonner
- brandkit
- cavecrew
- caveman-commit
- caveman-compress
- caveman-help
- caveman-review
- caveman-stats
- caveman
- design-taste-frontend-v1
- design-taste-frontend
- emil-design-eng
- find-animation-opportunities
- full-output-enforcement
- gpt-taste
- high-end-visual-design
- image-to-code
- imagegen-frontend-mobile
- imagegen-frontend-web
- impeccable
- improve-animations
- industrial-brutalist-ui
- minimalist-ui
- pick-ui-library
- prototype
- redesign-existing-projects
- reverse-engineer-anything
- review-animations
- stitch-design-taste
- write-swift

**Externas (el script las clona):**

- gstack — https://github.com/garrytan/gstack
- n8n-skills — https://github.com/czlonkowski/n8n-skills

**De claude.ai (en `claude-ai/`, solo respaldo):**

- automation-specialisat

Estas se sincronizan solas desde la cuenta de claude.ai, por eso el script no las instala (quedarian duplicadas). Si alguna compu no la tiene, copiarla a `~/.claude/skills/` o subirla en claude.ai > Configuracion > Skills.
