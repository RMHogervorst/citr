#' Insert citation in Markdown format
#'
#' Look up entries in bibliography and insert citation in Markdown format if exactly one match is returned.
#'
#' @inheritParams query_bib
#' @param in_paren Logical. Determines if citation is in parentheses.
#'
#' @details The path to the BibTeX-file can be set in the global options and is set to
#'    \code{references.bib} when the package is loaded. Once the path is changed in the
#'    RStudio addin, the global option is updated.
#'
#' @return If the bibliography contains exactly one match the formated citation is returned, otherwise
#'    returns \code{NULL}. \code{md_cite} returns an in-text citation (\code{"@foo2016"}), \code{md_cite}
#'    returns an in-parenthesis citation (\code{"[@foo2016]"}).
#' @seealso \code{\link{insert_citation}}
#' @export
#'
#' @examples
#' \dontrun{
#'   md_cite("foo 2016", bib_file = "references.bib")
#' }

md_cite <- function(
  x
  , in_paren = TRUE
  , bib_file = options("bibliography_path")
) {

  # Query BibTeX file
  selected_entries <- query_bib(x, bib_file = bib_file)
  selected_keys <- names(selected_entries)

  # Print queried references
  tmp <- lapply(selected_entries, function(y) {
    reference <- utils::capture.output(print(
      y
      , .opts = list(
        bib.style = "authoryear"
        , no.print.fields = c("isbn", "issn", "copyright", "url", "urldate", "month", "note", "language")
      )
    ))
    cat(gsub("\\[1\\]", "\t", reference), "\n\n")
  })

  # Return citation keys
  paste_citation_keys(selected_keys, in_paren)
}


paste_citation_keys <- function(keys, in_paren = FALSE) {
  if(in_paren) {
    keys <- paste(keys, collapse = "; @")
    paste0("[@", keys, "]")
  } else {
    n_keys <- length(keys)
    if(n_keys == 0) {
      keys <- ""
    } else if(n_keys == 1) {
      keys <- keys
    } else if(n_keys == 2) {
      keys <- paste(keys, collapse = " and @")
    } else if(n_keys > 2) {
      keys <- paste(
        paste(keys[-n_keys], collapse = ", @")
        , keys[n_keys]
        , sep = ", and @"
      )
    }

    paste0("@", keys)
  }
}