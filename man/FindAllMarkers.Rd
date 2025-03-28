% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/differential_expression.R
\name{FindAllMarkers}
\alias{FindAllMarkers}
\alias{FindAllMarkersNode}
\title{Gene expression markers for all identity classes}
\usage{
FindAllMarkers(
  object,
  assay = NULL,
  features = NULL,
  group.by = NULL,
  logfc.threshold = 0.1,
  test.use = "wilcox",
  slot = "data",
  min.pct = 0.01,
  min.diff.pct = -Inf,
  node = NULL,
  verbose = TRUE,
  only.pos = FALSE,
  max.cells.per.ident = Inf,
  random.seed = 1,
  latent.vars = NULL,
  min.cells.feature = 3,
  min.cells.group = 3,
  mean.fxn = NULL,
  fc.name = NULL,
  base = 2,
  return.thresh = 0.01,
  densify = FALSE,
  ...
)
}
\arguments{
\item{object}{An object}

\item{assay}{Assay to use in differential expression testing}

\item{features}{Genes to test. Default is to use all genes}

\item{group.by}{Regroup cells into a different identity class prior to 
performing differential expression (see example); \code{"ident"} to use Idents}

\item{logfc.threshold}{Limit testing to genes which show, on average, at least
X-fold difference (log-scale) between the two groups of cells. Default is 0.1
Increasing logfc.threshold speeds up the function, but can miss weaker signals.
If the \code{slot} parameter is "scale.data" no filtering is performed.}

\item{test.use}{Denotes which test to use. Available options are:
\itemize{
 \item{"wilcox"} : Identifies differentially expressed genes between two
 groups of cells using a Wilcoxon Rank Sum test (default); will use a fast
 implementation by Presto if installed
 \item{"wilcox_limma"} : Identifies differentially expressed genes between two
 groups of cells using the limma implementation of the Wilcoxon Rank Sum test;
 set this option to reproduce results from Seurat v4
 \item{"bimod"} : Likelihood-ratio test for single cell gene expression,
 (McDavid et al., Bioinformatics, 2013)
 \item{"roc"} : Identifies 'markers' of gene expression using ROC analysis.
 For each gene, evaluates (using AUC) a classifier built on that gene alone,
 to classify between two groups of cells. An AUC value of 1 means that
 expression values for this gene alone can perfectly classify the two
 groupings (i.e. Each of the cells in cells.1 exhibit a higher level than
 each of the cells in cells.2). An AUC value of 0 also means there is perfect
 classification, but in the other direction. A value of 0.5 implies that
 the gene has no predictive power to classify the two groups. Returns a
 'predictive power' (abs(AUC-0.5) * 2) ranked matrix of putative differentially
 expressed genes.
 \item{"t"} : Identify differentially expressed genes between two groups of
 cells using the Student's t-test.
 \item{"negbinom"} : Identifies differentially expressed genes between two
  groups of cells using a negative binomial generalized linear model.
  Use only for UMI-based datasets
 \item{"poisson"} : Identifies differentially expressed genes between two
  groups of cells using a poisson generalized linear model.
  Use only for UMI-based datasets
 \item{"LR"} : Uses a logistic regression framework to determine differentially
 expressed genes. Constructs a logistic regression model predicting group
 membership based on each feature individually and compares this to a null
 model with a likelihood ratio test.
 \item{"MAST"} : Identifies differentially expressed genes between two groups
 of cells using a hurdle model tailored to scRNA-seq data. Utilizes the MAST
 package to run the DE testing.
 \item{"DESeq2"} : Identifies differentially expressed genes between two groups
 of cells based on a model using DESeq2 which uses a negative binomial
 distribution (Love et al, Genome Biology, 2014).This test does not support
 pre-filtering of genes based on average difference (or percent detection rate)
 between cell groups. However, genes may be pre-filtered based on their
 minimum detection rate (min.pct) across both cell groups. To use this method,
 please install DESeq2, using the instructions at
 https://bioconductor.org/packages/release/bioc/html/DESeq2.html
}}

\item{slot}{Slot to pull data from; note that if \code{test.use} is
"negbinom", "poisson", or "DESeq2", \code{slot} will be set to "counts"}

\item{min.pct}{only test genes that are detected in a minimum fraction of
min.pct cells in either of the two populations. Meant to speed up the function
by not testing genes that are very infrequently expressed. Default is 0.01}

\item{min.diff.pct}{only test genes that show a minimum difference in the
fraction of detection between the two groups. Set to -Inf by default}

\item{node}{A node to find markers for and all its children; requires
\code{\link{BuildClusterTree}} to have been run previously; replaces \code{FindAllMarkersNode}}

\item{verbose}{Print a progress bar once expression testing begins}

\item{only.pos}{Only return positive markers (FALSE by default)}

\item{max.cells.per.ident}{Down sample each identity class to a max number.
Default is no downsampling. Not activated by default (set to Inf)}

\item{random.seed}{Random seed for downsampling}

\item{latent.vars}{Variables to test, used only when \code{test.use} is one of
'LR', 'negbinom', 'poisson', or 'MAST'}

\item{min.cells.feature}{Minimum number of cells expressing the feature in at least one
of the two groups, currently only used for poisson and negative binomial tests}

\item{min.cells.group}{Minimum number of cells in one of the groups}

\item{mean.fxn}{Function to use for fold change or average difference calculation.
The default depends on the the value of \code{fc.slot}:
\itemize{
 \item{"counts"} : difference in the log of the mean counts, with pseudocount.
 \item{"data"} : difference in the log of the average exponentiated data, with pseudocount.
 This adjusts for differences in sequencing depth between cells, and assumes that "data"
 has been log-normalized.
 \item{"scale.data"} : difference in the means of scale.data.
}}

\item{fc.name}{Name of the fold change, average difference, or custom function column
in the output data.frame. If NULL, the fold change column will be named
according to the logarithm base (eg, "avg_log2FC"), or if using the scale.data
slot "avg_diff".}

\item{base}{The base with respect to which logarithms are computed.}

\item{return.thresh}{Only return markers that have a p-value < return.thresh, or a power > return.thresh (if the test is ROC)}

\item{densify}{Convert the sparse matrix to a dense form before running the 
DE test. This can provide speedups but might require higher memory; default is FALSE}

\item{...}{Arguments passed to other methods and to specific DE methods}
}
\value{
Matrix containing a ranked list of putative markers, and associated
statistics (p-values, ROC score, etc.)
}
\description{
Finds markers (differentially expressed genes) for each of the identity classes in a dataset
}
\examples{
data("pbmc_small")
# Find markers for all clusters
all.markers <- FindAllMarkers(object = pbmc_small)
head(x = all.markers)
\dontrun{
# Pass a value to node as a replacement for FindAllMarkersNode
pbmc_small <- BuildClusterTree(object = pbmc_small)
all.markers <- FindAllMarkers(object = pbmc_small, node = 4)
head(x = all.markers)
}

}
\concept{differential_expression}
