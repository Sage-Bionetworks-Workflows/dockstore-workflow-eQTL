#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool
baseCommand: synapse

hints:
  - class: DockerRequirement
    dockerPull: sagebionetworks/synapsepythonclient:v2.2.2

inputs:
  - id: synapse_config
    type: File
  - id: synapseid
    type: string

requirements:
  - class: InitialWorkDirRequirement
    listing:
      - entryname: .synapseConfig
        entry: $(inputs.synapse_config)

arguments:
  - valueFrom: get
  - valueFrom: $(inputs.synapseid)
     
outputs:
  - id: filepath
    type: File
    outputBinding:
      glob: '*'