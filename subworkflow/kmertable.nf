include { CREATETABLE } from '../modules/local/createtable/main'


workflow KMER_TABLE {
    take:
        outdirksum
        outdireads
    main:
        CREATETABLE(outdirksum, outdireads)
        table_ch = CREATETABLE.out.table    
}