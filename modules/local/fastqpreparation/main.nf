process FASTQPREPARATION {
  container 'quay.io/biocontainers/samtools:1.6--hc3601fc_10'

  //publishDir params.outdir, pattern: "*.fastq",  mode: 'copy'

  input: // input specificare i canali di iput
  path bed
  tuple val(id), path(bam) // id nome campione, bam bam del campione
  tuple val(id), path(bai)
  
  output:
  tuple val(id), path("${id}.fastq"), emit: fastq // va specificato file di output. L'emit fa si che il file possa essere salvato in un canale ed utilizzato da un altro processo
  
 
  shell://in questo scope viene scritto il codice. Le varianti definite all'interno degli input vengono richiamate con ${}. 
    '''
    read -r chrom start end < "!{bed}"
    region="${chrom}:${start}-${end}"
    samtools view -b -o !{id}_filtered.bam !{bam} ${region}
    samtools fastq !{id}_filtered.bam > !{id}.fastq
    '''

}