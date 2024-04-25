# Step1: Paired-end reads trimming
```
java -jar ~/soft/Trimmomatic-0.39/trimmomatic-0.39.jar PE -threads 50 -phred33 -summary Read.summary Read_f1.fq.gz Read_r2.fq.gz Read_f1.clean.fq.gz Read1.unmapped.fq.gz Read_r2.clean.fq.gz Read2.unmapped.fq.gz LEADING:20 TRAILING:20 SLIDINGWINDOW:4:20 MINLEN:20
```

# Step2: mapping, bam convert and sorting
```
bwa mem -M -t 20 -R "@RG\tID:Read\tSM:Read\tPL:Illumina" Genome.fasta Read_f1.fq.gz Read_r2.f1.gz | sambamba-0.8.0-linux-amd64-static view -t 20 -f bam -S /dev/stdin | sambamba-0.8.0-linux-amd64-static sort -m 60G --tmpdir=./ -t 20 -o Read.sort.bam /dev/stdin
```

# Step3: Duplicates removing
```
gatk MarkDuplicates -I Read.sort.bam -O Read.sorted.markdup.bam -M Read.markdup.metrics.txt
```

# Step4: Bcftool calling
```
parallel 'bcftools mpileup -b bamlist_all -r Chr{} -f Genome.fasta | bcftools call -mv -o Chr{}.raw.vcf' ::: {1..15} 2>chr.log
parallel 'bcftools mpileup -b bamlist_all -r Contig{} -f Genome.fasta | bcftools call -mv -o Contig{}.raw.vcf' ::: {1..1318} 2>contig.log
```

# Step5: Hard filtering and final variation generating
SNP filtering
```
gatk VariantFiltration -R Genome.fasta -V SNP.vcf.gz --filter-expression "QUAL < 30.0 || QD < 2.0 || MQ < 40.0 || FS > 60.0 || SOR > 3.0 || MQRankSum < -12.5 || ReadPosRankSum < -8.0" --filter-name LowQ -O SNP.filter.vcf.gz 1> snpfilter.log 2>&1
```
Indel filtering
```
gatk VariantFiltration -R Genome.fasta -V Indel.vcf.gz --filter-expression "QUAL < 30.0 || QD < 2.0 || FS > 200.0 || SOR > 10.0 || InbreedingCoeff < -0.8 || ReadPosRankSum < -20.0" --filter-name LowQ -O Indel.filter.vcf.gz 1> indelfilter.log 2>&1
```

Merge the SNPs and Indels
```
gatk MergeVcfs -I SNP.filter.vcf.gz -I Indel.filter.vcf.gz -O All.filter.vcf.gz
```

Passed variation generating

```
bcftools view -f PASS,. -g ^het -g ^miss -i 'MAF>0.05' -m2 -M2 All.filter.vcf.gz -o All.filtered.vcf.gz
```

# Step6: Phylogenetic tree
```
python ~/soft/vcf2phylip-2.6/vcf2phylip.py -i All.filtered.vcf -m 363 -f -r
trimal -in All.min365.phy -out all363_ML.phy -phylip -automated1
/iqtree-1.6.12-Linux/bin/iqtree -s 363.phy -nt 100 -ntmax 120 -seed 123456789 -v -bb 1000 -mfreq FU -m K2P -cmax 15 > iqtree.log 2>&1
```

# Step7: Population structure estimation
```
for K in 1 2 3 4 5 6 7 8; do ~/soft/admixture_linux-1.3.0/admixture -j100 --cv All.filtered.bed $K | tee log${K}.out; done
```

# Step8: PCA estimation
```
plink --allow-extra-chr --file All.filtered.bed --pca --out pca
```
