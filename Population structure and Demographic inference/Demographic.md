# Step1: Paired-end reads trimming
```
python ~/soft/easySFS/easySFS.py -i All_filtered.vcf -p CSS.pop -o css -a --proj css
python ~/soft/easySFS/easySFS.py -i All_filtered.vcf -p CSA.pop -o csa -a --proj csa
python ~/soft/easySFS/easySFS.py -i All_filtered.vcf -p CTA.pop -o cta -a --proj cta
```

# Step2:  Estimating the effective population size (Ne) using Stairway Plot 2
```
java -cp stairway_plot_es Stairbuilder two-epoch_fold.blueprint.cta
sh two-epoch_fold.blueprint.cta.sh
```
A example of the two-epoch_fold.blueprint.cta was also presented.
