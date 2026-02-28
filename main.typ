#import "@preview/touying:0.6.1": *
#import themes.metropolis: *
#import "@preview/fletcher:0.5.8": diagram, edge, node
#import "@preview/fletcher:0.5.8": shapes as fletcher-shapes
#import "@preview/showybox:2.0.4": showybox

#let blue = blue.darken(30%)
#set text(font: "Source Serif Pro")
#show: metropolis-theme.with(
  aspect-ratio: "16-9",
  config-colors(
    primary: rgb("#0070af"),
    secondary: rgb("#0070af"),
    neutral-lightest: white,
  ),
  config-info(
    logo: image("assets/TU_Signet_white.png", height: 1.3cm),
  ),
  progress-bar: true,
)

#title-slide(
  title: text(size: 30pt)[
    rusty-tip \
    Automating STM/NC-AFM Tip Preparation
  ],
  subtitle: [],
  author: [Martin Kronberger --- #link("https://github.com/kronberger-droid")[]github.com/kronberger-droid],
  institution: [Institute for Applied Physics -- Surface Physics Group \ Technical University Vienna],
  date: datetime.today().display("[month repr:long] [day], [year]"),
  logo: image("assets/TU_Signet.pdf", width: 3cm),
)

// ─── Helper: colored box ───
#let box(body, ..opts) = {
  showybox(
    frame: (
      border-color: rgb("#0070af"),
      title-color: rgb("#0070af"),
      thickness: 1pt,
    ),
    ..opts,
    [
      #align(center)[#body]
    ],
  )
}

// ─── Helper: two-column slide (content left, image right) ───
#let img-slide(img, body, source: none) = {
  grid(
    columns: (1fr, 1fr),
    column-gutter: 1.5em,
    align(horizon, body),
    align(horizon + center, block(height: 100%, {
      align(horizon + center, img)
      if source != none {
        place(bottom + right, text(size: 0.5em, fill: luma(120), source))
      }
    })),
  )
}

#slide(title: "Content")[
  #components.adaptive-columns(outline(
    title: none,
    indent: 1em,
    target: heading.where(level: 2),
  ))
]

== Introduction


#slide[
  #img-slide(
    image("assets/Al2O3(0001)_B3_0017.png", height: 85%),
    [
      - SPM imaging quality depends critically on the *tip*

      - Tip preparation is a manual, experience-driven process

      - Goal: develop a software framework in Rust to *automate tip preparation* for STM/ncAFM

      - Make the process more *reproducible* and less reliant on individual expertise
    ],
    source: [Hütner et al. (2024) #super[\[2\]]],
  )
]

== Scanning Tunneling Microscope (STM)

#slide[
  #img-slide(
    image("assets/spm-basics-stm.drawio.pdf", width: 100%),
    [
      - A bias voltage is applied between tip and sample

      - Electrons tunnel across the vacuum gap

      - The tunneling current $I$ depends exponentially on the tip--sample distance

      - Feedback keeps $I$ constant $arrow.r$ tip traces the surface topography
    ],
  )
]

== Non Contact Atomic Force Microscope (ncAFM)

#slide[
  #img-slide(
    {
      only("1", image("assets/spm-basics-ncAFM-1.drawio.pdf", width: 100%))
      only("2", image("assets/spm-basics-ncAFM-2.drawio.pdf", width: 100%))
    },
    [
      === Non-Contact AFM
      - Cantilever vibrates at its resonance frequency

      - Tip--surface interaction shifts the frequency by $Delta f$

      - $Delta f$ is proportional to the force gradient

      - A low negative $Delta f$ at the surface often indicates a *sharp tip*
    ],
  )
]

== Tip Preparation Workflow

#slide[
  #img-slide(
    image("assets/Cu_tip.png", height: 80%),
    [
      === What We Can Automate Now
      - *Shape* tip on Au(110), coat with Cu on Cu(110)

      - Pulse and reposition until $Delta f$ is in the sharp range

      - Verify tip stability via bias sweep
    ],
    source: [Courtesy of D. Kugler],
  )
]

#slide[
  #img-slide(
    image("assets/MgAl2O4(001)_A02_0152.png", height: 80%),
    [
      === What Comes Next
      - Dose O#sub[2] on Cu(110) $arrow.r$ CuOx rows

      - Dip tip into CuOx rows to pick up a cluster

      - Image a known surface to verify the tip produces the *expected atomic contrast* #super[\[1\]]

      - Check tip symmetry by looking at surface impurities
    ],
    source: [Courtesy of D. Kugler],
  )
]

== Software Architecture

#slide[
  #img-slide(
    image("assets/architecture-nanonis-rs.drawio.pdf", height: 90%),
    [
      === nanonis-rs #super[\[3\]]
      - Low-level TCP protocol and parser

      - Covers *all* functions available on Nanonis-controlled machines

      - High-throughput TCP logger
    ],
  )
]

#slide[
  #img-slide(
    image("assets/architecture-action-driver.drawio.pdf", height: 90%),
    [
      === Action Driver
      - Higher-level abstraction over nanonis-rs

      - *Action-based system*: each action combines multiple low-level calls

      - Makes it possible to log metric and metadata for actions

      - Buffered TCP reader for data history analysis
    ],
  )
]

#slide[
  #img-slide(
    image("assets/architecture-rusty-tip.drawio.pdf", height: 90%),
    [
      === rusty-tip #super[\[4\]] \ \

      - Uses the Action Driver under the hood

      - *State machine* correlating machine states with action loops

      - Three states: *Blunt* $arrow.r$ *Sharp* $arrow.r$ *Stable*

      - Logs important metrics for actions
    ],
  )
]

== Outlook

#slide[
  - Automate *tip conditioning* and verification

  - Use *image recognition* to evaluate tip quality from images

  - Optimize action parameters like pulse voltage via Bayesian optimization

  - Extend nanonis-rs to support other SPM workflows beyond tip preparation

  - Long-term: fully autonomous experiment --- from tip prep to data acquisition
]

#title-slide(
  title: text(size: 30pt)[
    rusty-tip \
    Automating STM/NC-AFM Tip Preparation
  ],
  subtitle: [],
  author: [Martin Kronberger --- #link("https://github.com/kronberger-droid")[]github.com/kronberger-droid],
  institution: [Institute for Applied Physics -- Surface Physics Group \ Technical University Vienna],
  date: datetime.today().display("[month repr:long] [day], [year]"),
  logo: image("assets/TU_Signet.pdf", width: 3cm),
)

== References

#slide[
  #set text(size: 0.65em)
  + Mönig et al., "Submolecular imaging by noncontact atomic force microscopy with an oxygen-terminated copper tip," _Nanoscale_ *13*, 18624 (2021). \
    #link("https://doi.org/10.1039/d1nr04080d")

  + Hütner et al., "Stoichiometric reconstruction of the Al#sub[2]O#sub[3]\(0001\) surface," _Science_ *385*, 1241--1244 (2024). \
    #link("https://doi.org/10.1126/science.adq4744")

  + nanonis-rs --- #link("https://github.com/kronberger-droid/nanonis-rs")

  + rusty-tip --- #link("https://github.com/kronberger-droid/rusty-tip")
]

