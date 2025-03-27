def replace_multiple_texts_in_file(file_path, replacements, output_path):
    try:
        with open(file_path, 'r', encoding='utf-8') as file:
            content = file.read()
        
        for search_text, replace_text in replacements.items():
            content = content.replace(search_text, replace_text)
        
        with open(output_path, 'w', encoding='utf-8') as file:
            file.write(content)
        
        print("File modificato e salvato con successo!")
    except Exception as e:
        print(f"Errore: {e}")

file_input  = "ORFS_netlist/post_synthesis/1_synth.v"  
file_output = "ORFS_netlist/post_synthesis/1_synth.v" 

replacements = {
    "RM_IHPSG13_1P_1024x64_c2_bm_bist \service_ihp.servant.ram.sevant_ram.ram": "RM_IHPSG13_1P_1024x64_c2_bm_bist #(.INIT_FILE(\"firmware/exe.hex\")) \service_ihp.servant.ram.sevant_ram.ram",
    
    "RM_IHPSG13_1P_256x48_c2_bm_bist \service_ihp.mosquito.encoding_slot_i.encoding_slot_emg_i.delta_modulator_1.delta_mem.single_port": "RM_IHPSG13_1P_256x48_c2_bm_bist #(.INIT_FILE(\"sim/mem/emg/delta.txt\")) \service_ihp.mosquito.encoding_slot_i.encoding_slot_emg_i.delta_modulator_1.delta_mem.single_port"
    
}

replace_multiple_texts_in_file(file_input, replacements, file_output)
