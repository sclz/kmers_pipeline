include { CREATETABLE } from '../modules/local/createtable/main'


workflow KMER_TABLE {
    take:
        outdirkmers
        outdirreads
    main:
        CREATETABLE(outdirkmers, outdirreads)
        //table_ch = CREATETABLE.out.table
}