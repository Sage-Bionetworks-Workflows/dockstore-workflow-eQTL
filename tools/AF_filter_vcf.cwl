#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool
baseCommand: bcftools

inputs:
  - id: minimum_allele_frequency
    type: string
  - id: gz_vcf_file
    type: File

arguments: ["view", "-q", $(inputs.minimum_allele_frequency)]

outputs:
  - id: r2_AF_filtered_vcf
    type: File
    outputBinding: 
        glob: '*'
