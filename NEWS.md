# genbin 0.0.0.9000 (2021-08-14)

- First version of various functions organized around this package!
  - Original (scripts in a private repository, not a proper package) was not tested systematically, and evolved slowly so many features were only partially present in newer code while older code did things in more awkward ways.
  - New code shares the way errors are handled across all cases; style is more coherent, including option names, behaviors, parsers, etc.
- This early version is thoroughly tested, but not documented at all.  No functions are exported.

# genbin 0.0.1.9000 (2021-08-16)

- Documented and exported all main functions!
- Package passes checks!

# genbin 0.0.2.9000 (2021-08-17)

- Added package documentation page and `README.md` with sample pipelines for GCTA and plink PCA.
- Function `gcta_mlma` expanded documentation to explain which errors cause function to return `NULL` instead of stopping.
- Function `plink_glm` expanded documentation to include `delete_files_log` under `seealso` section.

# genbin 0.0.3.9000 (2021-09-20)

- Function `plink_glm` added option `vif`.
- `DESCRIPTION` added github links (URL, BugReports).
- `README.md` cleaned install instructions

# genbin 0.0.4.9000 (2022-05-25)

- Reversed `ref` and `alt` alleles in all association test parser functions
  - In line with the same change in `genio::read_bim`.
  - Original interpretation of ref and alt was wrong, it has now been corrected.
  - Functions affected: `read_bolt_lmm`, `read_gcta_mlma`, `read_gemma_assoc`, `read_plink_glm`, and their downstream dependencies `bolt_lmm`, `gcta_mlma`, `gemma_lmm`, `plink_glm`.
- Function `read_gcta_hsq` and its dependency `gcta_reml` debugged
  - Fixed parser warning by limiting the number of lines to read to the first 4 (excluding header), so now the `$data` component of its return list will be more limited.

# genbin 0.0.5.9000 (2022-05-25)

- Function `plink_glm` added option `max_corr`.

# genbin 0.0.6.9000 (2022-12-07)

- Function `gcta_mlma` added option `file_covar_cat`.
- Removed `LazyData: true` from `DESCRIPTION`

# genbin 0.0.7.9000 (2023-05-11)

- Added functions `plink_hardy`, `read_plink_hardy`, and `delete_files_plink_hardy` to run `plink2 --hardy`, read, and delete its output, respectively.

# genbin 0.0.8.9000 (2023-05-11)

- Function `plink_hardy` added `midp` option.
- Function `read_plink_hardy` supports `midp` output, renaming final column from "midp" to "p".

# genbin 0.0.9.9000 (2024-11-09)

- Function `read_plink_glm` (and its dependency `plink_glm`) updated parser to work with latest plink2 outputs, while retaining backward compatibility to previous format.
