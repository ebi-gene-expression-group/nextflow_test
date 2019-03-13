#!/usr/bin/env nextflow

TEST = Channel.fromPath( "${baseDir}/test*.csv" )

process extract_number {

    input:
        file csvFile from TEST

    output:
        set stdout, file (csvFile) into TEST_BY_NUM

    """
       echo $csvFile | grep -o -E '[0-9]+' | tr '\\n' '\\0' 
    """
}

process test_to_tsv {

    publishDir "test", mode: 'move', overwrite: true

    input:
        set val(num), file(csvFile) from TEST_BY_NUM

    output:
        set val(num), file ("test_${num}.tsv") into FINAL

    """
    cat $csvFile | sed 's/,/\t/g' > test_${num}.tsv
    """
}
