#!/bin/bash
#set -x

APPLICATION_NAME=$(basename $0)
help() {
	echo ""
	echo "Usage:"
	echo " ./$(basename $0) <binary> <symbol>"
	echo ""
}

[ "x$2" = "x" ] && \
    echo "Too few arguments" && \
    help && exit 1


BINARY=$1
SYMBOL=$2


# --- extract symbol information ---------------------------
output=$(objdump -x $BINARY | c++filt | grep $SYMBOL)
symbol_address=$(echo $output | cut -d' ' -f1) # hex
symbol_section=$(echo $output | cut -d' ' -f4)
symbol_size=$(echo $output | cut -d' ' -f5) # hex
symbol_name=$(echo $output | cut -d' ' -f6)

echo ""
echo "----- symbol information ------"
echo "Symbol name:   $symbol_name"
echo "Size of data:  $symbol_size"
echo "Address:       $symbol_address"
echo "Section:       $symbol_section"

[ "x$SYMBOL" != "x$symbol_name" ] && \
    echo "ERROR: Something went wrong. Symbol names are different ($SYMBOL != $symbol_name)." && \
    exit 2


# --- extract section information --------------------------
output=$(objdump --headers $BINARY | grep $symbol_section)
section_name=$(echo $output | cut -d' ' -f2)
section_size=$(echo $output | cut -d' ' -f3) # hex
section_start=$(echo $output | cut -d' ' -f4) # hex (VMA - virtual memory address)
#section_start=$(echo $output | cut -d' ' -f4) # hex (LMA - load memory address)

echo ""
echo "----- section information -----"
echo "Section name:  $section_name"
echo "Section size:  $section_size"
echo "Section start: $section_start"

[ "x$symbol_section" != "x$section_name" ] && \
    echo "ERROR: Something went wrong. Section of symbol differs from found section name (0x$symbol_section != 0x$section_name)." && \
    exit 3

# TODO compare section address
# TODO comapre section size


# --- extract section --------------------------------------
binary_section=$BINARY$section_name

objcopy -j $section_name -O binary $BINARY $binary_section

extracted_file_size_dec=$(wc -c < $binary_section) # dec
section_size_dec=$(printf "%d" $((0x$section_size))) # dec
[ "x$extracted_file_size_dec" != "x$section_size_dec" ] && \
    echo "ERROR: Something went wrong. Extracted section size is not equal to the size read ($extracted_file_size_dec != $section_size_dec)." && \
    exit 4

echo ""
echo "Section $section_name extracted to file $binary_section..."


# --- extract symbol ---------------------------------------
section_offset=$(printf "%d" $((0x$symbol_address - 0x$section_start))) # dec
symbol_size_dec=$(printf "%d" $((0x$symbol_size))) # dec

dd if=$binary_section of=$symbol_name bs=1 skip=$section_offset count=$symbol_size_dec &> /dev/null

extracted_symbol_size_dec=$(wc -c < $symbol_name) # dec
symbol_size_dec=$(printf "%d" $((0x$symbol_size))) # dec
[ "x$extracted_symbol_size_dec" != "x$symbol_size_dec" ] && \
    echo "ERROR: Something went wrong. Extracted symbol size is not equal to the size read ($extracted_symbol_size_dec != $symbol_size_dec)." && \
    exit 5

echo ""
echo "Symbol $symbol_name extracted to file $symbol_name..."
echo ""
echo "Extracted data:"
echo ""
hexdump -C $symbol_name
echo ""

echo "done."





