process COORDINATEFILTER {

    container 'quay.io/biocontainers/samtools:1.6--hc3601fc_10'

    memory '50 MB'

    input: // input specificare i canali di iput
    path reference
    tuple val(chrom), val(start), val(end)
  
    output:
    tuple val(chrom), val(start), val(end), path("${chrom}_${start}-${end}.fa"), emit: region_fasta 
    

    shell:
    '''
    region="!{chrom}:!{start}-!{end}"
    samtools faidx !{reference} ${region} > "!{chrom}_!{start}-!{end}.fa"
    '''
}
