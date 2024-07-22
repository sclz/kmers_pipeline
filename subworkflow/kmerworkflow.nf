include {FASTQPREPARATION} from '../modules/local/fastqpreparation/main'
include {KMERSCOUNTQUERY} from '../modules/local/kmerscountquery/main'
      
workflow KMER_WORKFLOW {
    
    take:
        bam
        bai
        bed
        outdir
        klen
        kmer_list

    main:

        FASTQPREPARATION(bed, bam, bai)
        fastq_ch = FASTQPREPARATION.out.fastq
        KMERSCOUNTQUERY(klen, fastq_ch, kmer_list)
        kmers_fasta_ch = KMERSCOUNTQUERY.out.kmers_fasta

    emit:
        kmers_fasta_ch
}