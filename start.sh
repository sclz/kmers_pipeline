mode="other"
bed="/Users/lorenzo/WORKIN/kmers/nextflow/coordinates/coordinate_reali.bed"
klen="25" #6 in telomers

reference="/Users/lorenzo/WORKIN/kmers/nextflow/hg38.fa"
outdir_lists="/Users/lorenzo/WORKIN/kmers/nextflow/kmers_lists"

bam="/Users/lorenzo/WORKIN/kmers/nextflow/data"
bai="/Users/lorenzo/WORKIN/kmers/nextflow/data"
kmer_list="/Users/lorenzo/WORKIN/kmers/nextflow/kmers_lists" #lista_telomeri_6.fa" in telomers
outdir="/Users/lorenzo/WORKIN/kmers/nextflow/out"

#kcounts="/Users/lorenzo/WORKIN/kmers/nextflow/out/*.fa"
outdirreads="/Users/lorenzo/WORKIN/kmers/nextflow/out/totreads"
outdirkmers="/Users/lorenzo/WORKIN/kmers/nextflow/out/kmers"
#outdirksum="/Users/lorenzo/WORKIN/kmers/nextflow/out/totkmers"

nextflow run main.nf -resume -with-report --mode $mode --reference $reference --bed $bed --klen $klen --outdir_lists $outdir_lists --bam "$bam/*.bam" --bai "$bai/*.bai" --outdir $outdir --outdirkmers $outdirkmers --kmer_list $kmer_list  --outdirreads $outdirreads  --outdirtable $outdir # --outdirksum $outdirksum --kcounts $kcounts










