process SUMKMERS {

    publishDir params.outdirksum, pattern: "*.ksum",  mode: 'copy'
    
    memory '20 MB'

    input:
    //tuple val(id), val(chrom), val(start), val(end), path(kcounts)
    tuple val(id), val(chrom), val(start), val(end), path("${id}_${chrom}_${start}-${end}.fa")
    
    output:
    path("${id}_${chrom}_${start}-${end}.ksum"),  emit: kmers_sum  

    shell:   
    """
    
    awk '{sum += \$NF} END {if (sum == "") sum = 0; print sum}' !{id}_!{chrom}_!{start}-!{end}.fa > !{id}_!{chrom}_!{start}-!{end}.ksum

    """
}