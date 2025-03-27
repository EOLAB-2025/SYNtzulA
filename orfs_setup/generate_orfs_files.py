import os

root = os.path.abspath(os.path.join(os.getcwd(), "../"))

verilog_files = f"""\nexport VERILOG_FILES = {root}/SYNtzulA/rtl/syntzulu_ihp/* \\
                          {root}/SYNtzulA/rtl/memorie_ihp/* \\
                          {root}/SYNtzulA/rtl/serv/* \\
                          {root}/SYNtzulA/rtl/servant/*"""


with open("orfs_setup/config.mk", "a") as config_file:
	config_file.write(verilog_files)
