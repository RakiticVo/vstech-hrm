"""Generate PlantUML sources + PNGs for the IP-registration documents.

Usage:  python3 docs/ip-registration/_build/gen_diagrams.py
Needs:  java + .tools/plantuml.jar (see README.md in this folder).

Sequence diagrams: 2 tiers per flow – Mobile (split into parts) and Backend skeleton.
A readability report is printed: effective font size once the image is fitted
on a landscape A4 page (see PAGE_* below).
"""
import json
import pathlib
import re
import struct
import subprocess
import sys

HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
from style import seq, generic  # noqa: E402
from mobile_flows import MOBILE  # noqa: E402
from api_flows import backend_parts  # noqa: E402
from arch import ARCH  # noqa: E402

OUT = HERE.parent / "diagrams"
SRC = OUT / "src"
PNG = OUT / "png"
JAR = HERE / ".tools" / "plantuml.jar"
DPI = 160
PAGE_W_CM, PAGE_H_CM = 26.5, 16.3   # image box on a landscape page (see build_no4.js)
FONT_PT = 12
MIN_FONT_PT = 7.5

KEEP_TAGS = ("b", "/b", "i", "/i", "u", "/u", "size", "/size", "color", "/color")


def sanitize(text: str) -> str:
    def repl(m: re.Match) -> str:
        inner = m.group(1)
        head = inner.split(":")[0].split(" ")[0]
        if head in KEEP_TAGS or inner.startswith("<"):
            return m.group(0)
        return "‹" + inner + "›"
    return re.sub(r"<([^<>\n]{1,60})>", repl, text)


def write(name: str, content: str) -> None:
    keep = content.replace("<<PK>>", "§PK§").replace("<<FK>>", "§FK§")
    cleaned = sanitize(keep).replace("§PK§", "<<PK>>").replace("§FK§", "<<FK>>")
    (SRC / f"{name}.puml").write_text(cleaned, encoding="utf-8")


def main() -> None:
    SRC.mkdir(parents=True, exist_ok=True)
    PNG.mkdir(parents=True, exist_ok=True)
    for d in (SRC, PNG):
        for f in d.iterdir():
            if f.suffix in (".puml", ".png", ".json"):
                f.unlink()
    manifest = {}
    for name, (title, body) in ARCH.items():
        write(name, generic(title, body))
    for code, (title, header, parts) in MOBILE.items():
        entry = {"title": title, "mobile": [], "backend": []}
        n = len(parts)
        for i, (ptitle, body) in enumerate(parts):
            name = f"{code}_1_mobile_{chr(97 + i)}"
            sub = f"Mobile – Phần {i + 1}/{n}: {ptitle}" if n > 1 else f"Mobile – {ptitle}"
            write(name, seq(f"{code} · {title}\\n<size:12>{sub}</size>", header + "\nhide unlinked\n" + body))
            entry["mobile"].append({"file": name, "subtitle": sub})
        bparts = backend_parts(code)
        for i, body in enumerate(bparts):
            name = f"{code}_2_backend_{chr(97 + i)}"
            sub = (f"Backend – Phần {i + 1}/{len(bparts)}" if len(bparts) > 1 else "Backend") + " (khung – bổ sung sau)"
            write(name, seq(f"{code} · {title}\\n<size:12>{sub}</size>", body))
            entry["backend"].append({"file": name, "subtitle": sub})
        manifest[code] = entry
    (OUT / "manifest.json").write_text(json.dumps(manifest, ensure_ascii=False, indent=1), encoding="utf-8")
    files = sorted(str(p) for p in SRC.glob("*.puml"))
    subprocess.run(["java", "-Djava.awt.headless=true", "-DPLANTUML_LIMIT_SIZE=16384", "-jar", str(JAR),
                    "-charset", "UTF-8", "-tpng", "-o", str(PNG), *files], check=True)
    # Readability report for sequence diagrams.
    bad = 0
    for p in sorted(PNG.glob("SD*.png")):
        w, h = struct.unpack(">II", p.read_bytes()[16:24])
        w_cm, h_cm = w / DPI * 2.54, h / DPI * 2.54
        scale = min(1.0, PAGE_W_CM / w_cm, PAGE_H_CM / h_cm)
        font = FONT_PT * scale
        flag = "  <-- too small" if font < MIN_FONT_PT else ""
        bad += bool(flag)
        print(f"{p.stem:24s} {w:5d}x{h:<5d} font≈{font:4.1f}pt{flag}")
    print(f"{len(files)} diagrams → {PNG}  ({bad} below {MIN_FONT_PT}pt)")


if __name__ == "__main__":
    main()
