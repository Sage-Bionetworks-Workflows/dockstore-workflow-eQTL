#!/usr/bin/env cwl-runner
class: CommandLineTool
cwlVersion: v1.0
id: upload_synapse
requirements:
  - class: DockerRequirement
    dockerPull: sagebionetworks/synapsepythonclient:v2.2.2
  - class: InitialWorkDirRequirement
    listing:
      - entryname: synstore.py
        entry: |-
          #!/usr/bin/env python3
          import argparse

          import synapseclient as sc
          from synapseclient.activity import Activity

          parser = argparse.ArgumentParser()
          parser.add_argument(
            '--file-paths',
            required=True,
            nargs='+',
            help='Files to store')
          parser.add_argument(
            '--parent',
            required=True,
            help='Synapse id of parent entity, the folder on synapse that will host the uploaded file')
          parser.add_argument(
            '--synapse-config',
            required=True,
            help='Synapse configuration file')
          parser.add_argument(
            '--used',
            required=True,
            help='URL for job arguments file')
          parser.add_argument(
            '--executed',
            required=True,
            help='URL for workflow')
          parser.add_argument(
              '--cohort',
              required=False,
              help='Analyzed cohort name')
          parser.add_argument(
              '--chromosome',
              required=True,
              help='Chromosome number being analyzed')
          parser.add_argument(
              '--tissue',
              required=False,
              help='Tissue type analyzed')
          parser.add_argument(
              '--peer',
              required=False,
              help='PEER factor iteration')
          parser.add_argument(
              '--cellType',
              required=False,
              help='cellType analyzed')

          args = parser.parse_args()

          syn = sc.Synapse(configPath=args.synapse_config)
          syn.login()

          files = [
            sc.File(path=file_path, 
                    parent=args.parent,
                    cohort=args.cohort,
                    chromosome=args.chromosome,
                    tissue=args.tissue,
                    peer=args.peer,
                    cellType=args.cellType)
            for file_path in args.file_paths]

          activity = Activity(
              name='QTL discovery',
              description='Run of the dockstore-workflow-eQTL CWL tool',
              used=[args.used],
              executed=args.executed)

          results = []
          for item in files:
              stored = syn.store(obj=item, activity=activity)
              results.append(stored)
              activity = syn.getProvenance(entity=stored['id'])

arguments: ['python3', 'synstore.py']
inputs:
  - id: infiles
    type: File[]
    inputBinding:
      prefix: '--file-paths'
  - id: synapse_parentid
    type: string
    inputBinding:
      prefix: '--parent'
  - id: synapseconfig
    type: File
    inputBinding:
      prefix: '--synapse-config'
  - id: argurl
    type: string
    inputBinding:
      prefix: '--used'
  - id: wfurl
    type: string
    inputBinding:
      prefix: '--executed'
  - id: cohort
    type: string
    inputBinding:
      prefix: '--cohort'
  - id: chromosome
    type: string
    inputBinding: 
      prefix: '--chromosome'
  - id: tissue
    type: string
    inputBinding:
      prefix: '--tissue'
  - id: cellType
    type: string
    inputBinding:
      prefix: '--cellType'
  - id: numPeer
    type: string
    inputBinding:
      prefix: '--peer'
outputs: []
label: upload_synapse.cwl