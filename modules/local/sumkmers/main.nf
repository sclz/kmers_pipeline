process SUMKMERS {

    publishDir params.outdirksum, pattern: "*.ksum",  mode: 'copy'

    input:
    tuple val(id), path(kcounts)

    output:
    path("${id}.ksum"),  emit: kmers_sum  

    shell:   
    """
    awk '{sum += \$NF} END {print sum}' !{kcounts} > !{id}.ksum
    """
}