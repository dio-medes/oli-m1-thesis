// this file contains definitions of notation that can be reused in other files
// to use these definitions in other files, include at the beginning
// #import "preamble.typ": *
// and then
// #show: notes
// for the thesis itself, drop the #show: notes and define that material
// in a self-contained way 
// packages used - keep minimal
#import "@preview/great-theorems:0.1.2": *
#import "@preview/rich-counters:0.2.1": *
//notes shortcuts
#let edouard(question) = text(weight: 700, fill: red, question)
// maths shortcuts
#let aset(x) = $lr({#x})$
#let why(reason) = [(#reason)]
#set text(/*font: "Arial",*/size: 14pt)
#set page(margin: (x: 2cm, y: 2cm))
// maths notation
#let bd = math.op("bd")
#let int = math.op("int")
#let cl = math.op("cl")
#let conv = math.op("conv")
#let dom = math.op("dom")
// definition, remark, theorem, lemma environments
#let mbpadding(body) = pad(left: 1em, right: 1em, body)
#let mathcounter = rich-counter(
identifier: "mathblocks",
inherited_levels: 0
)
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
// the show and set rules that are part of notes
#let notes(doc) = {
show link: text.with(fill: blue)
show math.equation.where(block: false): box
show: great-theorems-init
set text(size: 14pt)
set page(margin: (x: 2cm, y: 2cm))
doc
}