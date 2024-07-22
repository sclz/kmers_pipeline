include {FASTQPREPARATION_TELOMERS} from '../modules/local/fastqpreparation_telomers/main'
include {KMERSCOUNTQUERY} from '../modules/local/kmerscountquery/main'
      
workflow KMER_TELOMERS {
    
    take:
        bam
        bai
        outdir
        klen
        kmer_list

    main:

        FASTQPREPARATION_TELOMERS(bam, bai)
        fastq_ch = FASTQPREPARATION_TELOMERS.out.fastq
        KMERSCOUNTQUERY(klen, fastq_ch, kmer_list)
        kmers_fasta_ch = KMERSCOUNTQUERY.out.kmers_fasta

    emit:
        kmers_fasta_ch
}