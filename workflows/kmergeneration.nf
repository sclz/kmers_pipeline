include { COORDINATEFILTER } from '../modules/local/coordinatefilter/main'
include { KMERSCOUNTDUMP } from '../modules/local/kmerscountdump/main'
include { KMERSMAPPING } from '../modules/local/kmersmapping/main'
include { MAPPEDFILTERING } from '../modules/local/mappedfiltering/main'

workflow KMER_GENERATION {
    take:
        reference
        bed
        klen
        outdir

    main:
        COORDINATEFILTER(reference, bed)
        region_fasta_ch = COORDINATEFILTER.out.region_fasta
        KMERSCOUNTDUMP(klen, region_fasta_ch)
        kmers_fasta_ch = KMERSCOUNTDUMP.out.kmers_fasta
        KMERSMAPPING(kmers_fasta_ch, reference)
        kmers_sam_ch = KMERSMAPPING.out.kmers_sam
        MAPPEDFILTERING(kmers_sam_ch, bed)
        kmers_list_ch = MAPPEDFILTERING.out.kmers_list
    //output:
       //s kmers_list_ch
}       