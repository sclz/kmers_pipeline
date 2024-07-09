include { COUNTREADS } from '../modules/local/countreads/main'
include { SUMKMERS } from '../modules/local/sumkmers/main'

workflow KMER_NORMALIZATION {
    
    take:
        bam
        bai
        kcounts
        outdireads
        outdirksum

    main:
    Channel
        .fromPath("/Users/lorenzo/WORKIN/kmers/nextflow/data/*.bam", checkIfExists: true)
        .map{ tuple( it.getSimpleName(), it ) }
        .set { bam_ch }
        bam_ch.view()

    Channel
        .fromPath("/Users/lorenzo/WORKIN/kmers/nextflow/out/*.fa", checkIfExists: true)   
        .map{ tuple( it.getSimpleName(), it ) }
        .set { kcounts_ch }
        kcounts_ch.view()

        COUNTREADS(bam_ch)
        readscounts_ch = COUNTREADS.out.num_reads
        SUMKMERS(kcounts_ch)
        kmersum_ch = SUMKMERS.out.kmers_sum

}       
