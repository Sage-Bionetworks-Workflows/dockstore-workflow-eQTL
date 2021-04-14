#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: [QTLtools, --normal]
stdout: output.txt
hints:
  DockerRequirement:
    dockerPull: sagebionetworks/dockstore-tool-qtltools

inputs:
  qtltools_analysis_type:
    type: string
    inputBinding:
      position: 1
  gz_vcf_file:
    type: File
    inputBinding:
      position: 2
      prefix: --vcf 
  bed_file:
    type: File
    inputBinding:
      position: 3
      prefix: --bed
  covariate_file:
    type: File
    inputBinding:
        position: 4
        prefix: --cov
  permutation_pass:
    type: int?
    inputBinding:
        position: 5
        prefix: --permute
  output_file_name:
    type: string
    inputBinding:
        position: 6
        prefix: --out
  match_samples:
    type: File
    inputBinding:
        position: 7
        prefix: --include-samples

outputs:
  qtl_out:
    type: File
    outputBinding:
        glob: $(inputs.output_file_name)
  qtltools_stdout_out:
    type: stdout
