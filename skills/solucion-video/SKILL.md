---
name: solucion-video
description: Crea un video vertical 100% IA para la cuenta Solucion.IA de Ignacio (Remotion + voz ElevenLabs) a partir de una idea, y lo publica en su panel de Vercel (solucion-ia.vercel.app) con textos y hashtags para TikTok, Reels, Shorts y X. Usar cuando Ignacio pide "hacé un video de...", "/solucion-video", o "hacé las ideas del panel".
---

# Solucion.IA — de idea a video publicado en el panel

Ignacio (Argentina) vende soluciones de software e IA a medida. No da la cara: los videos son 100% IA. Objetivo de cada video: que alguien con ese problema piense "esto me pasa a mí exactamente" y **comente la palabra clave**; Ignacio le escribe por privado.

- Videos: `C:\Users\ignac\videos-ia` (Remotion 4, React). **Estilo v2 (desde 2026-11-27):** piezas en `src/ui2.tsx` (Paper, Headlines, Card, Tag, Cursor, CommentLight) y `src/ui2b.tsx` (StatBar, ChatCard, BigNumber, LossCard, PhoneShell, FinalCTA, Scene); referencias: `Turnos2`, `Catalogo2`, `Pagina2`, `Informes2`, `Rutinas2` y `src/Turnos2.tsx` como referencia de nivel. El texto en pantalla son los titulares (`Headlines`), sin `Captions`. Los videos v1 (`ui.tsx`, fondo oscuro) quedan solo como archivo.
- Panel: https://solucion-ia.vercel.app — carpeta `C:\Users\ignac\solucion-ia-panel` (proyecto Vercel `solucion-ia`, se publica con la CLI, sin Git). Videos en `public/videos/<id>.mp4`, textos en `public/data/videos.json`, ideas en Vercel Blob vía `/api/ideas`.
- El panel no tiene clave (Ignacio lo pidió). Clave ElevenLabs: `~/.elevenlabs-key` (Starter, 40k caracteres/mes; un video gasta ~400).

## 0. Entrada
- Idea suelta en el mensaje → usarla.
- "hacé las ideas del panel" → leer las nuevas:
  ```
  curl -s "https://solucion-ia.vercel.app/api/ideas?estado=nueva"
  ```
  Las ideas generadas traen `tipo` (solucion|proceso), `rubro`, `titulo`, `gancho`, `problema`, `solucion`, `escenas` (5 acciones visuales sugeridas) y `palabra`. Marcar cada una `en-proceso` y al terminar `hecha`:
  ```
  curl -s -X PATCH -H "content-type: application/json" -d '{"id":"<id>","estado":"hecha"}' https://solucion-ia.vercel.app/api/ideas
  ```
- Ideas tipo "proceso" (detrás de escena de cómo se crea una solución con IA): mismo formato de 5 escenas, mostrando idea → IA construyendo → sistema funcionando → antes/después.

## 1. Guion (5 escenas, 55–65 palabras en total)
Antes de escribir, cargar con la herramienta Skill:
- **`hook-writer`**: escribir 3 ganchos para los primeros 2 segundos (primicia que abre un loop, no que entrega la respuesta), puntuarlos con su rúbrica y quedarse con el mejor. El gancho tiene que ser verdad respecto de lo que muestra el video.
- **`short-form-video-script`**: armar las 5 escenas con su framework WATCH (que nadie lo saltee: ritmo, nada de relleno, cierre claro). Sus reglas mandan sobre el formato salvo donde choquen con las reglas de abajo, que ganan.

`src/data/<id>.script.json` = `{"id": "<id>", "scenes": [{"vo": "..."}, ...]}` y `src/data/<id>.timing.json` = `{"audio": false, "words": []}`.
**Leer primero `C:\Users\ignac\videos-ia\CLAUDE.md`** (narrativa "no gastar la bala" + nivel visual de referencia); manda sobre esta sección.
1. Primicia (≤ 2 s): promesa o hecho llamativo que abre una pregunta, sin nombrar la solución.
2. Contexto / historia: por qué y cómo, el dolor contado como vivido.
3. Tensión: agravante concreto (número, escena real).
4. El premio: recién acá la solución y cómo funciona, en pantalla.
5. Resumen de la solución en 3 beneficios cortos + CTA: "Si tu negocio necesita esto, comentá PALABRA y te muestro cómo quedaría en el tuyo." (nunca "te paso la info") La PALABRA en mayúsculas, una sola, del rubro.
Reglas:
- **Nunca ejemplos ni pruebas de clientes** ("ya lo usa un estudio de…", "ya lo tienen…", "lo armé para…"): no suman, nadie lo puede verificar. Ese tiempo se usa para explicar mejor la solución.
- **Nunca nombrar Tucumán ni ningún lugar** (voz, pantalla, textos, hashtags).
- **No** poner usuario/handle de la cuenta en el video.
- Español rioplatense, voseo, frases cortas. Sin emojis dentro del video. No prometer lo que no se puede cumplir.

## 2. Edición (el prompt de estilo, obligatorio)
Proponer una acción visual por bloque y después construir la animación. Máximo 4 palabras en pantalla por escena aparte de los subtítulos (componente `Label`). Convertir las ideas en acciones y dibujar las analogías del guion literalmente. Mostrar magnitudes con escala (contadores, grillas de N elementos, barras comparadas). Enfocar lo importante (zoom de cámara al dato clave). Conservar elementos entre escenas para que se vea cómo se transforman (morph: burbujas → horarios, fotos → tarjetas, PDF → app). Sincronizar cada acción clave con su palabra (`w(escena, "palabra")`). Dejar una imagen final clara en cada escena.
- Piezas en `src/ui.tsx`: `Background`, `Label`, `Captions`, `PhoneFrame`, `WaHeader`, `Flash`, `Proof` (escena 5: kicker "TU SOLUCIÓN" + 3 beneficios sincronizados con su palabra), `CommentCTA` (cierre con la palabra), `Sfx` (whoosh, pop, notif, ding, cash, error, typing, impact, drop, swipe), `Soundtrack` (voz + música `beat1`).
- Escena 5: `Label "Solución con IA"` + `Proof` + `CommentCTA`.
- Cada acción clave lleva su efecto de sonido. Escena 1 abre con un sonido en el frame 0.
- Variar la metáfora visual. Ya usadas: cuaderno + 47 mensajes (turnos), pared de 50 "¿precio?" (catálogo), reloj 2 AM + Zzz (bot), búsqueda sin resultado + preguntas que se vuelven bloques (página), Excel → máquina → PDF + barra 1 tarde vs 3 s (informes), PDF sin abrir + mancuerna ¿? kg + curva 20 semanas (rutinas).
- Componente `src/<Nombre>.tsx` exporta `TL` y el componente; registrar en `src/Root.tsx` con id = `<id>`.

## 3. Voz, control y render
```
cd C:\Users\ignac\videos-ia
node tools/voice.mjs <id> D09EpJbk4um1HKSpeTSc 1.3   # Agustín AR, eleven_v3, acelerado 1.3x (Ignacio lo pidió así)
npx tsc -p .
npx remotion still src/index.ts <id> out/s2/<id>-<frame>.png --frame=<f> --scale=0.4   # 5–8 frames clave, mirarlos y corregir
npx remotion render src/index.ts <id> out/<id>.mp4
```
Copiar a Descargas como `solucionia-NN-<id>.mp4` (NN = siguiente `n` de videos.json). PowerShell: `(New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path`.

## 4. Panel (Vercel) — siempre, sin preguntar
Ignacio pidió (2026-11-27) que **todo video se suba al panel apenas está renderizado**, con deploy. Si es una versión nueva de un video existente, reemplaza su entrada (mismo `n`).

1. Agregar el video a `C:\Users\ignac\solucion-ia-panel\public\data\videos.json`: `{id, n, titulo, rubro, duracion: "", palabra, creado, comentario, textos: {tiktok:{texto}, instagram:{texto}, youtube:{titulo, texto}, x:{texto}}}`.
   - TikTok: gancho + 2 líneas + CTA + 5 hashtags. Reels: gancho + 3-4 ✅ beneficios + CTA + 5 hashtags. Shorts: título ≤ 70 caracteres con `#shorts` + descripción + 3 hashtags. X: ≤ 280 caracteres + 2 hashtags.
   - Cargar **`caption-writer`** para los textos de cada red (primera línea = gancho) y **`hashtag-strategy`** + **`social-seo`** para hashtags y palabras clave: máximo 5 hashtags en Instagram (límite real), de nicho y medianos antes que gigantes, rotando sets entre videos; meter las palabras que la gente busca ("turnos online", "catálogo por WhatsApp") en la primera línea del texto, porque pesan más que los hashtags. Sin lugares. No hay datos de tendencias en vivo: decirlo si Ignacio pregunta.
   - Comentario fijado: usar **`social-selling-and-dm`** (comentar la palabra → DM con consentimiento, nunca spam).
2. `node tools/sync-panel.mjs <id>` (copia el mp4 y pone duración y nombre de archivo).
3. En `C:\Users\ignac\solucion-ia-panel`: `vercel deploy --prod --yes`. **No subir el panel a Git/GitHub** (Ignacio no quiere).
4. Responder corto: link del panel, ruta en Descargas, palabra clave.

## Lo que Ignacio sabe construir (para ofrecer, no para citar como prueba)
Turnos y reservas con panel admin; catálogos con pedido por WhatsApp; bots de WhatsApp con IA (n8n); páginas web para negocios; informes automáticos Excel → PDF; apps de seguimiento (entrenamiento, clientes); automatizaciones.
