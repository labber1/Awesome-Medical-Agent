# Medical AI Agents Evaluation and Safety Oversight Data

Version: 1.0.2
Frozen analysis scope: 54 included reports; R255 excluded after the final eligibility audit.
Search cutoff: June 18, 2026.

## Contents

- `data/report_level_analytical_coding.csv`: one row per included report, with report-level characteristics and analytical variables.
- `data/report_bibliography.csv`: public bibliographic metadata linking report identifiers to titles, DOI/source identifiers, URLs, years, and publication types.
- `data/safeguard_coding.csv`: report-level safeguard and governance mechanism states. System identifiers and source-provenance fields are excluded.
- `data/safety_outcomes.csv`: report-level safety-related outcome categories and reporting status.
- `data/report_level_safety_mechanism_summary.csv`: report-level co-reporting summary used for cross-tabulated analyses.
- `metadata/analytical_value_vocabulary.csv`: allowed analytical values and coding notes.
- `metadata/variable_summary.csv`: variable-level counts and quality-control fields.
- `metadata/denominator_guide.csv`: analysis-specific denominator rules.
- `metadata/mechanism_dictionary.csv`: public mechanism definitions and interpretive boundaries.
- `metadata/state_dictionary.csv`: meanings and boundaries of mechanism status values.
- `metadata/reliability_summary.csv`: aggregate observed agreement and Cohen's kappa results.
- `metadata/reliability_not_computable.csv`: fields excluded from reliability estimation and reasons.
- `metadata/code_harmonization.csv`: reviewer-label harmonization rules used before reliability calculation.
- `metadata/search_strategy.csv`: retained structured search strategies and search counts.

## Data protection and scope

This release contains derived, de-identified review data. It does not redistribute full-text articles, copyrighted source excerpts, source-text snippets, internal workbook locators, or system-specific identifiers. Reviewer-specific raw A/B coding is not included; reliability is provided as aggregate output.

The report identifiers are study-tracking identifiers created for this review and are not external persistent identifiers. In `data/report_bibliography.csv`, a blank DOI indicates that no DOI was recorded for that report in the final source registry; the corresponding source URL is retained where available. Interpretations should follow the codebook and denominator guide. `Not reported`, `Unclear`, and `Not applicable` are distinct states and should not be collapsed without reference to the manuscript definitions.

## Reuse and citation

This release is intended to support verification and reuse of the descriptive analyses reported in the associated scoping review. It is distributed within the public repository under the repository-level CC-BY-4.0 license for the structured metadata and original coding. A release-specific DOI is not asserted in this folder; cite the repository and identify this release as version 1.0.2.

## Provenance

The release was derived from the final submission appendices prepared for the revised manuscript. The release package was generated without exporting the source-excerpt and internal-audit columns from those workbooks.
