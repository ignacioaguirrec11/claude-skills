---
name: solucion-video
description: Crea un video vertical 100% IA para la cuenta Solucion.IA de Ignacio (Remotion + voz ElevenLabs) a partir de una idea, y lo deja en el panel Solucion.IA con textos y hashtags para TikTok, Reels, Shorts y X. Usar cuando Ignacio pide "hacé un video de...", "/solucion-video", o "hacé las ideas del panel".
---

# Solucion.IA — de idea a video publicado en el panel

Ignacio (Tucumán, Argentina) vende desarrollos a medida a negocios locales. No da la cara: los videos son 100% IA. Objetivo de cada video: que alguien con ese problema **comente la palabra clave** y Ignacio le escribe por privado.

- Proyecto: `C:\Users\ignac\videos-ia` (Remotion 4, React). Leé `src/Turnos.tsx` y `src/Catalogo.tsx` como referencia de nivel antes de escribir uno nuevo.
- Panel: https://claude.ai/artifact/1ZJJ2KDH6gLh7qv8RGegg2 (colecciones `videos` e `ideas` vía la herramienta ArtifactData; videos como assets del artifact).
- Clave ElevenLabs: `~/.elevenlabs-key` (plan Starter, 40k caracteres/mes; un video gasta ~400).

## 0. Entrada
- Idea suelta en el mensaje → usarla.
- "hacé las ideas del panel" → `ArtifactData list` de `ideas`, tomar las de `estado: "nueva"`, ponerlas `en-proceso` (update con `if_version`) y hacer un video por idea. Al terminar, `hecha`.

## 1. Guion (5 escenas, 55–65 palabras en total)
`src/data/<id>.script.json` = `{"id": "<id>", "scenes": [{"vo": "..."}, ...]}` y `src/data/<id>.timing.json` = `{"audio": false, "words": []}`.
1. Gancho: el dolor del cliente como pregunta, en la primera palabra (≤ 2 s).
2. Agravante concreto (número, escena real).
3. La solución que Ignacio arma ("Te armo…" / "Armé…").
4. El beneficio que se ve en el celu.
5. Prueba real + CTA: "Comentá PALABRA…". La PALABRA en mayúsculas, una sola, del rubro.
Reglas: español rioplatense, voseo, frases cortas. **No** poner usuario/handle de cuenta en el video. **Solo afirmar lo que es cierto** (ver proyectos abajo); Lancer es una propuesta, no un cliente. Nada de emojis dentro del video.

## 2. Edición (el prompt de estilo, obligatorio)
Proponer una acción visual por bloque y después construir la animación. Máximo 4 palabras en pantalla por escena aparte de los subtítulos (componente `Label`). Convertir las ideas en acciones y dibujar las analogías del guion literalmente. Mostrar magnitudes con escala (contadores, grillas de N elementos). Enfocar lo importante (zoom de cámara al dato clave). Conservar elementos entre escenas para que se vea cómo se transforman (morph: burbujas → horarios, fotos → tarjetas). Sincronizar cada acción clave con su palabra (`wordFrame(escena, "palabra")`). Dejar una imagen final clara en cada escena.
- Piezas en `src/ui.tsx`: `Background`, `Label`, `Captions`, `PhoneFrame`, `CommentCTA` (cierre con la palabra), `Sfx` (whoosh, pop, notif, ding, cash, error, typing, impact, drop, swipe), `Soundtrack` (voz + música `beat1`).
- Cada acción clave lleva su efecto de sonido. Escena 1 abre con `impact` en el frame 0.
- Variar la metáfora visual entre videos (no repetir "47 mensajes" ni la pared de "¿precio?").
- Componente `src/<Nombre>.tsx` exporta `TL` y el componente; registrar en `src/Root.tsx` con id = `<id>`.

## 3. Voz, control y render
```
cd C:\Users\ignac\videos-ia
node tools/voice.mjs <id> D09EpJbk4um1HKSpeTSc 1.3   # Agustín AR, eleven_v3, acelerado 1.3x (Ignacio lo pidió así)
npx tsc -p .
npx remotion still src/index.ts <id> out/stills/<id>-<frame>.png --frame=<f> --scale=0.4   # 6–8 frames clave, mirarlos y corregir
npx remotion render src/index.ts <id> out/<id>.mp4
```
Copiar a Descargas como `solucionia-NN-<id>.mp4` (NN = número correlativo; ver el mayor `n` en `videos`). Para descargas usar PowerShell `(New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path`.

## 4. Panel
1. `Artifact publish` con `url` del panel, `asset: true`, `file_path: out/<id>.mp4` → anotar el id.
2. `ArtifactData set` en `videos/<id>`: `{n, titulo, rubro, duracion, palabra, creado, assetId, archivo, publicado: {}, comentario, textos: {tiktok:{texto}, instagram:{texto}, youtube:{titulo, texto}, x:{texto}}}`.
   - TikTok: gancho + 2 líneas + CTA + 5 hashtags. Reels: gancho + 3 ✅ beneficios + CTA + 5 hashtags. Shorts: título ≤ 70 caracteres con `#shorts` + descripción + 3 hashtags. X: ≤ 280 caracteres + 2 hashtags.
   - Hashtags: mezclar 1 amplio (#emprendedores), 2 del nicho (#turnosonline…), 1 de formato/venta y #tucuman. No hay datos de tendencias en vivo: decirlo si Ignacio pregunta.
3. Responder corto: link del panel, ruta en Descargas, qué palabra clave lleva.

## Proyectos reales de Ignacio (lo único que se puede afirmar)
- Cagliari Pilates (Tucumán): turnos online sin registro, 9 lugares por clase, turno fijo mensual, panel admin en el celu (asistencia, caja, deudas) + bot de WhatsApp con IA (n8n) que responde precios y horarios y lee feriados del panel.
- Catálogos con pedido por WhatsApp: Almacén de Pollos (Tucumán), Catálogo El Kikin, La Reserva Vintage (ropa).
- Páginas de negocios: Houston Barber (estado "abierto ahora", catálogo de cortes), Rust Herrería, Cabalgatas Tucumán.
- Sistema de informes de suelos (EEAOC): Excel → informe PDF automático.
- Apps de seguimiento de entrenamiento (rutinas de 20 semanas).
- Lancer (tienda de iPhones): **propuesta**, no cliente.
