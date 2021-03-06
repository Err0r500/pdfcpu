#!/bin/sh

# eg: ./splitDir.sh ~/pdf/big ~/pdf/out

if [ $# -ne 2 ]; then
    echo "usage: ./splitDir.sh inDir outDir"
    exit 1
fi

out=$2

#rm -drf $out/*

#set -e

for pdf in $1/*.pdf
do
	
	f=${pdf##*/}
	#echo f = $f
	
	f1=${f%.*}
	#echo f1 = $f1
	
    mkdir $out/$f1
    cp $pdf $out/$f1

    pdfcpu split -verbose $out/$f1/$f $out/$f1 > $out/$f1/$f1.log
    if [ $? -eq 1 ]; then
        echo "split error: $pdf -> $out/$f1"
        echo
		continue
    else
        echo "split success: $pdf -> $out/$f1"
        for subpdf in $out/$f1/*_?.pdf
        do
            pdfcpu validate -verbose -mode=relaxed $subpdf >> $out/$f1/$f1.log
            if [ $? -eq 1 ]; then
                echo "validation error: $subpdf"
                exit $?
            #else
                #echo "validation success: $subpdf"
            fi
        done
    fi

done
