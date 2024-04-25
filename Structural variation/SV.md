# SV identification
```
run_novoBreak.sh ~/Software/nb_distribution/ Genome.fasta CRR151684.sort.markdup.bam control.bam 8 CRR151684 > CRR151684_run.log 2> CRR151684_err.log
...
```
For detail please see  https://github.com/czc/nb_distribution


# SV merge and statistic
```
~/soft/SURVIVOR/Debug/SURVIVOR merge 363.pos 1000 181 1 0 0 50 all.merge.50percent.vcf
~/soft/SURVIVOR/Debug/SURVIVOR stats all.merge.50percent.vcf -1 -1 -1 all_merge.summary
```
The 01 coding column of the samples were then isolated from the merged vcf file.
