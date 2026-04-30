# CRISP (Comprehensive Robust Integrated SNP Processing) 
#code-samples-R-sh

## Notice: Repository Under Active Redevelopment

The standalone R scripts previously hosted in this repository are being decommissioned and will no longer be maintained.

A new unified pipeline package is currently under active development. It supersedes all prior scripts and introduces the following:

- **Multi-format input support**  PLINK (BED/BIM/FAM and PED/MAP), VCF, BCF, and BGEN
- **Instruction file driven**  a single plain-text configuration file controls all steps, thresholds, and tool paths, with sensible defaults throughout
- **SLURM-native**  each processing step is submitted as a dependent SLURM job via a master shell script, with full logging and exit code propagation
- **Modular step architecture**  file validation, format conversion, sample QC, variant QC, sex checking, aneuploidy detection, homozygosity analysis, and PCA run as independent, chainable steps
- **Dual plotting engine**  publication-ready plots generated in R (ggplot2, default) or Python (matplotlib/seaborn), selectable per run
- **Reproducibility built in**  MD5 checksums and a full input summary report are generated at the start of every run

### Steps covered by the new pipeline

Step Description - To be updated


### Legacy scripts

The original R scripts for sex checking, homozygosity, and call rate reporting remain in the LEGACY branch for reference. They will not receive further updates.

---

Contributions, issues, and feedback welcome. See `pipeline_instructions.txt` for full configuration reference.
