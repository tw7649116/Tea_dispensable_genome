# Preparation
•	Data preparation

•	•	clean fastq

•	•	reference genome

•	•	nt database, plant.taxid.acc.txt

•	Installation preparation

•	•	BWA, samtools, SOAPdenovo, seqtk, cd-hit, blast, RepeatMasker, Augustus, Maker

# Step1: mapping clean fastq to reference genome, convert the output file to bam format
see 

# Step2: extract unaligned reads
```
samtools fastq -f 4 -1 XXX.sort.markdup.bam_Um_1.fastq -2 XXX.sort.markdup.bam_Um_2.fastq -s XXX.sort.markdup.bam_Um_single.fastq XXX.sort.markdup.bam > XXX.sort.markdup.bam.log 2> XXX.sort.markdup.bam.err
```

# Step3: assemble unaligned reads into scaffolds
```
SOAPdenovo-127mer all -s tea_ass.ctg -K 23 -R -o tea_ass_k23
```
configuration file content:
•	max_rd_len=150
•	[LIB]
•	avg_ins=1000
•	reverse_seq=0
•	asm_flags=3
•	rd_len_cutoff=150
•	rank=1
•	pair_num_cutoff=3
•	map_len=60

# Step4: filter sequences below 500 bp
```
seqtk seq -L 500 Tea_${i}_sort_markdup_un.fa > Tea_${i}_sort_markdup_un_seqtk.fa
```

# Step5: remove redundant sequences
```
cd-hit-est -i input.fa –o cluster -T 50 -M 0 -c 0.9
```

# Step6: retrieve non-reference genome sequences
```
blastall -p blastn -i all_uniq.fa -d Genome.fas -e 1e-10 -F F -b 5 -v 5 -o all_vs_ref_blast.out -a 10
seqkit grep --pattern-file all_vs_ref_blast_nonref.id input.fa > non-redundant.fa
```
# Step7: aligned against nt database to remove those not from green plants
```
seqtk subseq nt plant.taxid.acc.txt > nt_plant.fa
blastn -query ~/dis_genome/non-redundant.fa -db nt_plant -evalue 1e-5 -best_hit_overhang 0.25 -max_target_seqs 10 -show_gis -out non-redundant-nrplant-blast.txt
```

# Step8: detect repetitive sequences
```
RepeatMasker -e ncbi -pa 30 -gff -lib Repbase_CSS.repeatmaskerLib.fa -dir ./dis_Genome.fas > dis_Genome_rep.log 2> dis_Genome_err.log
```

# Step9: genome annotation
```
mkaer -CTL
mpirun -n 50 maker -base dis_Genome > run.log 2> err.log
```

# Step10: extract annotation information, extract CDS/protein sequences
```
gff3_merge -d dpp_contig_master_datastore_index.log
perl ~/scripts/getGene.pl dis_Genome.gff3 dis.fas > dis.cds
perl ~/soft/PASApipeline-pasa-v2.3.3/misc_utilities/gff3_file_to_proteins.pl gff3_file genome_db prot
```

