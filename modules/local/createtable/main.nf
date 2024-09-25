process CREATETABLE {
    container "biocontainers/pandas:1.5.1_cv1"
    memory '12 GB'
    cpus 6
    publishDir params.outdirtable, pattern: "*.tsv",  mode: 'copy'

    input:
    path("ksum/*")
    path("reads/*")
    

    output:
    path("results.tsv"), emit: table

    script:
    """
    python3 $projectDir/bin/createtable.py ksum reads
    """
}