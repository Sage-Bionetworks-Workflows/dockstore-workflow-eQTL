 #!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool
baseCommand: tabix

requirements:
  - class: DockerRequirement
    dockerPull: sagebionetworks/dockstore-tool-qtltools:latest

inputs: 
  - id: file_type
    type: string
    inputBinding:
      position: 1
      prefix: -p
  - id: input_bed_or_vcf
    type: File
    inputBinding: 
      position: 2

outputs:
  - id: output_tabix
    type: File 
    outputBinding:
      glob: '*'