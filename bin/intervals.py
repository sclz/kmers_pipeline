import sys
import os

def generate_intervals(chromosome, start, end, interval_size, output_file):
    current_start = start
    while current_start < end:
        current_end = min(current_start + interval_size - 1, end)
        output_file.write(f"{chromosome} {current_start} {current_end}\n")
        current_start += interval_size

def process_bed_file(input_file, interval_size):
    # Estrai il nome base del file BED (senza estensione)
    base_name = os.path.splitext(input_file)[0]
    # Crea il nome per il file di output
    output_file_name = f"{base_name}_intervals_{interval_size}.bed"

    with open(input_file, 'r') as infile, open(output_file_name, 'w') as outfile:
        for line in infile:
            # Salta le righe vuote o i commenti
            if not line.strip() or line.startswith('#'):
                continue
            
            # Divide la riga in campi
            fields = line.strip().split()
            chromosome = fields[0]
            start = int(fields[1])
            end = int(fields[2])
            
            # Genera gli intervalli per ogni riga e li scrive nel file di output
            generate_intervals(chromosome, start, end, interval_size, outfile)
    
    print(f"Intervalli di {interval_size} generati nel file {output_file_name}")

def main():
    # Verifica che l'utente abbia passato il numero corretto di parametri
    if len(sys.argv) != 3:
        print(f"Utilizzo: {sys.argv[0]} <input_bed_file> <interval_size>")
        print(f"Esempio: {sys.argv[0]} input.bed 1000000")
        sys.exit(1)

    # Parametri di input
    input_file = sys.argv[1]
    interval_size = int(sys.argv[2])

    # Processa il file BED
    process_bed_file(input_file, interval_size)

if __name__ == "__main__":
    main()