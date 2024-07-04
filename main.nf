include { KMER_WORKFLOW } from './workflows/kmerworkflow.nf'
include { KMER_GENERATION } from './workflows/kmergeneration.nf'

workflow JULIA_OMIX {
    if ( params.mode == "generate_list" ) {
        
        KMER_GENERATION(params.reference, params.bed, params.klen, params.outdir)
    }
    else if ( params.mode == "full" ) {
        
        KMER_GENERATION(params.reference, params.bed, params.klen, params.outdir)
        //KMER_WORKFLOW()
    }    
    /*else {
        KMER_WORKFLOW()   
    }*/
    
    
}

workflow {
    JULIA_OMIX ()
}