params.bam = "$projectDir/data/*.bam"
params.bai = "$projectDir/data/*.bai"
params.kcounts = "$projectDir/out/*.fa"
params.outdireads = "$projectDir/out/totreads"
params.outdiksum = "$projectDir/out/totkmers"

process COUNTREADS {
    container 'quay.io/biocontainers/samtools:1.6--hc3601fc_10'

    publishDir params.outdireads, pattern: "*.readscount",  mode: 'copy'

    input:
    tuple val(id), path(bam) // id nome campione, bam bam del campione
 

    output:
    tuple val(id), path("${id}.readscount"),  emit: num_reads

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
    tuple val(id), path("${id}.ksum"),  emit: kmers_sum  

    shell:   
    """
    awk '{sum += \$NF} END {print sum}' !{kcounts} > !{id}.ksum
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
    
    readscounts_ch = COUNTREADS(bam_ch)
    kmersum_ch = SUMKMERS(kcounts_ch)
}