import pandas as pd
import glob
import os
import sys

# Controlla se i parametri da riga di comando sono corretti
if len(sys.argv) != 3:
    print("Uso corretto: python script.py <kmers_dir> <readscount_dir>")
    sys.exit(1)

# Prendi le cartelle da linea di comando
kmers_dir = sys.argv[1]
readscount_dir = sys.argv[2]

# Lista di file .fa nella cartella dei kmers
file_list = glob.glob(os.path.join(kmers_dir, '*.fa'))

# Dizionario per raggruppare i file per la seconda parte del nome
file_groups = {}

# Popolare il dizionario con i file raggruppati per la seconda parte del nome
for file in file_list:
    # Estrae la seconda parte del nome (es. 'chr22_18156276-21562091' senza l'estensione .fa)
    file_key = '_'.join(os.path.basename(file).split('_')[1:]).replace('.fa', '')
    
    # Aggiungi il file al gruppo corrispondente nel dizionario
    if file_key not in file_groups:
        file_groups[file_key] = []
    file_groups[file_key].append(file)

# Funzione per caricare il numero di reads da readscount files
def load_nreads(sample_name, readscount_dir):
    # Costruisce il percorso del file di readscount
    readscount_file = os.path.join(readscount_dir, f'{sample_name}.readscount')
    # Legge il numero di reads dal file
    try:
        with open(readscount_file, 'r') as f:
            nreads = int(f.readline().strip())
        return nreads
    except FileNotFoundError:
        print(f"File {readscount_file} non trovato!")
        return None

# Iterare sui gruppi per creare una tabella per ciascuno
for file_key, files in file_groups.items():
    # Creare un dataframe vuoto per conservare i dati
    merged_df = pd.DataFrame()
    
    # Iterare su ciascun file nel gruppo
    for file in files:
        # Estrae il nome del campione dalla prima parte del nome (es. 'AAANUA5U0069')
        sample_name = os.path.basename(file).split('_')[0]
        
        # Carica il numero di reads dal file readscount
        nreads = load_nreads(sample_name, readscount_dir)
        if nreads is None:
            continue  # Se non si trova il file, salta il campione
        
        # Legge il file come un dataframe (assumendo il formato: kmer e conteggio)
        df = pd.read_csv(file, sep=' ', header=None, names=['kmer', sample_name])
        
        # Applica la normalizzazione sui conteggi dei kmers
        df[sample_name] = df[sample_name].apply(lambda kmer: round(kmer / nreads * 10000000))
        
        # Se è il primo file, crea il dataframe con i kmers
        if merged_df.empty:
            merged_df = df
        else:
            # Aggiunge la colonna del campione al dataframe esistente
            merged_df[sample_name] = df[sample_name]
    
    # Rimuove le righe dove tutti i conteggi sono 0 (esclude la colonna 'kmer')
    merged_df = merged_df.loc[~(merged_df.iloc[:, 1:] == 0).all(axis=1)]
    
    # Salva il risultato finale come CSV con il nome del file key
    output_filename = f'merged_kmer_counts_{file_key}.csv'
    merged_df.to_csv(output_filename, index=False)

    print(f'Tabella per {file_key} salvata in {output_filename}')