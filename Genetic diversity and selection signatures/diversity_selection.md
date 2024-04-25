# Nucleotide diversity calculation using vcftools
```
vcftools --vcf csacta.recode.vcf --keep cta.list --out CTA --window-pi 100000 --window-pi-step 100000
```

# FST calculation using vcftools
```
vcftools --vcf csacta.recode.vcf --fst-window-size 100000 --fst-window-step 100000 --weir-fst-pop cta.list --weir-fst-pop csa.list --out CSACTA
```

# Tajima's D estimation using VCF-kit
```
vk tajima 100000 100000 csscta.recode.vcf > csscta.td
```

# XP-CLR calculation using xpclr (https://github.com/hardingnj/xpclr)
```
xpclr --out CTACSS/chr1 -Sa css.list -Sb cta.list -I All_filtered.vcf --ld 0.95 --phased --size 100000 --step 100000 -C Chr1 1>c1.log 2>&1
xpclr --out CTACSS/chr2 -Sa css.list -Sb cta.list -I All_filtered.vcf --ld 0.95 --phased --size 100000 --step 100000 -C Chr2 1>c1.log 2>&1
...
```
