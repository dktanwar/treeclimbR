% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/topNodes.R
\name{topNodes}
\alias{topNodes}
\title{Table of the top entities (nodes)}
\usage{
topNodes(object, n = 10, sort_by = NULL, p_value = 1)
}
\arguments{
\item{object}{The output from \link{evalCand}.}

\item{n}{A integer, maximum number of entities to return.}

\item{sort_by}{A character string specifying the sort method. Possibilities
are "PValue" for p-value, "logFC" for absolute log-fold change or "none"
for no sorting.}

\item{p_value}{A numeric cutoff value for adjusted p-values. Only entities
with adjusted p-values equal or lower than specified are returned.}
}
\value{
A data frame. Columns including \strong{logFC}, \strong{logCPM},
  \strong{PValue}, \strong{FDR}, \strong{F} (or \strong{LR}) are from (the
  output table of) \code{\link[edgeR]{topTags}}. The \strong{node} column
  stores the node number for each entities. Note: \strong{FDR} is corrected
  when \code{type = "DS"} because of pooling all features and nodes .
}
\description{
Table of the top entities (nodes)
}
\examples{
library(TreeSummarizedExperiment)
library(ggtree)

data(tinyTree)
ggtree(tinyTree, branch.length = "none") +
   geom_text2(aes(label = node)) +
   geom_hilight(node = 13, fill = "blue", alpha = 0.5) +
   geom_hilight(node = 18, fill = "orange", alpha = 0.5)
set.seed(2)
pv <- runif(19, 0, 1)
pv[c(1:5, 13, 14, 18)] <- runif(8, 0, 0.001)

fc <- sample(c(-1, 1), 19, replace = TRUE)
fc[c(1:3, 13, 14)] <- 1
fc[c(4, 5, 18)] <- -1
df <- data.frame(node = 1:19,
                 pvalue = pv,
                 foldChange = fc)
ll <- getCand(tree = tinyTree, score_data = df,
              #t = seq(0, 1, by = 0.05),
               node_column = "node",
               p_column = "pvalue",
               sign_column = "foldChange")
cc <- evalCand(tree = tinyTree, levels = ll$candidate_list,
               score_data = df, node_column = "node",
               p_column = "pvalue", sign_column = "foldChange",
               limit_rej = 0.05)
             
topOut <- topNodes(object = cc)

}
