#import "@preview/touying:0.6.1": *
#import themes.metropolis: *
#import "@preview/fletcher:0.5.8": diagram, edge, node, shapes.diamond
#import "@preview/showybox:2.0.4": showybox
#import "@preview/plotsy-3d:0.2.1": *

#let blue = blue.darken(30%)
#set text(font: "Source Serif Pro")
#show: metropolis-theme.with(
  aspect-ratio: "16-9",
  config-colors(
    primary: blue,
    secondary: blue,
  ),
  progress-bar: true,
)

#title-slide(
  title: text(size: 30pt)[
    rusty-tip \
    Automating STM/NC-AFM Tip Preparation
  ],
  subtitle: [
  ],
  authors: [Martin Kronberger],
  institution: [Institute for Applied Physics -- Surface Physics Group \ Technical University Vienna],
  date: datetime.today().display("[month repr:long] [day], [year]"),
)

#let box(body, ..opts) = {
  showybox(
    frame: (
      border-color: blue,
      title-color: blue,
      thickness: 1pt,
    ),
    ..opts,
    [
      #align(center)[#body]
    ],
  )
}
== Tip Preparation: The basics


#slide(
  [
    some content
  ],
)

== Why only for AFM

#slide(
  [
    some content
  ],
)

