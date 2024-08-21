import os
import sys
import pandas as pd

def calculate_zscore(values):
    """
    Calcola lo z-score per una serie di valori.
    """
    mean = values.mean()
    std = values.std()
    zscores = (values - mean) / std if std != 0 else [0] * len(values)
    return zscores

def main():
    if len(sys.argv) != 3:
        print("Usage: python3 script.py cartellakmers cartellareads")
        sys.exit(1)
    
    cartella_kmers = sys.argv[1]
    cartella_reads = sys.argv[2]
    
    # Dizionario per raccogliere i risultati per coordinate
    results = {}
    
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
                chrom = parts[1]
                start_end = parts[2]
                start, end = start_end.split('-') if '-' in start_end else (start_end, '')
            else:
                chrom = ''
                start = ''
                end = ''
            
            coordinate = f"{chrom}:{start}-{end}"
            
            # Aggiungi i risultati al dizionario
            if coordinate not in results:
                results[coordinate] = {}
            results[coordinate][sample_id] = kmers_norm
    
    # Converti il dizionario in un DataFrame
    df = pd.DataFrame(results).T
    df.index.name = 'coordinate'
    
    # Calcola lo z-score per ogni riga e sostituisci i valori originali
    for index, row in df.iterrows():
        df.loc[index] = calculate_zscore(row)
    
    # Salva la tabella in un file TSV
    df.to_csv('results.tsv', sep='\t')
    print("Risultati salvati in results.tsv")

if __name__ == "__main__":
    main()

