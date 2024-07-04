params.bam = "$projectDir/data/*.bam"
params.bai = "$projectDir/data/*.bai"
params.kcounts = "$projectDir/out/*.fa"
params.outdireads = "$projectDir/out/totreads"
params.outdiksum = "$projectDir/out/totkmers"
params.out = "$projectDir/out"

process COUNTREADS {
    container 'quay.io/biocontainers/samtools:1.6--hc3601fc_10'

    publishDir params.outdireads, pattern: "*.readscount",  mode: 'copy'

    input:
    tuple val(id), path(bam) // id nome campione, bam bam del campione
 

    output:
    path("${id}.readscount"),  emit: num_reads

    shell:
    """
    samtools view -c !{bam} > !{id}.readscount
    """    
}

process SUMKMERS {

    publishDir params.outdiksum, pattern: "*.ksum",  mode: 'copy'

    input:
    tuple val(id), path(kcounts)

    output:
    path("${id}.ksum"),  emit: kmers_sum  

    shell:   
    """
    awk '{sum += \$NF} END {print sum}' !{kcounts} > !{id}.ksum
    """
}

process CREATETABLE {

    publishDir params.out, pattern: "*.tsv",  mode: 'copy'

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


workflow {
    Channel
        .fromPath(params.bam, checkIfExists: true)
        .map{ tuple( it.getSimpleName(), it ) }
        .view()
        .set { bam_ch }

    Channel
        .fromPath(params.kcounts, checkIfExists: true)
        .map{ tuple( it.getSimpleName(), it ) }
        .view()
        .set { kcounts_ch }

    COUNTREADS(bam_ch)
    readscounts_ch = COUNTREADS.out.num_reads
    SUMKMERS(kcounts_ch)
    kmersum_ch = SUMKMERS.out.kmers_sum
    totkmers = kmersum_ch.collect().view()
    totreads = readscounts_ch.collect().view()   
    table_ch = CREATETABLE(totkmers, totreads)
}