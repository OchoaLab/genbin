# assumes `plink2`, `gcta64` are in path!

# create random data

# choose odd dimensions to test edge cases in my code
n=33 # n %% 4 != 0 are good tests
m=101
miss=0.1 # missingness proportion, we need to make sure these cases are handled too!
name="dummy-$n-$m-$miss"

# make bed/bim/fam
plink2 --dummy $n $m $miss --make-bed --out $name
# remove log when things are ok
rm $name.log

# NOTE: manually edited $name.bim so there are two chromosomes (needed for BOLT)
# pos 0-49 are in chr1, rest (50-100) are chr2

# create older tped version for emmax (note plink 1 is needed!)
plink1 --bfile $name --recode transpose 12 --out $name --allow-no-sex
# cleanup
rm $name.log

# $name.phen gets created in R!  Do here (after last lines, before following)

# create glm output for parsing test
plink2 --bfile $name --pheno $name.phen --pheno-col-nums 3 --out $name --glm omit-ref hide-covar allow-no-covars
# cleanup
rm $name.log

# create hardy output for parsing test
plink2 --bfile $name --hardy --nonfounders --out $name
# cleanup
rm $name.log

# midp version is slightly different, need to test it too
plink2 --bfile $name --hardy midp --nonfounders --out $name.midp
# cleanup
rm $name.midp.log

# create GCTA outputs (grm, mlma, hsq) for parsing tests
gcta64 --bfile $name --make-grm --out $name
gcta64 --mlma --bfile $name --grm $name --pheno $name.phen --out $name
gcta64 --reml --grm $name --pheno $name.phen --out $name
# cleanup
rm $name.log

# create GEMMA outputs (cXX.txt, assoc.txt) for parsing tests
gemma -bfile $name -gk -o $name -outdir .
gemma -bfile $name -k $name.cXX.txt -lmm -o $name -outdir . -notsnp -miss 1 -r2 1
# cleanup
rm $name.log.txt

# create EMMAX outputs (BN.kinf, ps) for parsing tests
emmax-kin $name -d 10
emmax -t $name -p $name.phen -k $name.BN.kinf -o $name -d 10
# cleanup
rm $name.log $name.reml
# NOTE: due to emmax-specific dumness, BN.kinf gets overwritten and removed in tests, so might as well remove it here to not have expectations that it should be there
rm $name.BN.kinf

# create BOLT outputs for parsing tests
bolt --lmm --bfile $name --phenoUseFam --LDscoresUseChip --statsFile $name.bolt.txt --lmmForceNonInf --maxMissingPerSnp 1 --maxMissingPerIndiv 1

# make a bad example that causes errors
# in this case bim/fam have length (smaller than before), but bed is empty (zero bytes)
# (want something where the files exist so the run is attempted, and fails afterwards (in binary rather than in R))
head dummy-$n-$m-$miss.fam > empty.fam
head dummy-$n-$m-$miss.bim > empty.bim
touch empty.bed
touch empty.phen
touch empty.tped
touch empty.tfam
