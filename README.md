## PAR genotypes from MDA

Andrew Paterson and colleagues recently published a paper about male
vs female allele frequencies in the pseudoautosomal region (PAR) in
humans (Wang et al. 2022
[doi:10.1371/journal.pgen.1010231](https://doi.org/10.1371/journal.pgen.1010231)).
They asked about PAR allele frequencies in mice.

Data for the [Mouse Diversity Array
(MDA)](https://doi.org/10.1371/journal.pgen.1010231) seems like a possibility.

The Churchill group at the Jackson Lab have posted data on MDA from
many inbred strains as well as some outbred mice.

- <http://churchill-lab.jax.org/website/MDA>

- <ftp://ftp.jax.org/petrs/MDA/>

In this repository, I include some code to try to pull out the PAR
genotypes, and then to calculate allele frequencies within selected
inbred strains and outbred mice.

The file `samples_annotated.csv` is based on `samples.csv` with an
added column (`Use_for_analysis`)  with hand-entered annotations indicating whether to
use a sample or not in the estimation of allele frequencies.

R packages used:


R scripts:

- `1_download_data.R`

- `2_grab_par_genotypes.R`

- `3_calc_allele_freq.R`
