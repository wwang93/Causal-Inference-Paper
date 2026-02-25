# Replication Materials

## Design-Based Causal Inference Examples

This repository contains replication materials for four design-based causal inference examples discussed in the accompanying methods manuscript.

The materials document the implementation of:

1. Propensity score weighting (CBPS)
2. Regression discontinuity (sharp RD)
3. Difference-in-differences (two-period DiD)
4. Instrumental variables (2SLS)

Each example demonstrates the identification strategy, estimation procedure, diagnostic checks, and sensitivity analysis associated with the design.


## Repository Structure

### Source Files

| File | Description |
| --- | --- |
| `appendix-a1-psm.qmd` | Propensity score weighting |
| `appendix-a2-rdd.qmd` | Regression discontinuity |
| `appendix-a3-did.qmd` | Difference-in-differences |
| `appendix-a4-iv.qmd` | Instrumental variables |

Each `.qmd` file is fully executable and self-contained.


### Rendered Output

For transparency and ease of inspection, rendered HTML versions are included:

- `appendix-a1-psm.html`
- `appendix-a2-rdd.html`
- `appendix-a3-did.html`
- `appendix-a4-iv.html`

These files reproduce the results shown in the manuscript.


### Supporting Files

- `rdplot_function.R`
    
    Helper function used in the regression discontinuity example.
    
- `hsls_17_student_pets_sr_v1_0.RData`
    
    Dataset used in the propensity score and difference-in-differences examples.
    
    (See manuscript for data description and access conditions.)
    

## Data

The HSLS dataset used in selected examples is included in `.RData` format.

Users should ensure compliance with any data use agreements associated with the dataset.

The regression discontinuity and instrumental variables examples use simulated data generated within the scripts.


## Reproducing the Results

Each example can be rendered independently.

To re-run a file:

```
quarto render appendix-a1-psm.qmd
quarto render appendix-a2-rdd.qmd
quarto render appendix-a3-did.qmd
quarto render appendix-a4-iv.qmd
```

All required packages are loaded within each document.


## Methodological Scope

The examples correspond to distinct identification frameworks:

- Selection on observables (propensity score weighting)
- Local identification at a cutoff (regression discontinuity)
- Parallel trends (difference-in-differences)
- Exogenous variation via instruments (IV)

Each file documents the assumptions required for causal interpretation and includes design-appropriate diagnostic checks and sensitivity analyses.

