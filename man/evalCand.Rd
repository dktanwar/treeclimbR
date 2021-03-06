% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/evalCand.R
\name{evalCand}
\alias{evalCand}
\title{evaluate candidate levels and select the best one}
\usage{
evalCand(
  tree,
  type = c("single", "multiple"),
  levels = cand_list,
  score_data = NULL,
  node_column,
  p_column,
  sign_column = sign_column,
  feature_column = NULL,
  method = "BH",
  limit_rej = 0.05,
  use_pseudo_leaf = FALSE,
  message = FALSE
)
}
\arguments{
\item{tree}{A phylo object.}

\item{type}{"single" or "multiple".}

\item{levels}{A list of candidate levels that are selected by
\code{\link{getCand}}. If \code{type = "DA"}, elements in the list are
candidate levels, and are named by values of tuning parameter that are
used. If \code{type = "DS"}, a nested list is required and the list should
be named by the feature (e.g., genes or antibodies). Each element is a list
of candidate levels for a feature (e.g. gene or antibody) that are selected
by \code{\link{getCand}}.}

\item{score_data}{A data frame (\code{type = "DA"}) or a of data frame
(\code{type = "DS"}). Each data frame includes at least one column about
the nodes (\code{node_column}), one column about the p value
(\code{p_column}), one column about the direction of change
(\code{sign_column}) and one optional column about the feature
(\code{feature_column}, this is to distinct the results from different
features for \code{type = "DS"} in the final output.)}

\item{node_column}{The name of the column that gives the node information.}

\item{p_column}{The name of the column that gives p values of nodes.}

\item{sign_column}{The name of the column that gives the direction of the
(estimated) change.}

\item{feature_column}{The name of the column that gives information about the
feature.}

\item{method}{method The multiple testing correction method. Please refer to
the argument \code{method} in \code{\link[stats]{p.adjust}}. Default is
"BH".}

\item{limit_rej}{The FDR level. Default is 0.05.}

\item{use_pseudo_leaf}{TRUE or FALSE. If FALSE, the FDR is
calculated on the leaf level of the tree; If TRUE, the FDR is
calculated on the pseudo leaf level. The pseudo-leaf level is the level on
which entities have sufficient data to run analysis and the level that is
closest to the leaf level.}

\item{message}{A logical value, TRUE or FALSE. Default is FALSE. If TRUE, the
message about running process is printed out.}
}
\value{
a list.
  \describe{
  \item{\code{candidate_best}}{the best candidate level}
  \item{\code{output}}{the result of best candidate level}
  \item{\code{candidate_list}}{a list of candidates}
  \item{\code{level_info}}{the information of all candidates}
  \item{FDR}{the specified FDR level}
  \item{method}{the method to perform multiple test correction.}
  }
 More details about columns in \code{level_info}.
 \itemize{
 \item t the thresholds
 \item r the upper limit of T to control FDR on the leaf level
 \item is_valid whether the threshold is in the range to control leaf FDR
 \item \code{limit_rej} the specified FDR
 \item \code{level_name} the name of the candidate level
 \item \code{rej_leaf} the number of rejection on the leaf level
 \item \code{rej_pseudo_leaf} the number of rejected pseudo leaf nodes.
 \item \code{rej_node} the number of rejection on the tested candidate level
 }
}
\description{
\code{evalCand} evaluate all candidate levels and select the one with best
performance
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
               limit_rej = 0.05 )
cc$output
}
\author{
Ruizhu Huang
}
