# Printing out data in ascii hex

## How to compile and run

To compile the code, execute the following command:

```
nasm -f elf32 -g -F dwarf -o printer.o printer.asm
```

To link the program, run the command:

```
ld -m elf_i386 -o printer printer.o
```

To run the program, execute the following command:

```
./printer
```

## Example output

The program should produce output similar to the following:

```
83 6A 88 DE 9A C3 54 9A
```
