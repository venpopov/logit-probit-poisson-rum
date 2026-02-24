#' @example
#' library(ggplot2)
#' library(ggdist)
#' library(distributional)
#' utilities <- seq(0, 2, length.out = 8)
#' plot_utility_distributions(utilities,
#'   dist_fun = dist_normal,
#'   title = "Gaussian (Normal) noise",
#'   sd = 1
#' )
#' plot_utility_distributions(utilities,
#'   dist_fun = dist_gumbel,
#'   title = "Gumbel (Type I EV) noise",
#'   scale = sqrt(6) / pi
#' )
plot_utility_distributions <- function(utilities, dist_fun = dist_normal,
                                       title = "Noise distributions",
                                       fill_alpha = 0.4, height = 0.8, xlim = c(-3, 5.5), ...) {
  # Build a data frame: one row per alternative
  df <- data.frame(
    alternative = factor(seq_along(utilities)),
    utility     = utilities
  )

  # Create distributions shifted by utility (via mean/mu argument)
  df$dist <- dist_fun(utilities, ...)

  # Draw one random sample per alternative using distributional
  df$sample <- vapply(df$dist, function(d) generate(d, 1)[[1]], numeric(1))

  # Flag the alternative with the maximum draw
  df$is_max <- df$sample == max(df$sample)

  ggplot(df, aes(
    y = utility, xdist = dist,
    fill = alternative, color = alternative
  )) +
    stat_slab(
      alpha = fill_alpha, height = height,
      normalize = "groups"
    ) +
    geom_point(aes(x = sample),
      shape = 21, size = 4, stroke = 0.8, alpha = 0.5
    ) +
    # Highlight the winning draw
    geom_point(
      data = df[df$is_max, ],
      aes(x = sample, y = utility),
      shape = 21, size = 5, color = "black", stroke = 1
    ) +
    labs(
      x = "Utility + noise",
      title = title,
    ) +
    xlim(xlim) +
    theme_minimal(base_size = 13) +
    theme(
      legend.position = "none",
      panel.grid = element_blank(),
      axis.title.y = element_blank(),
      axis.text.y = element_blank(),
      axis.ticks.y = element_blank()
    )
}

# -- Equation panel helpers for patchwork --

plot_equation <- function(expr, title = NULL, size = 5) {
  p <- ggplot() +
    annotate("text",
      x = 0.5, y = 0.5,
      label = expr,
      parse = TRUE,
      size = size
    ) +
    xlim(0, 1) +
    ylim(0, 1) +
    theme_void(base_size = 13)

  if (!is.null(title)) {
    p <- p + labs(title = title) +
      theme(plot.title = element_text(hjust = 0.5))
  }
  p
}

plot_softmax_equation <- function(size = 5) {
  plot_equation(
    expr = "P(C == i) == frac(exp({v[i]}), sum(exp({v[j]}), j == 0, K))",
    title = "Multinomial Logit (Softmax)",
    size = size
  )
}

plot_probit_equation <- function(size = 5) {
  plot_equation(
    expr = "P(C == i) == integral(
      prod(Phi(x - v[j]), j != i) %.% phi(x - v[i]) * d * x,
      -infinity, +infinity
    )",
    title = "(Independent) Multinomial Probit",
    size = size
  )
}
