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
            # Usa il nome completo del file senza estensione come sample_name
            sample_name = os.path.splitext(filename)[0]
            ksum_file = os.path.join(cartella_kmers, filename)
            
            # Ottieni l'ID del campione prima del primo underscore
            sample_id = sample_name.split('_')[0]
            reads_file = os.path.join(cartella_reads, sample_id + ".readscount")
            
            # Leggi il numero di reads dal file .readscount
            try:
                with open(reads_file, 'r') as f_reads:
                    nreads = int(f_reads.read().strip())
            except FileNotFoundError:
                print(f"File .readscount per {sample_id} non trovato, continuando con il prossimo campione.")
                continue
            
            # Leggi la somma dei kmers dal file .ksum
            with open(ksum_file, 'r') as f_kmers:
                kmers_sum = int(f_kmers.read().strip())
            
            # Calcola kmers_norm
            kmers_norm = round(kmers_sum / nreads * 10000000) if nreads != 0 else 0
            
            # Separazione dei componenti della stringa sample_name
            parts = sample_name.split('_')
            if len(parts) >= 3:
                sample_id = parts[0]
                chrom = parts[1]
                start_end = parts[2]
                start, end = start_end.split('-') if '-' in start_end else (start_end, '')
            else:
                sample_id = sample_name
                chrom = ''
                start = ''
                end = ''
            
            # Aggiungi i risultati alla lista
            data.append([sample_id, chrom, start, end, nreads, kmers_sum, kmers_norm])
    
    # Crea un DataFrame con i risultati
    df = pd.DataFrame(data, columns=['sample', 'chr', 'start', 'end', 'nreads', 'kmers', 'kmers_norm'])
    
    # Calcola lo zscore per la colonna kmers_norm
    df['zscore'] = (df['kmers_norm'] - df['kmers_norm'].mean()) / df['kmers_norm'].std()
    
    # Salva la tabella in un file TSV
    df.to_csv('results.tsv', sep='\t', index=False)
    print("Risultati salvati in results.tsv")

if __name__ == "__main__":
    main()
