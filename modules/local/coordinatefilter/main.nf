process COORDINATEFILTER {

    container 'quay.io/biocontainers/samtools:1.6--hc3601fc_10'

    input: // input specificare i canali di iput
    path reference
    path bed

  
    output:
    path("region.fa"), emit: region_fasta

    shell:
    '''
    read -r chrom start end < "!{bed}"
    region="${chrom}:${start}-${end}"
    samtools faidx !{reference} ${region} > "region.fa"
    '''
}
