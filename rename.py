#!/usr/bin/env python3

import os
import glob
import re
import shutil

def main():
    directory="out"
    files = glob.glob(os.path.join(directory, '*'))
    
    # Count for stats
    renamed = 0
    skipped = 0
    
    # Process each file
    for file_path in files:
        # Skip directories
        if os.path.isdir(file_path):
            continue
            
        # Get the filename and directory
        file_dir, filename = os.path.split(file_path)
        
        # Skip if file already has the prefix
        if filename.startswith('nsys-'):
            print(f"Skipping (already has prefix): {filename}")
            skipped += 1
            continue

        # Skip files ending with .nsys-rep or .sqlite
        if not (filename.endswith('.err') or filename.endswith('.out')):
            print(f"Skipping (unwanted extension): {filename}")
            skipped += 1
            continue

        # Skip files with numeric-only base names (without extension)
        base_name = os.path.splitext(filename)[0]
        if base_name.isdigit():
            print(f"Skipping (numeric-only name): {filename}")
            skipped += 1
            continue

        # Create the new filename with prefix
        new_filename = f"nsys-{filename}"
        new_path = os.path.join(file_dir, new_filename)
        
        # Rename the file
        try:
            shutil.move(file_path, new_path)
            print(f"Renamed: {filename} -> {new_filename}")
            renamed += 1
        except Exception as e:
            print(f"Error renaming {filename}: {e}")
    
    # Print summary
    print(f"\nProcess complete!")
    print(f"Files renamed: {renamed}")
    print(f"Files skipped: {skipped}")

if __name__ == "__main__":
    main()
