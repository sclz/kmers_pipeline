process FASTQPREPARATION {
  container 'quay.io/biocontainers/samtools:1.6--hc3601fc_10'

  input:
  path bed
  tuple val(id), path(bam) // id nome campione, bam bam del campione
  tuple val(id), path(bai)
    
  output:
  tuple val(id), path("${id}.fastq"), emit: fastq

  shell:
  '''
  read -r chrom start end < "!{bed}"
  region="${chrom}:${start}-${end}"
  samtools view -b -o !{id}_filtered.bam !{bam} ${region}
  samtools fastq !{id}_filtered.bam > !{id}.fastq
  '''
}