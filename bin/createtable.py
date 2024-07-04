import os
import sys
import pandas as pd
import numpy as np

def main():
    if len(sys.argv) != 3:
        print("Usage: python3 script4.py cartellakmers cartellareads")
        sys.exit(1)
    
    cartella_kmers = sys.argv[1]
    cartella_reads = sys.argv[2]
    
    # Lista per raccogliere i risultati per ogni campione
    data = []

    # Scandisci i file nella cartella di kmers
    for filename in os.listdir(cartella_kmers):
        if filename.endswith(".ksum"):
            sample_name = os.path.splitext(filename)[0]
            ksum_file = os.path.join(cartella_kmers, filename)
            reads_file = os.path.join(cartella_reads, sample_name + ".readscount")
            
            # Leggi il numero di reads dal file .readscount
            with open(reads_file, 'r') as f_reads:
                nreads = int(f_reads.read().strip())
            
            # Leggi la somma dei kmers dal file .ksum
            with open(ksum_file, 'r') as f_kmers:
                kmers_sum = int(f_kmers.read().strip())
            
            # Calcola kmers_norm
            kmers_norm = round(kmers_sum / nreads * 10000000)
            
            # Aggiungi i risultati alla lista
            data.append([sample_name, nreads, kmers_sum, kmers_norm])
    
    # Crea un DataFrame con i risultati
    df = pd.DataFrame(data, columns=['sample', 'nreads', 'kmers', 'kmers_norm'])
    
    # Calcola lo zscore per la colonna kmers_norm
    df['zscore'] = (df['kmers_norm'] - df['kmers_norm'].mean()) / df['kmers_norm'].std()
    
    # Salva la tabella in un file TSV
    df.to_csv('results.tsv', sep='\t', index=False)

if __name__ == "__main__":
    main()
