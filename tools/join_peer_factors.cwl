#!/usr/bin/env cwl-runner
class: CommandLineTool
cwlVersion: v1.0
id: join_peer_factors
requirements:
  - class: DockerRequirement
    dockerPull: sagebionetworks/dockstore-tool-qtltools:latest
  - class: InitialWorkDirRequirement
    listing:
      - entryname: iterate_peer.R
        entry: |-
          #!/usr/bin/env R
          library(readr)
          library(dplyr)
          library(argparse)
          library(glue)

          # create argument options
          parser <- ArgumentParser(
            description = "Append x PEER factors to covariate matrix"
          )
          parser$add_argument("covariates", type="character",
                              help="path to txt with covariate matrix")
          parser$add_argument("peer", type="character",
                              help="path to PEER factor matrix")
          parser$add_argument("iteration", type = "double",
                              help = "number of PEER factor to include")
          args <- parser$parse_args()

          covars <- read_tsv(args$covariates)
          peer <- read_tsv(args$peer)

          dat <- bind_rows(covars, peer[0:args$iteration,])

          write.table(
            dat,
            glue("tmp_metadata_{args$iteration}.txt"),
            sep = "\t", 
            row.names = FALSE, 
            quote = FALSE
          )

arguments: ['R', 'iterate_peer.R']
inputs:
  - id: covariates
    type: File
    inputBinding:
      prefix: '--covariates'
  - id: peer_dervied_covariates
    type: File
    inputBinding:
      prefix: '--peer'
  - id: number_of_peer_factors
    type: File
    inputBinding: 
      prefix: '--iteration'
outputs: []
label: join_peer_factors.cwl