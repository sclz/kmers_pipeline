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
    Channel
        //.fromPath(bam, checkIfExists: true)
        .fromPath("/Users/lorenzo/WORKIN/kmers/nextflow/data/*.bam", checkIfExists: true)
        .map{ tuple( it.getSimpleName(), it ) }
        .set { bam_ch }
        bam_ch.view()
    
    Channel
        //.fromPath(bai, checkIfExists: true)
        .fromPath("/Users/lorenzo/WORKIN/kmers/nextflow/data/*.bai", checkIfExists: true)
        .map{ tuple( it.getSimpleName(), it ) }
        .set { bai_ch }               
        bai_ch.view()

        FASTQPREPARATION(bed, bam_ch, bai_ch)
        fastq_ch = FASTQPREPARATION.out.fastq
        KMERSCOUNTQUERY(klen, fastq_ch, kmer_list)
        kmers_fasta_ch = KMERSCOUNTQUERY.out.kmers_fasta
}