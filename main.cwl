#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow

inputs:
  - id: synapse_config
    type: File
  - id: synId_chromosome_vcf
    type: string
  - id: synId_covariates
    type: string
  - id: synId_peer
    type: string
  - id: synId_geneExpression
    type: string
  - id: synId_sample_list
    type: string
  - id: numPeer
    type: int
  - id: permutation_pass
    type: int
  - id: cohort
    type: string
  - id: tissue
    type: string
  - id: cellType
    type: string
  - id: minimum_allele_frequency
    type: string
  - id: r2_threshold
    type: string
  - id: qtltype
    type: string
  - id: file_type_bed
    type: string
  - id: file_type_vcf
    type: string

outputs:
  echo_out:
    type: string
    outputSource: echo/echo_out

steps:
  - id: vcf
    in: 
      - id: synapse_config
        source: synapse_config
      - id: synapseid
        source: synId_chromosome_vcf
    out:
      - id: filepath
      #add scatter to run synapse get over all vcfs
    run: tools/synapse-get-tool.cwl
  - id: bed
    in:
      - id: synapse_config
        source: synapse_config
      - id: synapseid
        source: synId_geneExpression
    out:
      - id: filepath
    run: tools/synapse-get-tool.cwl
  - id: covariates
    in: 
      - id: synapse_config
        source: synapse_config
      - id: synapseid
        source: synId_covariates
    out: 
      - id: filepath
    run: tools/synapse-get-tool.cwl
  - id: gene_expression
    in: 
      - id: synapse_config
        source: synapse_config
      - id: synapseid
        source: synId_geneExpression
    out:
      - id: filepath 
    run: tools/synapse-get-tool.cwl
  - id: peer_dervied_covariates
    in:
      - id: synapse_config
        source: synapse_config
      - id: synapseid
        source: synId_peer
    out: 
      - id: filepath
    run: tools/synapse-get-tool.cwl
  - id: samples_to_include
    in: 
      - id: synapse_config
        source: synapse_config
      - id: synapseid
        source: synId_sample_list
    out: 
      - id: filepath
    run: tools/synapse-get-tool.cwl
  - id: bgzip_bed
    in: 
      - id: bgzip_bed_file
        source: gene_expression/filepath
    out: 
      - id: compressed_bed
    run: tools/bgzip.cwl
  - id: index_genome
    in: 
      - id: file_type
        source: file_type_bed
      - id: input_bed_or_vcf
        source: bgzip_bed/compressed_bed
    out: 
      - id: compressed_indexed_bed
    run: tools/index.cwl
  - id: filter_vcf_by_r2
    in:
      - id: r2_threshold
        source: r2_threshold
      - id: ###needs id
        source: samples_to_include/filepath
    out:
      - id: r2_filtered_vcf
    run: tools/r2_filter_vcf.cwl
  - id: filter_vcf_by_allele_frequency
    in:
      - id: r2_filtered_vcf
        source: filter_vcf_by_r2/r2_filtered_vcf
      - id: minimum_allele_frequency
        source: minimum_allele_frequency
    out:
      - id: r2_AF_filtered_vcf
    run: tools/AF_filter_vcf.cwl
  - id: compress_vcf
    in:
      - id: filtered_vcf
        source: filter_vcf_by_allele_frequency/r2_AF_filtered_vcf
    out: 
      - id: filtered_bgzip_vcf
    run: tools/bgzip.cwl
  - id: index_vcf
    in: 
      - id: file_type
        source: file_type_vcf
      - id: input_bed_or_vcf
        source: compress_vcf/filtered_bgzip_vcf
    out: 
      - id: compressed_indexed_vcf
    run: tools/index.cwl
  - id: select_peer_factors
    in: 
      - id: peer_dervied_covariates
        source: peer_dervied_covariates/filepath
      - id: covariates
        source: covariates/filepath
      - id: number_of_peer_factors
        source: numPeer # is this the syntax to pull constants from yaml file?
    out:
      - id: metadata_to_analyze
    run: tools/join_peer_factors.cwl
  - id: bgzip_covariates
    in: 
      - id: input_bgzip
        source: select_peer_factors/metadata_to_analyze
    out: 
      - id: compressed_covariates
    run: tools/bgzip.cwl
  - id: run_qtltools
    in:
      - id: qtltools_analysis_type
        source: qtltype
      - id: gz_vcf_file
        source: index_vcf/compressed_indexed_vcf
      - id: bed_file
        source: index_genome/compressed_indexed_bed
      - id: covariate_file
        source: bgzip_covariates/compressed_covariates
      - id: permutation_pass
        source: permutation_pass
      - id: output_file_name
        source: #can I construct an output filename from inputs in yaml (equivalent to glue in R)?
      - id: match_samples
        source: samples_to_include/filepath
    out: 
      - id: qtl_out
      - id: qtltools_stdout_out
    run: tools/discover_qtl.cwl
  - id: bgzip_qtls
    in: 
      - id: input_bgzip
        source: run_qtltools/qtl_out
    out: 
      - id: compressed_eqtl
    run: tools/bgzip.cwl
  - ##Add store step


requirements:
  - class: SubworkflowFeatureRequirement