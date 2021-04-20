#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: [QTLtools, --normal]
stdout: output.txt
requirements:
  - class: DockerRequirement
    dockerPull: sagebionetworks/dockstore-tool-qtltools:latest

inputs:
  - id: qtltools_analysis_type
    type: string
    inputBinding:
      position: 1
  - id: gz_vcf_file
    type: File
    inputBinding:
      position: 2
      prefix: --vcf 
  - id: bed_file
    type: File
    inputBinding:
      position: 3
      prefix: --bed
  - id: covariate_file
    type: File
    inputBinding:
        position: 4
        prefix: --cov
  - id: permutation_pass
    type: int?
    inputBinding:
        position: 5
        prefix: --permute
  - id: output_file_name
    type: string
    inputBinding:
        position: 6
        prefix: --out
  - id: match_samples
    type: File
    inputBinding:
        position: 7
        prefix: --include-samples

arguments: [$(inputs.qtltools_analysis_type), "--vcf", $(inputs.gz_vcf_file), "--bed", $(inputs.bed_file), "--cov", $(inputs.covariate_file), "--permute", $(inputs.permutation_pass), "--out", $(inputs.output_file_name), "--normal", "--include-samples", $(inputs.match_samples)]

outputs:
  - id: qtl_out
    type: File
    outputBinding:
        glob: $(inputs.output_file_name)
  - id: qtltools_stdout_out
    type: stdout
