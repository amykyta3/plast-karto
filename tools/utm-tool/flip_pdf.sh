#!/bin/bash

input=$1
output=$2

tmp=$(mktemp)
pdf2ps "$input" - | pstops H | ps2pdf - $tmp
pdftk $tmp cat 1-endnorth output "$output"
rm $tmp
