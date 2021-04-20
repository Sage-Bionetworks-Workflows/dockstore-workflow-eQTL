#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool
baseCommand: bcftools

inputs:
  - id: r2_threshold
    type: string
  - id: samples_to_include
    type: File
  - id: gz_vcf_file
    type: File

arguments: ["view", "-i", $(inputs.r2_threshold), "-S", $(inputs.samples_to_include), $(inputs.gz_vcf_file)]

outputs:
  - id: r2_filtered_vcf
    type: File
    outputBinding: 
        glob: '*'
