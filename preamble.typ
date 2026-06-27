// this file contains definitions of notation that can be reused in other files
// to use these definitions in other files, include at the beginning
// #import "preamble.typ": *
// and then
// #show: notes
// for the thesis itself, drop the #show: notes and define that material
// in a self-contained way 
// packages used - keep minimal
// #import "@preview/great-theorems:0.1.2": *
#import "@preview/rich-counters:0.2.1": *
#import "@preview/ctheorems:1.1.3": *
// maths shortcuts
#let aset(x) = $lr({#x})$
#let why(reason) = [(#reason)]
#set text(/*font: "Arial",*/size: 14pt)
#set page(margin: (x: 2cm, y: 2cm))
#let seqfull(x, i) = $#x#h(0pt)scripts(""_(#i))$ // seqfull({x_k}, k >= 0)
//#let makebig(x) = math.lr(x, size: 150%)
#let chsym(s) = box(height: 12pt, text(14pt, s))
// maths notation
#let bd = math.op("bd")
#let int = math.op("int")
#let cl = math.op("cl")
#let conv = math.op("conv")
#let dom = math.op("dom")
#let argmin = math.op("argmin", limits: true)
#let minimise = math.op("minimise", limits: true)
// text shortcuts
#let Lsmooth = box([$L$--smooth])
#let Lsmoothness = box([$L$--smoothness])
#let Llips = box([$L$--Lipschitz])
// definition, remark, theorem, lemma environments
#let mbpadding(body) = pad(left: 1em, right: 1em, body)
#let mathcounter = rich-counter(
identifier: "mathblocks",
inherited_levels: 0
)
/*
#let definition = mathblock(
  blocktitle: "Definition",
  counter: mathcounter,
  inset: (x: 1em, y: 0em)
)
#let theorem = mathblock(
blocktitle: "Theorem",
counter: mathcounter,
inset: (x: 1em, y: 0em)
)
#let corollary = mathblock(
blocktitle: "Corollay",
counter: mathcounter,
inset: (x: 1em, y: 0em)
)
#let lemma = mathblock(
blocktitle: "Lemma",
counter: mathcounter,
inset: (x: 1em, y: 0em)
)
#let proposition = mathblock(
blocktitle: "Proposition",
counter: mathcounter,
(x: 1em, y: 0em)
)
#let remark = mathblock(
blocktitle: "Remark",
prefix: [_Remark._],
inset: (x: 1em, y: 0em)
)
#let centrebox(content) = {
align(center, box(stroke: black, inset: 10%)[#content])
}
#let proof = mathblock(
blocktitle: "Proof",
prefix: [_Proof._],
suffix: [#h(1fr) $qed$],
)
*/
#let theorem = thmbox("theorem", "Theorem")
#let lemma = thmbox("theorem", "Lemma", inset: (x: 1em, top: 0em))
#let corollary = thmbox(
  "theorem",
  "Corollary",
)
#let definition = thmbox("theorem", "Definition", inset: (x: 1em, top: 0em))

#let example = thmplain("example", "Example").with(numbering: none)
#let proof = thmproof("proof", "Proof", inset: (x: 1em, top: 0em))
// the show and set rules that are part of notes
#let notes(doc) = {
set heading(numbering: "1.")
show link: text.with(fill: blue)
show math.equation.where(block: false): box
show: thmrules
set text(size: 12pt)
set page(margin: (x: 2cm, y: 2cm))
doc
}
// the show and set rules that are part of thesis
#let thesis(doc) = {
set heading(numbering: "1.")
show link: text.with(fill: blue)
show math.equation.where(block: false): box
show: great-theorems-init
set text(size: 12pt)
doc
}
