#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool
baseCommand: awk

requirements:
  - class: DockerRequirement
    dockerPull: sagebionetworks/dockstore-tool-qtltools:latest

inputs: 
  - id: input_qtls
    type: File

arguments: ['{ if($6 > 0) { print }}']

outputs:
  - id: filtered_qtls
    type: File 
