process FASTQPREPARATION_TELOMERS {

container 'quay.io/biocontainers/samtools:1.6--hc3601fc_10'

input: // input specificare i canali di iput
    tuple val(id), path(bam) // id nome campione, bam bam del campione
    tuple val(id), path(bai)

output:
    tuple val(id), path("${id}.fastq"), emit: fastq // va specificato file di output. L'emit fa si che il file possa essere salvato in un canale ed utilizzato da un altro processo

shell://in questo scope viene scritto il codice. Le varianti definite all'interno degli input vengono richiamate con ${}. 
    '''
    samtools fastq !{bam} > !{id}.fastq
    '''  
}