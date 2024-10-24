include { COUNTREADS } from '../modules/local/countreads/main'

workflow READS_COUNTS {
    
    take:
        bam

    main:

        COUNTREADS(bam)
        readscounts_ch = COUNTREADS.out.num_reads

    emit:
    readscounts_ch

}       
