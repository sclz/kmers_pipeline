process FASTQPREPARATION {
  container 'quay.io/biocontainers/samtools:1.6--hc3601fc_10'

  input:
  tuple val(id), path(bam), path(bai), val(chrom), val(start), val(end) // id nome campione, bam bam del campione



  output:
  tuple val(id), val(chrom), val(start), val(end), path("${id}_${chrom}_${start}-${end}.fastq"), emit: fastq

  shell:
  ''' 
  region="!{chrom}:!{start}-!{end}"
  samtools view -b -o !{id}_!{chrom}_!{start}-!{end}_filtered.bam !{bam} ${region}
  samtools fastq !{id}_!{chrom}_!{start}-!{end}_filtered.bam > !{id}_!{chrom}_!{start}-!{end}.fastq
  '''
}
