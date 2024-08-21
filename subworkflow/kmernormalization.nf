include { COUNTREADS } from '../modules/local/countreads/main'
include { SUMKMERS } from '../modules/local/sumkmers/main'

workflow KMER_NORMALIZATION {
    
    take:
        bam
        kcounts

    main:

        COUNTREADS(bam)
        readscounts_ch = COUNTREADS.out.num_reads
        SUMKMERS(kcounts)
        kmersum_ch = SUMKMERS.out.kmers_sum

    emit:
    readscounts_ch
    kmersum_ch
}       
