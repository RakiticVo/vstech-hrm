// Shared helpers for building the Vietnamese IP-registration Word documents.
const fs = require("fs");
const path = require("path");
const {
  Document, Paragraph, TextRun, HeadingLevel, AlignmentType, Table, TableRow, TableCell,
  WidthType, ShadingType, BorderStyle, ImageRun, PageBreak, TableOfContents, Footer, Header,
  PageNumber, LevelFormat, VerticalAlign, PageOrientation,
} = require("docx");

const FONT = "Times New Roman";
const MONO = "Consolas";
const TEAL = "0A544E";
const PAGE_W = 11906, MARGIN_L = 1701, MARGIN_R = 1134, MARGIN_TB = 1134;
const CONTENT_W = PAGE_W - MARGIN_L - MARGIN_R; // 9071 DXA ≈ 16 cm
const PX_PER_CM = 37.8;

// Inline **bold** and `code` markup → TextRuns.
function runs(text, base = {}) {
  const out = [];
  const re = /(\*\*[^*]+\*\*|`[^`]+`)/g;
  let last = 0, m;
  while ((m = re.exec(text))) {
    if (m.index > last) out.push(new TextRun({ text: text.slice(last, m.index), ...base }));
    const t = m[0];
    if (t.startsWith("**")) out.push(new TextRun({ text: t.slice(2, -2), bold: true, ...base }));
    else out.push(new TextRun({ text: t.slice(1, -1), font: MONO, size: 22, ...base }));
    last = m.index + t.length;
  }
  if (last < text.length) out.push(new TextRun({ text: text.slice(last), ...base }));
  return out;
}

const P = (text, opts = {}) => new Paragraph({
  children: runs(text, opts.run || {}),
  alignment: opts.align || AlignmentType.JUSTIFIED,
  spacing: { after: opts.after ?? 120, before: opts.before ?? 0, line: 300 },
  indent: opts.indent,
  keepNext: opts.keepNext,
});
const H1 = (t) => new Paragraph({ heading: HeadingLevel.HEADING_1, children: [new TextRun(t)], pageBreakBefore: true });
const H1n = (t) => new Paragraph({ heading: HeadingLevel.HEADING_1, children: [new TextRun(t)] });
const H2 = (t) => new Paragraph({ heading: HeadingLevel.HEADING_2, children: [new TextRun(t)], keepNext: true });
const H3 = (t) => new Paragraph({ heading: HeadingLevel.HEADING_3, children: [new TextRun(t)], keepNext: true });
const B = (text, level = 0) => new Paragraph({
  children: runs(text), numbering: { reference: "bullets", level },
  alignment: AlignmentType.JUSTIFIED, spacing: { after: 60, line: 288 },
});
const N = (text, instance = 1) => new Paragraph({
  children: runs(text), numbering: { reference: "steps", level: 0, instance },
  alignment: AlignmentType.JUSTIFIED, spacing: { after: 60, line: 288 },
});
const BR = () => new Paragraph({ children: [new PageBreak()] });
const SP = (after = 120) => new Paragraph({ children: [], spacing: { after } });

const border = { style: BorderStyle.SINGLE, size: 4, color: "94A3B8" };
const borders = { top: border, bottom: border, left: border, right: border };

function cell(content, width, { header = false, shade, bold = false, align, size } = {}) {
  const paras = (Array.isArray(content) ? content : [content]).map((c) =>
    c instanceof Paragraph ? c : new Paragraph({
      children: runs(String(c), { bold: header || bold, size: size || 22, color: header ? "FFFFFF" : undefined }),
      alignment: align || (header ? AlignmentType.CENTER : AlignmentType.LEFT),
      spacing: { after: 40, line: 264 },
    }));
  return new TableCell({
    children: paras, width: { size: width, type: WidthType.DXA }, borders,
    verticalAlign: VerticalAlign.CENTER,
    shading: header ? { fill: TEAL, type: ShadingType.CLEAR, color: "auto" }
      : shade ? { fill: shade, type: ShadingType.CLEAR, color: "auto" } : undefined,
    margins: { top: 60, bottom: 60, left: 100, right: 100 },
  });
}

// widths are fractions (sum 1) or DXA numbers
function table(headers, rows, widths, { zebra = true, size } = {}) {
  const total = CONTENT_W;
  const w = widths.map((x) => (x <= 1 ? Math.round(x * total) : x));
  w[w.length - 1] += total - w.reduce((a, b) => a + b, 0);
  const trs = [];
  if (headers) trs.push(new TableRow({ tableHeader: true, children: headers.map((h, i) => cell(h, w[i], { header: true })) }));
  rows.forEach((r, ri) => trs.push(new TableRow({
    cantSplit: true,
    children: r.map((c, i) => cell(c, w[i], { shade: zebra && ri % 2 === 1 ? "F0FDFA" : undefined, size })),
  })));
  return new Table({ width: { size: total, type: WidthType.DXA }, columnWidths: w, rows: trs });
}

// Key/value info table (2 columns, first shaded)
function kv(rows, w1 = 0.32) {
  const a = Math.round(CONTENT_W * w1), b = CONTENT_W - a;
  return new Table({
    width: { size: CONTENT_W, type: WidthType.DXA }, columnWidths: [a, b],
    rows: rows.map(([k, v]) => new TableRow({ cantSplit: true, children: [cell(k, a, { shade: "E6F4F1", bold: true }), cell(v, b)] })),
  });
}

function pngSize(file) {
  const buf = fs.readFileSync(file);
  return { w: buf.readUInt32BE(16), h: buf.readUInt32BE(20), buf };
}

let figNo = 0;
function figure(file, caption, { maxWcm = 16, maxHcm = 22 } = {}) {
  const { w, h, buf } = pngSize(file);
  const scale = Math.min((maxWcm * PX_PER_CM) / w, (maxHcm * PX_PER_CM) / h);
  figNo += 1;
  return [
    new Paragraph({
      alignment: AlignmentType.CENTER, keepNext: true, spacing: { before: 120, after: 60 },
      children: [new ImageRun({ type: "png", data: buf, transformation: { width: Math.round(w * scale), height: Math.round(h * scale) },
        altText: { title: caption, description: caption, name: path.basename(file) } })],
    }),
    new Paragraph({
      alignment: AlignmentType.CENTER, spacing: { after: 200 },
      children: [new TextRun({ text: `Hình ${figNo}. `, bold: true, italics: true, size: 22 }), new TextRun({ text: caption, italics: true, size: 22 })],
    }),
  ];
}

// Two screenshots side by side (borderless table), each with its own caption.
function figurePair(items, { wcm = 6.6 } = {}) {
  const half = Math.round(CONTENT_W / 2);
  const none = { style: BorderStyle.NONE, size: 0, color: "FFFFFF" };
  const nob = { top: none, bottom: none, left: none, right: none };
  const cells = items.map(([file, caption]) => {
    const { w, h, buf } = pngSize(file);
    const scale = (wcm * PX_PER_CM) / w;
    figNo += 1;
    return new TableCell({
      width: { size: half, type: WidthType.DXA }, borders: nob,
      children: [
        new Paragraph({ alignment: AlignmentType.CENTER, children: [new ImageRun({ type: "png", data: buf,
          transformation: { width: Math.round(w * scale), height: Math.round(h * scale) },
          altText: { title: caption, description: caption, name: path.basename(file) } })] }),
        new Paragraph({ alignment: AlignmentType.CENTER, spacing: { before: 60, after: 160 },
          children: [new TextRun({ text: `Hình ${figNo}. `, bold: true, italics: true, size: 21 }), new TextRun({ text: caption, italics: true, size: 21 })] }),
      ],
    });
  });
  while (cells.length < 2) cells.push(new TableCell({ width: { size: half, type: WidthType.DXA }, borders: nob, children: [new Paragraph("")] }));
  return new Table({ width: { size: CONTENT_W, type: WidthType.DXA }, columnWidths: [half, CONTENT_W - half],
    borders: { top: none, bottom: none, left: none, right: none, insideHorizontal: none, insideVertical: none },
    rows: [new TableRow({ cantSplit: true, children: cells })] });
}

// Placeholder box (e.g. section to be filled by another team)
function placeholder(text, height = 1) {
  const p = [];
  for (let i = 0; i < height; i++) p.push(new Paragraph({ children: [], spacing: { after: 0 } }));
  const dash = { style: BorderStyle.DASHED, size: 8, color: "B91C1C" };
  return new Table({
    width: { size: CONTENT_W, type: WidthType.DXA }, columnWidths: [CONTENT_W],
    rows: [new TableRow({ children: [new TableCell({
      width: { size: CONTENT_W, type: WidthType.DXA },
      borders: { top: dash, bottom: dash, left: dash, right: dash },
      shading: { fill: "FFF8EC", type: ShadingType.CLEAR, color: "auto" },
      margins: { top: 120, bottom: 120, left: 160, right: 160 },
      children: [new Paragraph({ alignment: AlignmentType.CENTER, children: runs(text, { italics: true, color: "B91C1C" }) }), ...p],
    })] })],
  });
}

// Source-code block with line numbers, shaded, monospace.
function code(source, { title, startLine = 1, size = 17 } = {}) {
  const lines = source.replace(/\t/g, "  ").split("\n");
  const width = String(startLine + lines.length - 1).length;
  const paras = [];
  if (title) paras.push(new Paragraph({ spacing: { after: 60 }, children: [new TextRun({ text: title, font: MONO, size: 18, bold: true, color: TEAL })] }));
  lines.forEach((ln, i) => {
    const no = String(startLine + i).padStart(width, " ");
    paras.push(new Paragraph({
      spacing: { after: 0, line: 228 },
      children: [new TextRun({ text: no + "  ", font: MONO, size, color: "94A3B8" }), new TextRun({ text: ln || " ", font: MONO, size })],
    }));
  });
  const b = { style: BorderStyle.SINGLE, size: 4, color: "CBD5E1" };
  return new Table({
    width: { size: CONTENT_W, type: WidthType.DXA }, columnWidths: [CONTENT_W],
    rows: [new TableRow({ children: [new TableCell({
      width: { size: CONTENT_W, type: WidthType.DXA }, borders: { top: b, bottom: b, left: { style: BorderStyle.SINGLE, size: 18, color: "0F766E" }, right: b },
      shading: { fill: "F8FAFC", type: ShadingType.CLEAR, color: "auto" },
      margins: { top: 100, bottom: 100, left: 140, right: 100 }, children: paras,
    })] })],
  });
}

function toc() {
  return [
    new Paragraph({ alignment: AlignmentType.CENTER, spacing: { after: 240 }, children: [new TextRun({ text: "MỤC LỤC", bold: true, size: 30, color: TEAL })] }),
    new TableOfContents("Mục lục", { hyperlink: true, headingStyleRange: "1-3" }),
  ];
}

function coverPage({ docType, title, subtitle, meta }) {
  const line = () => new Paragraph({ alignment: AlignmentType.CENTER, border: { bottom: { style: BorderStyle.SINGLE, size: 12, color: "F59E0B", space: 4 } }, children: [], spacing: { after: 240 } });
  const c = (text, size, opts = {}) => new Paragraph({ alignment: AlignmentType.CENTER, spacing: { after: opts.after ?? 120 }, children: [new TextRun({ text, size, bold: opts.bold, color: opts.color, italics: opts.italics })] });
  return [
    c("[TÊN CƠ QUAN / CÔNG TY CHỦ SỞ HỮU]", 26, { bold: true }),
    c("———————", 22, { after: 1200 }),
    c(docType, 30, { bold: true, color: TEAL, after: 200 }),
    line(),
    c(title, 40, { bold: true, color: TEAL, after: 200 }),
    c(subtitle, 26, { italics: true, after: 900 }),
    kv(meta, 0.36),
    c("", 22, { after: 1400 }),
    c("[Địa danh], ngày … tháng … năm 2026", 24, { italics: true }),
  ];
}

function pageHeader(headerText) {
  return {
    headers: { default: new Header({ children: [new Paragraph({ alignment: AlignmentType.RIGHT, border: { bottom: { style: BorderStyle.SINGLE, size: 4, color: "94A3B8", space: 2 } },
      children: [new TextRun({ text: headerText, size: 18, italics: true, color: "5B6572" })] })] }) },
    footers: { default: new Footer({ children: [new Paragraph({ alignment: AlignmentType.CENTER,
      children: [new TextRun({ text: "Trang ", size: 20 }), new TextRun({ children: [PageNumber.CURRENT], size: 20 }), new TextRun({ text: " / ", size: 20 }), new TextRun({ children: [PageNumber.TOTAL_PAGES], size: 20 })] })] }) },
  };
}

// Landscape pages (used for sequence diagrams): image box ≈ 26.5 × 16 cm.
const LANDSCAPE_MARGIN = { top: 680, bottom: 680, left: 850, right: 850 };

// sections: [{ children, landscape?, titlePage? }]  (or pass `children` for a single portrait section)
function makeDoc({ title, children, headerText, titlePage = true, sections }) {
  const secs = sections || [{ children, titlePage }];
  return new Document({
    creator: "[Chủ sở hữu]", title, description: title,
    styles: {
      default: { document: { run: { font: FONT, size: 26 } } },
      paragraphStyles: [
        { id: "Heading1", name: "Heading 1", basedOn: "Normal", next: "Normal", quickFormat: true,
          run: { size: 32, bold: true, font: FONT, color: TEAL }, paragraph: { spacing: { before: 240, after: 200 }, outlineLevel: 0 } },
        { id: "Heading2", name: "Heading 2", basedOn: "Normal", next: "Normal", quickFormat: true,
          run: { size: 28, bold: true, font: FONT, color: TEAL }, paragraph: { spacing: { before: 240, after: 120 }, outlineLevel: 1 } },
        { id: "Heading3", name: "Heading 3", basedOn: "Normal", next: "Normal", quickFormat: true,
          run: { size: 26, bold: true, italics: true, font: FONT, color: "0F766E" }, paragraph: { spacing: { before: 120, after: 80 }, outlineLevel: 2 } },
      ],
    },
    numbering: { config: [
      { reference: "bullets", levels: [
        { level: 0, format: LevelFormat.BULLET, text: "•", alignment: AlignmentType.LEFT, style: { paragraph: { indent: { left: 567, hanging: 283 } } } },
        { level: 1, format: LevelFormat.BULLET, text: "–", alignment: AlignmentType.LEFT, style: { paragraph: { indent: { left: 1134, hanging: 283 } } } },
      ] },
      { reference: "steps", levels: [
        { level: 0, format: LevelFormat.DECIMAL, text: "%1.", alignment: AlignmentType.LEFT, style: { paragraph: { indent: { left: 567, hanging: 340 } } } },
      ] },
    ] },
    // Word asks to refresh the TOC on open; set RENDER=1 to skip (for PDF previews).
    features: { updateFields: process.env.RENDER !== "1" },
    sections: secs.map((sec) => ({
      properties: {
        page: sec.landscape
          ? { size: { width: PAGE_W, height: 16838, orientation: PageOrientation.LANDSCAPE }, margin: LANDSCAPE_MARGIN }
          : { size: { width: PAGE_W, height: 16838 }, margin: { top: MARGIN_TB, bottom: MARGIN_TB, left: MARGIN_L, right: MARGIN_R } },
        titlePage: !!sec.titlePage,
      },
      ...pageHeader(headerText),
      children: sec.children,
    })),
  });
}

// Exact excerpt of a source file located by content (survives line shifts).
//   start: regex for the first line; back: lines to include above it (e.g. @override / doc comment)
//   end:   regex for the last line, or omitted → end of the brace block opened on/after the start line
//   endBlock: regex of a line whose brace block ends the excerpt (e.g. "Map<String, dynamic> toJson\\(")
//   after: only search for `start` below the first line matching this regex (e.g. the Impl class)
function excerpt(repo, rel, { start, back = 0, end, endBlock, after }) {
  const lines = fs.readFileSync(path.join(repo, rel), "utf8").split("\n");
  const ai = after ? lines.findIndex((l) => new RegExp(after).test(l)) : 0;
  const si = lines.findIndex((l, i) => i >= ai && new RegExp(start).test(l));
  if (si < 0) throw new Error(`excerpt: "${start}" not found in ${rel}`);
  const from = si - back;
  let to;
  const blockEnd = (i0) => {
    let depth = 0, opened = false;
    for (let i = i0; i < lines.length; i++) {
      for (const ch of lines[i]) {
        if (ch === "{") { depth++; opened = true; } else if (ch === "}") depth--;
      }
      if (opened && depth <= 0) return i;
    }
    throw new Error(`excerpt: unbalanced block in ${rel}`);
  };
  if (end) to = lines.findIndex((l, i) => i > si && new RegExp(end).test(l));
  else if (endBlock) to = blockEnd(lines.findIndex((l, i) => i >= si && new RegExp(endBlock).test(l)));
  else to = blockEnd(si);
  return { text: lines.slice(from, to + 1).join("\n"), from: from + 1, to: to + 1 };
}

module.exports = { P, H1, H1n, H2, H3, B, N, BR, SP, table, kv, figure, figurePair, placeholder, code, toc, coverPage, makeDoc, runs, excerpt, CONTENT_W, TEAL };
