import sys
import re

def modify_bend_script(replacement_num):
    # Read the content of the input file
    try:
        with open("./bend_scripts/fib_recursive.bend", 'r') as file:
            content = file.read()
    except FileNotFoundError:
        print(f"Error: file not found.")
        return False
    
    # Replace the specific pattern using regex
    # Look for return fib_recursive(<any number>) and replace with the new number
    modified_content = re.sub(
        r'(return\s+fib_recursive\()(\d+)(\))', 
        r'\g<1>' + str(replacement_num) + r'\g<3>', 
        content
    )
    
    # Write the modified content to the output file
    try:
        with open("./bend_scripts/fib_recursive.bend", 'w') as file:
            file.write(modified_content)
        print(f"Successfully modified and saved to file")
        return True
    except Exception as e:
        print(f"Error writing to output file: {e}")
        return False

def main():
    # Check if correct number of arguments is provided
    if len(sys.argv) != 2:
        print("Usage: python set_fibrec_arg.py <argument number>")
        return
    
    # Validate that the third argument is an integer
    try:
        replacement_num = int(sys.argv[1])
    except ValueError:
        print("Error: The replacement number must be an integer.")
        return
    
    # Call the function to modify the file
    modify_bend_script(replacement_num)

if __name__ == "__main__":
    main()
