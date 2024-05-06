# Map-to-pan using EUPAN (https://cgm.sjtu.edu.cn/eupan/manual.html)
```
eupan alignRead -f bwa -t 4 /data1/cleanfq/Tea/01 01_map2pan/Tea/01 ~/Software/EUPAN/tools/bwa-0.7.10/ pan.fas > Tea_01_run.log 2> Tea_01_err.log
```

# Convert sam to bam
```
eupan sam2bam -t 4 01_map2pan/Tea/01/data 02_panBam/Tea/01 ~/Software/EUPAN/tools/samtools-1.3/ > Tea_01_run.log 2> Tea_01_err.log
```

# calculate gene body coverage and CDS coverage of each gene
```
eupan geneCov -t 3 02_panBam/Tea/01/data 03_geneCov/01 pan_noName_cds.gtf > geneCov.01.run.log 2> geneCov.01.err.log
```
