include { KMER_WORKFLOW } from './workflows/kmerworkflow.nf'
include { KMER_GENERATION } from './workflows/kmergeneration.nf'
include { KMER_NORMALIZATION } from './workflows/kmernormalization.nf'
include { KMER_TABLE } from './workflows/kmertable.nf'

workflow JULIA_OMIX {
    if ( params.mode == "generate_list" ) {
        
        KMER_GENERATION(params.reference, params.bed, params.klen, params.outdir_lists)
    }
    else if ( params.mode == "count" ) {
    
        KMER_WORKFLOW(params.bam, params.bai, params.bed, params.outdir, params.klen, params.kmer_list)
    }    
    else if ( params.mode == "normalization" ){

        KMER_NORMALIZATION(params.bam, params.bai, params.kcounts, params.outdireads, params.outdirksum) 
        
    }
    else if ( params.mode == "table" )
        KMER_TABLE(params.outdirksum, params.outdireads)

    //else {
    //    KMER_GENERATION()
    //    KMER_WORKFLOW()
    //    KMER_NORMALIZATION()
    //    KMER_TABLE()
    //}    
    
}

workflow {
    JULIA_OMIX ()
}