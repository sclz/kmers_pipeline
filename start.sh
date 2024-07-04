reference="/Users/lorenzo/WORKIN/kmers/nextflow/hg38.fa"
bed="/Users/lorenzo/WORKIN/kmers/nextflow/coordinates/cordinate_prova.bed"
klen="25"
outdir="/Users/lorenzo/WORKIN/kmers/nextflow/kmer_lists_prova"
mode="generate_list"
bam="/Users/lorenzo/WORKIN/kmers/nextflow/data/*.bam"
bai="/Users/lorenzo/WORKIN/kmers/nextflow/data/*.bai"
bed="/Users/lorenzo/WORKIN/kmers/nextflow/coordinates/cordinate_prova.bed"
kmer_list="/Users/lorenzo/WORKIN/kmers/nextflow/kmers_lists/lista_test.fa"

nextflow run main.nf --reference $reference --bed $bed --klen $klen --mode $mode --outdir $outdir
#nextflow run main.nf --reference $reference --bed $bed --klen $klen --mode $mode --outdir $outdir