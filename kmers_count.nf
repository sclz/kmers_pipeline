params.bam = "$projectDir/data/*.bam"
params.bai = "$projectDir/data/*.bai"
params.bed = "$projectDir/coordinates/cordinate_prova.bed"
params.outdir = "$projectDir/out"
params.kmer = "25"
params.kmer_list = "$projectDir/kmers_lists/lista_test.fa"

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

process KMERSCOUNTQUERY {
  container 'quay.io/biocontainers/kmer-jellyfish:2.3.1--h4ac6f70_0'

  publishDir params.outdir, pattern: "*.fa",  mode: 'copy'

  input: 
  val kmer
  tuple val(id), path(fastq) 
  path kmer_list

  
  output:
  tuple val(id), path("${id}.fa"), emit: kmers_fasta
  
 

  shell:
    '''
    jellyfish count -m !{kmer} -s 100M --out-counter-len 1 -t 8 -C !{fastq} -o !{id}.jf
    jellyfish query !{id}.jf -s !{kmer_list} -o !{id}.fa
    '''

}

workflow {
    Channel
        .fromPath(params.bam, checkIfExists: true)
        .map{ tuple( it.getSimpleName(), it ) }
        .view()
        .set { bam_ch }
    
        Channel
        .fromPath(params.bai, checkIfExists: true)
        .map{ tuple( it.getSimpleName(), it ) }
        .view()
        .set { bai_ch }
        

    fastq_ch = FASTQPREPARATION(params.bed, bam_ch, bai_ch)
    kmers_ch = KMERSCOUNTQUERY(params.kmer, fastq_ch, params.kmer_list)
}
