# IP-registration document build

Generates the copyright-registration deliverables in `docs/ip-registration/`:

| Output | Script |
| --- | --- |
| `diagrams/src/*.puml`, `diagrams/png/*.png` | `gen_diagrams.py` (sources: `style.py`, `arch.py`, `mobile_flows.py`, `api_flows.py`) |
| `03_Tai_lieu_ky_thuat.docx` (No.3 – ~10 pages, 4 core features) | `build_no3.js` |
| `04_Mo_ta_chuc_nang_va_kien_truc.docx` (No.4 – full description) | `build_no4.js` (content: `no4_data.js`) |

Document text is Vietnamese on purpose (legal filing for the Vietnam Copyright Office);
it is an agreed exception to the English-only rule of this repository.

## One-time setup (tools are git-ignored in `.tools/`)

```bash
cd docs/ip-registration/_build
mkdir -p .tools && cd .tools
npm init -y && npm install docx@9
curl -sSL -o plantuml.jar https://repo1.maven.org/maven2/net/sourceforge/plantuml/plantuml/1.2025.4/plantuml-1.2025.4.jar
python3 -m venv venv && venv/bin/pip install defusedxml lxml
```

Requires `java` and `node` on PATH.

## Rebuild

```bash
cd docs/ip-registration/_build
python3 gen_diagrams.py
NODE_PATH=.tools/node_modules node build_no3.js
NODE_PATH=.tools/node_modules node build_no4.js
```

- Code excerpts in No.3 are located by content (method / class signatures), so they follow code edits automatically.
- No.4 recomputes source statistics and reads the endpoint table from `docs/api/main/api-1 (1).json`.
- Screenshots come from `../screenshots/` (`shot.sh <name>` captures the booted iPhone 17 Pro Max simulator); missing files are reported as warnings.
- Word asks to refresh fields on open (table of contents); set `RENDER=1` to skip that for PDF previews.
