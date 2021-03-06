% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/preprocessing.R
\name{Read10X}
\alias{Read10X}
\title{Load in data from 10X}
\usage{
Read10X(
  data.dir,
  gene.column = 2,
  cell.column = 1,
  unique.features = TRUE,
  strip.suffix = FALSE
)
}
\arguments{
\item{data.dir}{Directory containing the matrix.mtx, genes.tsv (or features.tsv), and barcodes.tsv
files provided by 10X. A vector or named vector can be given in order to load
several data directories. If a named vector is given, the cell barcode names
will be prefixed with the name.}

\item{gene.column}{Specify which column of genes.tsv or features.tsv to use for gene names; default is 2}

\item{cell.column}{Specify which column of barcodes.tsv to use for cell names; default is 1}

\item{unique.features}{Make feature names unique (default TRUE)}

\item{strip.suffix}{Remove trailing "-1" if present in all cell barcodes.}
}
\value{
If features.csv indicates the data has multiple data types, a list
  containing a sparse matrix of the data from each type will be returned.
  Otherwise a sparse matrix containing the expression data will be returned.
}
\description{
Enables easy loading of sparse data matrices provided by 10X genomics.
}
\examples{
\dontrun{
# For output from CellRanger < 3.0
data_dir <- 'path/to/data/directory'
list.files(data_dir) # Should show barcodes.tsv, genes.tsv, and matrix.mtx
expression_matrix <- Read10X(data.dir = data_dir)
seurat_object = CreateSeuratObject(counts = expression_matrix)

# For output from CellRanger >= 3.0 with multiple data types
data_dir <- 'path/to/data/directory'
list.files(data_dir) # Should show barcodes.tsv.gz, features.tsv.gz, and matrix.mtx.gz
data <- Read10X(data.dir = data_dir)
seurat_object = CreateSeuratObject(counts = data$`Gene Expression`)
seurat_object[['Protein']] = CreateAssayObject(counts = data$`Antibody Capture`)
}

}
\concept{preprocessing}
