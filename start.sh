mode="table"
bed="/Users/lorenzo/WORKIN/kmers/nextflow/coordinates/cordinate_prova.bed"
klen="25"

reference="/Users/lorenzo/WORKIN/kmers/nextflow/hg38.fa"
outdir_lists="/Users/lorenzo/WORKIN/kmers/nextflow/kmer_lists"

bam="/Users/lorenzo/WORKIN/kmers/nextflow/data/*.bam"
bai="/Users/lorenzo/WORKIN/kmers/nextflow/data/*.bai"
kmer_list="/Users/lorenzo/WORKIN/kmers/nextflow/kmers_lists/lista_test.fa"
outdir="/Users/lorenzo/WORKIN/kmers/nextflow/out"

kcounts="/Users/lorenzo/WORKIN/kmers/nextflow/out/*.fa"
outdireads="/Users/lorenzo/WORKIN/kmers/nextflow/out/totreads"
outdirksum="/Users/lorenzo/WORKIN/kmers/nextflow/out/totkmers"

nextflow run main.nf --mode $mode --reference $reference --bed $bed --klen $klen --outdir_lists $outdir_lists --bam $bam --bai $bai --outdir $outdir --kmer_list $kmer_list --kcounts $kcounts --outdireads $outdireads --outdirksum $outdirksum --outdirtable $outdir




#outdir diventa outdir_lists
#oudir2 diventa outdir
#oudir3 diventa kcounts

#nextflow run main.nf --reference $reference --bed $bed --klen $klen --mode $mode --outdir $outdir
#nextflow run main.nf  --bam $bam --bai $bai --bed $bed --outdir $outdir2 --klen $klen --mode $mode --kmer_list $kmer_list
#nextflow run main.nf --bam $bam --bai $bai --kcounts $outdir3 --mode $mode --outdireads $outdireads --outdirksum $outdirksum --outdirtable $outdir2