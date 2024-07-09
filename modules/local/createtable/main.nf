process CREATETABLE {

    publishDir params.outdirtable, pattern: "*.tsv",  mode: 'copy'

    input:
    path(outdirksum)
    path(outdireads)
    

    output:
    path("results.tsv"), emit: table

    script:
    """
    python3 $projectDir/bin/createtable.py $outdirksum $outdireads
    """
}