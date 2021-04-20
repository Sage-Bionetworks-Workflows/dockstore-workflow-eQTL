#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool
baseCommand: bgzip

requirements:
  - class: DockerRequirement
    dockerPull: sagebionetworks/dockstore-tool-qtltools

inputs: 
  - id: input_bgzip
    type: File
    inputBinding: 
        position: 1

outputs:
  - id: output_bgzip
    type: File 
    outputBinding:
        glob: '*.bed.gz'