include { KMER_WORKFLOW } from '../subworkflow/kmerworkflow.nf'
include { KMER_GENERATION } from '../subworkflow/kmergeneration.nf'
include { KMER_NORMALIZATION } from '../subworkflow/kmernormalization.nf'
include { KMER_TABLE } from '../subworkflow/kmertable.nf'
include { KMER_TELOMERS} from '../subworkflow/telomers.nf'

    Channel
        .fromPath(params.bam, checkIfExists: true)
        .map{ tuple( it.getSimpleName(), it ) }
        .set { bam_ch }
    
    Channel
        .fromPath(params.bai, checkIfExists: true)
        .map{ tuple( it.getSimpleName(), it ) }
        .set { bai_ch }         
    
    Channel
        .fromPath(params.bed, checkIfExists: true)
        .splitCsv ( header:false, sep:' ' )
        .map{ tuple( it[0], it[1], it[2] ) }
        .set { bed_ch }

    bam_bai = bam_ch.join(bai_ch)

    Channel 
        bam_bai.combine(bed_ch)
        .set { bam_coordinates_ch }
     

workflow JULIA_OMIX {
 
    if ( params.mode == "generate_lists" ) {
        
        KMER_GENERATION(params.reference, bed_ch, params.klen, params.outdir_lists)
    }  
    else if ( params.mode == "table" ){

        KMER_NORMALIZATION(bam_ch, kcounts_ch)
        ksum = KMER_NORMALIZATION.out.kmersum_ch.collect()
        reads = KMER_NORMALIZATION.out.readscounts_ch.collect()
        KMER_TABLE(ksum, rea)

    }
    else if ( params.mode == "telomers" ){

        KMER_TELOMERS(bam_ch, bai_ch, params.outdir, params.klen, params.kmer_list)
        kcounts = KMER_TELOMERS.out.kmers_fasta_ch
        KMER_NORMALIZATION(bam_ch, bai_ch, kcounts)
        ksum = KMER_NORMALIZATION.out.kmersum_ch.collect()
        reads = KMER_NORMALIZATION.out.readscounts_ch.collect()
        KMER_TABLE(ksum, reads)
    }
    else {

        KMER_WORKFLOW(bam_coordinates_ch, params.outdir, params.klen, params.kmer_list)
        kcounts = KMER_WORKFLOW.out.kmers_fasta_ch
        KMER_NORMALIZATION(bam_ch, kcounts)
        ksum = KMER_NORMALIZATION.out.kmersum_ch.collect()
        reads = KMER_NORMALIZATION.out.readscounts_ch.collect()
        KMER_TABLE(ksum, reads)
    }
    
}

