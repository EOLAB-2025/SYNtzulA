def split_hex_file(input_path, output_path):
    with open(input_path, 'r') as infile, open(output_path, 'w') as outfile:
        for line in infile:
            line = line.strip()
            if not line:
                continue  # salta righe vuote
            # Dividi la riga in coppie di 2 caratteri
            bytes_list = [line[i:i+2] for i in range(0, len(line), 2)]
            # Scrivi ogni byte su una nuova riga
            for byte in bytes_list:
                outfile.write(byte + '\n')

# Esempio d'uso
split_hex_file('exe.hex', 'exe_ROM.txt')

