SKETCHES=["s__JAJZVQ01 sp021845575", "s__Kariarchaeum pelagium"]

SKETCH_DB='/home/ctbrown/scratch3/2026-gtdb-dl/gtdb-cds-rs226.species.singleton.sig.zip'

BW_ROCKSDB='/group/ctbrowngrp5/sra-metagenomes/20241128-k21-s1000'

rule all:
    input:
        expand('outputs/manysearch.{sketch}.csv', sketch=SKETCHES),

rule extract_sketch:
    input:
        SKETCH_DB,
    output:
        'sketches/{s}.sig.zip'
    params:
        exact=lambda w: f"{w.s} " # add space to require exact matching
    shell: """
        sourmash sig grep {params.exact:q} {input:q} -o {output:q}
    """


rule search_sketch:
    input:
        q="sketches/{sketch}.sig.zip",
        db=BW_ROCKSDB,
    output:
        "outputs/manysearch.{sketch}.csv",
    threads: 1
    shell: """
        sourmash scripts manysearch -c {threads} -t 0 -k 21 -s 1000 \
            {input.q:q} {input.db:q} -o {output:q}
    """

