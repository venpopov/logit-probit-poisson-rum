#' Poisson Count Race choice probability for binary choice
#'
#' Given log-odds x = log(lambda1/lambda2) and threshold theta,
#' compute Pr(choice = 1) using the regularized incomplete beta function.
#'
#' @param x Numeric vector. Log-odds (can be thought of as v1 - v2).
#' @param theta Positive integer. Accumulation threshold.
#' @return Numeric vector of choice probabilities.
race_prob <- function(x, theta) {
  p <- 1 / (1 + exp(-x))
  pbeta(p, shape1 = theta, shape2 = theta)
}

#' Compute residuals relative to Logit reference on a variance-matched axis
#'
#' For a grid of rescaled signal values s, computes
#'   Pr_race(s * sd_diff(theta), theta) - Logit_ref(s)
#' where Logit_ref uses the sd of the logit (theta=1) noise difference.
#'
#' @param s Numeric vector. Rescaled signal values.
#' @param theta Positive integer. Accumulation threshold.
#' @return Numeric vector of residuals.
race_residual <- function(s, theta) {

  # sd of epsilon1 - epsilon2 for this theta
  sd_diff <- sqrt(2 * trigamma(theta))
  x <- s * sd_diff
  y <- race_prob(x, theta)


  # Logit reference: at theta = 1, sd_diff = pi / sqrt(3)
  sd_diff_logit <- pi / sqrt(3)
  logit_ref <- 1 / (1 + exp(-s * sd_diff_logit))

  y - logit_ref
}

#' Compute probit residual relative to Logit reference
#'
#' @param s Numeric vector. Rescaled signal values.
#' @return Numeric vector of residuals (Phi(s) - Logit_ref(s)).
probit_residual <- function(s) {
  sd_diff_logit <- pi / sqrt(3)
  logit_ref <- 1 / (1 + exp(-s * sd_diff_logit))
  pnorm(s) - logit_ref
}
