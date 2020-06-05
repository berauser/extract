# Extract variables/data from binary file

This script extracts variables/data from an binary file.


## Usage
Use at your own risk and no warranty.

```
Usage:

./extract.sh <binary> <symbol>
```

## Example
The following example file is given.
The variable 'my_data' contains the data that we want to read out
```
#include <iostream>

const char my_data[] = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'};

int main()
{

	for(int i = 0; i < sizeof(my_data); ++i)
	{
		std::cout << std::dec << i << " -> " << std::hex << my_data[i] << std::endl;
	}

	return 0;
}
```
At first we have to compile the exmaple file. (Usally this is already done)
```
$ g++ -g main.cpp
```

Then we can search for our symbol that we want to extract. We can simply use 'nm' and 'c ++ filt'. It looks like this
```
$ nm a.out | c++filt

...
000107c0 T main
0001075c t register_tm_clones
000106d0 T _start
00021048 D __TMC_END__
0001087c t __static_initialization_and_destruction_0(int, int)
00010b58 r my_data
...
```
Here we can already see our symbol 'my_data' that we want to extract.
To do this, we execute the script as follows

```
$ ./extract.sh a.out my_data

----- symbol information ------
Symbol name:   my_data
Size of data:  0000001a
Address:       00010b58
Section:       .rodata

----- section information -----
Section name:  .rodata
Section size:  00000029
Section start: 00010b50

Section .rodata extracted to file a.out.rodata...

Symbol my_data extracted to file my_data...

Extracted data:

00000000  41 42 43 44 45 46 47 48  49 4a 4b 4c 4d 4e 4f 50  |ABCDEFGHIJKLMNOP|
00000010  51 52 53 54 55 56 57 58  59 5a                    |QRSTUVWXYZ|
0000001a

done.
```

The extracted data is printed out on the console and written to a file. The file has the same name as the symbol
```
-rw-r--r--  1 pi pi    26 Jun  5 22:12 my_data
```


Tested on a raspberry pi 4.


