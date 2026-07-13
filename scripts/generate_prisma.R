#!/usr/bin/env Rscript

# Generate PRISMA-style flow diagram with prisma-flowdiagram/PRISMA2020
# Final 41 included records, updated with MIRA and Grolleau.

args <- commandArgs(trailingOnly = FALSE)
file_arg <- grep("^--file=", args, value = TRUE)
script_path <- if (length(file_arg)) {
  normalizePath(sub("^--file=", "", file_arg[[1]]), winslash = "/")
} else {
  normalizePath("scripts/generate_prisma.R", winslash = "/")
}
repo_dir <- normalizePath(file.path(dirname(script_path), ".."), winslash = "/")
out_dir <- file.path(repo_dir, "figures")
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
csv_path <- tempfile("prisma2020_final41_R_input_", fileext = ".csv")

rows <- data.frame(
  data = c(
    "", "previous_studies", "previous_reports", "", "database_results", "database_specific_results",
    "register_results", "register_specific_results", "", "website_results", "organisation_results",
    "citations_results", "duplicates", "excluded_automatic", "excluded_other", "records_screened",
    "records_excluded", "dbr_sought_reports", "dbr_notretrieved_reports", "other_sought_reports",
    "other_notretrieved_reports", "dbr_assessed", "dbr_excluded", "other_assessed", "other_excluded",
    "new_studies", "new_reports", "total_studies", "total_reports", "identification", "screening",
    "included", "total_studies_ma", "total_reports_ma"
  ),
  node = c(
    "node4", "node5", "", "node6", "node7", "", "", "", "node16", "node17", "", "",
    "node8", "", "", "node9", "node10", "node11", "node12", "node18", "node19",
    "node13", "node14", "node20", "node21", "node15", "", "node22", "", "node1", "node2",
    "node3", "node23", ""
  ),
  box = c(
    "prevstud", "box1", "box1", "newstud", "box2", "box2", "box2", "box2", "othstud", "box11",
    "box11", "box11", "box3", "box3", "box3", "box4", "box5", "box6", "box7", "box12",
    "box13", "box8", "box9", "box14", "box15", "box10", "box10", "box16", "box16",
    "identification", "screening", "included", "box17", "box17"
  ),
  description = c(
    "Grey title box; Previous studies",
    "Studies included in previous version of review",
    "Reports of studies included in previous version of review",
    "Grey title box; Identification of records via databases and preprint repositories",
    "Records identified from databases and targeted sources",
    "Records identified from specific sources",
    "Records identified from registers",
    "Records identified from specific registers",
    "Grey title box; Identification of records via other methods",
    "Records identified from websites",
    "Records identified from organisations",
    "Records identified from citation searching",
    "Duplicate or overlapping records removed",
    "Records marked as ineligible by automation tools",
    "Records removed for other reasons",
    "Records screened",
    "Records excluded",
    "Records retained for detailed verification",
    "Records not retrieved",
    "Reports sought for retrieval from other sources",
    "Reports not retrieved from other sources",
    "Records assessed for eligibility",
    "Records excluded",
    "Reports assessed for eligibility from other methods",
    "Reports excluded from other methods",
    "Records included in review",
    "Reports of new included studies",
    "Total studies included in review",
    "Reports of total included studies",
    "Blue identification box",
    "Blue screening box",
    "Blue included box",
    "Total studies included in meta-analysis",
    "Reports of total included studies in meta-analysis"
  ),
  boxtext = c(
    "Previous studies", "Studies included in previous version of review", "Reports of studies included in previous version of review",
    "Identification of records via databases and preprint repositories", "Records identified", "Specific sources",
    "Registers", "Specific registers", "Identification of records via other methods", "Websites", "Organisations",
    "Citation searching", "Duplicate or overlapping records removed", "Records marked as ineligible by automation tools",
    "Records removed for other reasons", "Records screened", "Records excluded", "Records retained for detailed verification",
    "Records not retrieved", "Reports sought for retrieval", "Reports not retrieved", "Records assessed for eligibility",
    "Records excluded", "Reports assessed for eligibility", "Reports excluded", "Records included in review",
    "Reports of new included studies", "Total studies included in review", "Reports of total included studies",
    "Identification", "Screening", "Included", "Total studies included in meta-analysis",
    "Reports of total included studies in meta-analysis"
  ),
  tooltips = c(
    "Grey title box; Previous studies", "", "", "Grey title box; Identification of records via databases and preprint repositories",
    "Databases and targeted sources", "", "", "", "Grey title box; Identification of records via other methods",
    "", "", "", "Duplicate or overlapping records removed", "", "", "Title/abstract and preliminary screening",
    "Not advanced after preliminary screening", "Full-record relevance and methodological verification",
    "All retained records were available for full-record verification", "", "", "Detailed verification and final manual audit",
    "Eligibility exclusions", "", "", "Final manually audited included records", "", "Final manually audited included records",
    "", "Blue identification box", "Blue screening box", "Blue included box", "", ""
  ),
  url = c(
    "prevstud.html", "previous_studies.html", "previous_reports.html", "newstud.html", "database_results.html",
    "database_results.html", "", "database_results.html", "othstud.html", "website_results.html", "", "",
    "duplicates.html", "", "", "records_screened.html", "records_excluded.html", "dbr_sought_reports.html",
    "dbr_notretrieved_reports.html", "other_sought_reports.html", "other_notretrieved_reports.html", "dbr_assessed.html",
    "dbrexcludedrecords.html", "other_assessed.html", "", "new_studies.html", "", "total_studies.html", "",
    "identification.html", "screening.html", "included.html", "total_studies_meta_analysis.html", ""
  ),
  n = c(
    0, NA, NA, 0, 546, "PubMed, 113; Web of Science, 159; IEEE Xplore, 49; ACM Digital Library, 41; ACL Anthology, 84; arXiv, 100",
    NA, NA, 0, NA, NA, NA, 77, NA, NA, 469, 337, 132, 0, 0, 0, 132,
    "Not advanced after detailed relevance and full-record verification, 85", 0, NA, 41, NA, 41, NA,
    0, 0, 0, NA, NA
  ),
  stringsAsFactors = FALSE
)
write.csv(rows, csv_path, row.names = FALSE, na = "")

required_packages <- c("PRISMA2020", "DiagrammeRsvg", "rsvg")
missing_packages <- required_packages[
  !vapply(required_packages, requireNamespace, logical(1), quietly = TRUE)
]
if (length(missing_packages)) {
  stop(
    "Missing required R packages: ", paste(missing_packages, collapse = ", "),
    ". See the repository README for installation instructions."
  )
}

raw <- read.csv(csv_path, stringsAsFactors = FALSE, na.strings = c("", "NA"))
dat <- PRISMA2020::PRISMA_data(raw)

plot <- PRISMA2020::PRISMA_flowdiagram(
  dat,
  interactive = FALSE,
  previous = FALSE,
  other = FALSE,
  detail_databases = TRUE,
  detail_registers = FALSE,
  meta_analysis = FALSE,
  side_boxes = TRUE,
  fontsize = 8,
  font = "Arial",
  title_colour = "LightSteelBlue1",
  greybox_colour = "Gainsboro",
  main_colour = "Black",
  arrow_colour = "Black"
)

svg_path <- file.path(out_dir, "prisma_flow_final41.svg")
png_path <- file.path(out_dir, "prisma_flow_final41.png")
pdf_path <- file.path(out_dir, "prisma_flow_final41.pdf")

svg <- DiagrammeRsvg::export_svg(plot)

# Add readable stage labels when the package leaves simplified side labels blank.
svg <- sub(
  '(<g id="a_node1"><a xlink:title="Blue identification box">\\s*<path[^>]+/>)',
  '\\1\n<text text-anchor="middle" x="14.5" y="-515" font-family="Arial" font-size="8.00" font-weight="bold" fill="#000000" transform="rotate(-90 14.5 -515)">Identification</text>',
  svg,
  perl = TRUE
)
svg <- sub(
  '(<g id="a_node2"><a xlink:title="Blue screening box">\\s*<path[^>]+/>)',
  '\\1\n<text text-anchor="middle" x="14.5" y="-277" font-family="Arial" font-size="8.00" font-weight="bold" fill="#000000" transform="rotate(-90 14.5 -277)">Screening</text>',
  svg,
  perl = TRUE
)
svg <- sub(
  '(<g id="a_node3"><a xlink:title="Blue included box">\\s*<path[^>]+/>)',
  '\\1\n<text text-anchor="middle" x="14.5" y="-90" font-family="Arial" font-size="8.00" font-weight="bold" fill="#000000" transform="rotate(-90 14.5 -90)">Included</text>',
  svg,
  perl = TRUE
)

# Replace identification box wording with manuscript wording.
id_replacement <- paste0(
  '<text text-anchor="middle" x="176.5" y="-594.0" font-family="Arial" font-size="8.00" fill="#000000">Records identified from databases</text>\n',
  '<text text-anchor="middle" x="176.5" y="-584.4" font-family="Arial" font-size="8.00" fill="#000000">and preprint repositories</text>\n',
  '<text text-anchor="middle" x="176.5" y="-574.8" font-family="Arial" font-size="8.00" fill="#000000">n = 546</text>\n',
  '<text text-anchor="middle" x="176.5" y="-560.4" font-family="Arial" font-size="8.00" font-weight="bold" fill="#000000">Peer-reviewed databases:</text>\n',
  '<text text-anchor="middle" x="176.5" y="-550.8" font-family="Arial" font-size="8.00" fill="#000000">PubMed n = 113; Web of Science n = 159</text>\n',
  '<text text-anchor="middle" x="176.5" y="-541.2" font-family="Arial" font-size="8.00" fill="#000000">IEEE Xplore n = 49; ACM Digital Library n = 41</text>\n',
  '<text text-anchor="middle" x="176.5" y="-531.6" font-family="Arial" font-size="8.00" fill="#000000">ACL Anthology n = 84</text>\n',
  '<text text-anchor="middle" x="176.5" y="-517.2" font-family="Arial" font-size="8.00" font-weight="bold" fill="#000000">Preprint repository:</text>\n',
  '<text text-anchor="middle" x="176.5" y="-507.6" font-family="Arial" font-size="8.00" fill="#000000">arXiv n = 100</text>'
)
svg <- sub(
  '<text text-anchor="middle" x="176\\.5" y="-[0-9.]+"[^>]*>Records identified from:</text>\\s*<text text-anchor="middle" x="176\\.5" y="-[0-9.]+"[^>]*>Records identified \\(n = 546\\):</text>[\\s\\S]*?<text text-anchor="middle" x="176\\.5" y="-[0-9.]+"[^>]*>arXiv \\(n = 100\\)</text>',
  id_replacement,
  svg,
  perl = TRUE
)

# Remove package-generated redundant nodes: Records not retrieved (n=0) and second eligibility node.
svg <- gsub('<!-- 8&#45;&gt;9 -->\\s*<g id="edge7" class="edge">[\\s\\S]*?</g>', '', svg, perl = TRUE)
svg <- gsub('<!-- 8&#45;&gt;10 -->\\s*<g id="edge8" class="edge">[\\s\\S]*?</g>', '', svg, perl = TRUE)
svg <- gsub('<!-- 10&#45;&gt;12 -->\\s*<g id="edge10" class="edge">[\\s\\S]*?</g>', '', svg, perl = TRUE)
svg <- gsub('<!-- 10&#45;&gt;C -->\\s*<g id="edge9" class="edge">[\\s\\S]*?</g>', '', svg, perl = TRUE)
svg <- gsub('<!-- 9 -->[\\s\\S]*?(?=<!-- 10 -->)', '', svg, perl = TRUE)
svg <- gsub('<!-- 10 -->[\\s\\S]*?(?=<!-- 11 -->)', '', svg, perl = TRUE)
svg <- gsub('<!-- 11 -->[\\s\\S]*?(?=<!-- 12 -->)', '', svg, perl = TRUE)

# Insert direct n=132 -> n=85 and n=47, then n=47 -> n=6 and n=41.
detailed_exclusion_box <- paste0(
  '<!-- Detailed-verification exclusions -->\n',
  '<g id="node_detailed_exclusions" class="node">\n',
  '<title>Detailed-verification exclusions</title>\n',
  '<g id="a_node_detailed_exclusions"><a xlink:title="Records excluded after detailed verification">\n',
  '<polygon fill="#ffffff" stroke="#000000" points="590.5,-334 338.5,-334 338.5,-278 590.5,-278 590.5,-334"/>\n',
  '<text text-anchor="middle" x="464.5" y="-320.4" font-family="Arial" font-size="8.00" fill="#000000">Excluded after</text>\n',
  '<text text-anchor="middle" x="464.5" y="-310.8" font-family="Arial" font-size="8.00" fill="#000000">detailed verification</text>\n',
  '<text text-anchor="middle" x="464.5" y="-301.2" font-family="Arial" font-size="8.00" fill="#000000">n = 85</text>\n',
  '<text text-anchor="middle" x="464.5" y="-291.6" font-family="Arial" font-size="8.00" fill="#000000">PCC/RQ fit and related reasons</text>\n',
  '</a></g></g>'
)
retained_node <- paste0(
  '<!-- Records retained after detailed eligibility verification -->\n',
  '<g id="node_retained_records" class="node">\n',
  '<title>Records retained after detailed eligibility verification</title>\n',
  '<g id="a_node_retained_records"><a xlink:title="Records retained after detailed eligibility verification">\n',
  '<polygon fill="none" stroke="#000000" points="302.5,-234 50.5,-234 50.5,-198 302.5,-198 302.5,-234"/>\n',
  '<text text-anchor="middle" x="176.5" y="-220.8" font-family="Arial" font-size="8.00" fill="#000000">Records retained after detailed</text>\n',
  '<text text-anchor="middle" x="176.5" y="-211.2" font-family="Arial" font-size="8.00" fill="#000000">eligibility verification (n = 47)</text>\n',
  '</a></g></g>'
)
final_audit_box <- paste0(
  '<!-- Final manual audit exclusions -->\n',
  '<g id="node_final_manual_audit" class="node">\n',
  '<title>Final manual audit exclusions</title>\n',
  '<g id="a_node_final_manual_audit"><a xlink:title="Records removed during final manual audit">\n',
  '<polygon fill="#ffffff" stroke="#000000" points="590.5,-243.4 338.5,-243.4 338.5,-188.6 590.5,-188.6 590.5,-243.4"/>\n',
  '<text text-anchor="middle" x="464.5" y="-232.8" font-family="Arial" font-size="8.00" fill="#000000">Removed during</text>\n',
  '<text text-anchor="middle" x="464.5" y="-223.2" font-family="Arial" font-size="8.00" fill="#000000">final manual audit; n = 6</text>\n',
  '<text text-anchor="middle" x="464.5" y="-208.8" font-family="Arial" font-size="8.00" fill="#000000">Topic drift n = 4</text>\n',
  '<text text-anchor="middle" x="464.5" y="-199.2" font-family="Arial" font-size="8.00" fill="#000000">Scope mismatch n = 2</text>\n',
  '</a></g></g>'
)
edges <- paste0(
  '<!-- detailed verification to detailed exclusions -->\n',
  '<g id="edge_detailed_to_exclusions" class="edge">\n',
  '<title>detailed-&gt;exclusions</title>\n',
  '<path fill="none" stroke="#000000" d="M302.6358,-306C311.0038,-306 319.5087,-306 327.9675,-306"/>\n',
  '<polygon fill="#000000" stroke="#000000" points="328.1958,-309.5001 338.1958,-306 328.1957,-302.5001 328.1958,-309.5001"/>\n',
  '</g>\n',
  '<!-- detailed verification to retained records -->\n',
  '<g id="edge_detailed_to_retained" class="edge">\n',
  '<title>detailed-&gt;retained</title>\n',
  '<path fill="none" stroke="#000000" d="M176.5,-287.8314C176.5,-275.131 176.5,-257.974 176.5,-244.416"/>\n',
  '<polygon fill="#000000" stroke="#000000" points="180.0001,-244.4132 176.5,-234.4133 173.0001,-244.4133 180.0001,-244.4132"/>\n',
  '</g>\n',
  '<!-- retained records to included records -->\n',
  '<g id="edge_retained_to_included" class="edge">\n',
  '<title>retained-&gt;included</title>\n',
  '<path fill="none" stroke="#000000" d="M176.5,-197.7933C176.5,-177.5514 176.5,-144.3057 176.5,-118.4506"/>\n',
  '<polygon fill="#000000" stroke="#000000" points="180.0001,-118.4132 176.5,-108.4133 173.0001,-118.4133 180.0001,-118.4132"/>\n',
  '</g>\n',
  '<!-- retained records to final manual audit exclusions -->\n',
  '<g id="edge_retained_to_audit" class="edge">\n',
  '<title>retained-&gt;final audit</title>\n',
  '<path fill="none" stroke="#000000" d="M302.6358,-216C311.0038,-216 319.5087,-216 327.9675,-216"/>\n',
  '<polygon fill="#000000" stroke="#000000" points="328.1958,-219.5001 338.1958,-216 328.1957,-212.5001 328.1958,-219.5001"/>\n',
  '</g>'
)
svg <- sub('<!-- 12 -->', paste0(edges, "\n", detailed_exclusion_box, "\n", retained_node, "\n", final_audit_box, "\n<!-- 12 -->"), svg, fixed = TRUE)

writeLines(svg, svg_path, useBytes = TRUE)
rsvg::rsvg_png(svg_path, png_path, width = 1048, height = 1199)
rsvg::rsvg_pdf(svg_path, pdf_path)

message("Wrote: ", svg_path)
message("Wrote: ", png_path)
message("Wrote: ", pdf_path)
