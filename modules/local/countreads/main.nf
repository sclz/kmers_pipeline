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