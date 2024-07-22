process CREATETABLE {

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