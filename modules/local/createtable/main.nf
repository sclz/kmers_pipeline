process CREATETABLE {

    publishDir params.outdir, pattern: "*.csv",  mode: 'copy'
    //memory '64 GB'
    memory '8 GB'
    //cpus 8
    container "biocontainers/pandas:1.5.1_cv1"

    input:
    path("kcounts/*")
    path("reads/*")


    output:
    //path("results.tsv"), emit: table
    path("*.csv")

    script:
    """
    python3 $projectDir/bin/normalizedtable.py kcounts reads
    """

}
