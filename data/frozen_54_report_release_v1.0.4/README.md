# Medical AI agent review data - v1.0.4

Analytical snapshot: October 14, 2026. Scope: 54 included reports; R255 excluded. Search cutoff: June 18, 2026. This package exports the current English appendices, not the earlier Zenodo v1.0.2 dataset.

## Files

- `data/report_bibliography.csv`: titles, identifiers, public links, formatted citations, extraction links and extracted report types. AutoCT and VivaBench have formal conference citations but preprint extraction versions.
- `data/report_level_analytical_coding.csv`: one row per report; current characteristics and 33 analytical variables. Obsolete SD_Control, SD_Randomization and SD_Rand_unit fields are not used.
- `data/report_level_values_long.csv`: 54 x 33 = 1,782 report-variable values in long form.
- `data/evaluation_design.csv`: separate design labels, allocation status, method/unit descriptions and patient-trial flag.
- `data/safeguard_coding.csv`: 1,242 report-mechanism rows, with five separate states. Only index-agent evidence contributes.
- `data/safety_outcomes.csv` and `data/report_level_safety_mechanism_summary.csv`: safety-outcome states and co-reporting counts.
- `data/metric_category_reporting.csv`: metric-category reporting states; separate from evaluation methods.
- `data/funding_disclosure_status.csv`: report-level funding/support and funder-role reporting status; missing reporting is not absence of funding.
- `metadata/analytical_value_vocabulary.csv`: observed vocabularies and variable explanations. For free-text design/method descriptions, observed values are examples, not a closed codebook.
- `metadata/variable_summary.csv` and `metadata/denominator_guide.csv`: distributions, denominators and interpretation notes.
- `metadata/mechanism_dictionary.csv`, `metadata/state_dictionary.csv`, `metadata/metric_dictionary.csv`: coding definitions and boundaries.
- `metadata/metric_frequencies.csv` and `metadata/design_label_frequencies.csv`: descriptive counts; overlapping labels must not be summed.
- `metadata/reliability_summary.csv`, `metadata/reliability_not_computable.csv`, `metadata/code_harmonization.csv`: original A/B aggregate reliability and label-harmonization rules.
- `metadata/search_strategy.csv`: retained queries, dates, limits and source counts. ACL/arXiv contribute to the initial total of 546; Google Scholar/project websites/citation tracking are not separately counted.
- `metadata/source_manifest.json`: source appendix hashes and snapshot scope, without private paths.
- `SHA256SUMS.txt`: checksums for package files.

## Interpretation

Counts use reports as the unit of analysis. General percentages use N=54; temporality uses n=46 after excluding 8 Not applicable reports. Retrospective, Prospective, Mixed and Unclear remain separate. Other applicable denominators are specified per variable. Not reported, Unclear and Not applicable are not interchangeable.

Coverage completeness describes the extent of the source set used; it is not reporting completeness or study quality. A clinical setting, simulation, prospective component, technical comparison or randomized reading order is not evidence of routine deployment, patient-care benefit or a patient randomized trial. Safety reporting, implementation, evaluation and use are separate dimensions, not a maturity hierarchy or effectiveness score.

`Variable_ID`/`variable_id` identify analysis fields; `mechanism_id` and `category_id` identify mechanism/metric categories. Display names are in the corresponding dictionaries. Bibliographic publication type and the type of the report version used for extraction are deliberately distinct.

In `variable_summary.csv`, `Total_n` counts report observations; `Yes`, `No`, `Not_reported`, `Unclear` and `Not_applicable` are category counts; `Other_values` lists remaining categories; `Valid_n` is the applicable denominator. `Source_verified`, `Consensus` and `Derived` are historical classification-provenance counts, not study outcomes, quality scores, or certification that every source field was independently reverified. `Notes` explains the variable. These provenance counts should not be used as an independent reliability measure.

Original A/B codes were preserved. Reliability summaries describe original pre-consensus coding; final source-based classifications were not used to recalculate kappa. Author-confirmed updates were checked before export, but this release is not a new independent recoding of the complete dataset.

## Public scope and reuse

Only structured review data, bibliographic metadata and original coding definitions are distributed under the repository CC-BY-4.0 license. No full-text PDFs, long source quotations, private local paths, raw A/B workbooks or internal adjudication files are included. Report IDs are review tracking identifiers, not external persistent identifiers. A blank DOI means no DOI was recorded, not that the report has no DOI.

Cite dataset version 1.0.4 and the repository commit used. No new DOI is asserted; Zenodo v1.0.2 is an earlier archive and is not this analytical version.
