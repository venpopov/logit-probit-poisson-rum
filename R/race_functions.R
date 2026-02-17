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


# ── Core simulation engine ──────────────────────────────────────────────────
#' Simulate choice probabilities from the temperature-identified Poisson count race
#'
#' @param v   Numeric vector of systematic utilities (length K)
#' @param theta  Accumulation threshold (positive integer)
#' @param beta   Temperature (noise scale)
#' @param n_sim  Number of Monte Carlo draws
#' @return Named numeric vector of estimated choice probabilities
race_choice_probs <- function(v, theta, beta = 1, n_sim = 1e6) {
  K <- length(v)
  # Draw Gamma(theta, 1) for each alternative and each simulation
  G <- matrix(rgamma(n_sim * K, shape = theta, rate = 1), nrow = n_sim, ncol = K)
  # Standardised log-Gamma noise
  mu_theta <- digamma(theta)
  sd_theta <- sqrt(trigamma(theta))
  Z <- (-log(G) + mu_theta) / sd_theta
  # Temperature-identified utilities
  U <- sweep(Z * beta, 2, v, "+")
  # Choice = argmax
  choices <- max.col(U, ties.method = "random")
  tabulate(choices, nbins = K) / n_sim
}

#' Multinomial Logit (softmax) choice probabilities (exact)
#'
#' Under temperature identification with fixed beta, the Gumbel scale parameter
#' is b = beta * sqrt(6) / pi, so the softmax inverse temperature is
#' pi / (beta * sqrt(6)).
#' @param v   Numeric vector of systematic utilities
#' @param beta  Temperature
#' @return Numeric vector of choice probabilities
mnl_probs <- function(v, beta = 1) {
  sigma_gumbel <- pi / sqrt(6)   # SD of Gumbel(0,1)
  scaled <- v * sigma_gumbel / beta  # = v * pi / (beta * sqrt(6))
  ev <- exp(scaled - max(scaled))
  ev / sum(ev)
}

#' Multinomial Probit choice probabilities (Monte Carlo)
#'
#' Independent equal-variance Gaussian errors with scale beta.
#' @param v   Numeric vector of systematic utilities
#' @param beta  Temperature
#' @param n_sim Number of Monte Carlo draws
#' @return Numeric vector of estimated choice probabilities
mnp_probs <- function(v, beta = 1, n_sim = 1e6) {
  K <- length(v)
  Z <- matrix(rnorm(n_sim * K), nrow = n_sim, ncol = K)
  U <- sweep(Z * beta, 2, v, "+")
  choices <- max.col(U, ties.method = "random")
  tabulate(choices, nbins = K) / n_sim
}

#' Total variation distance between two probability vectors
tv_dist <- function(p, q) 0.5 * sum(abs(p - q))


# Helper: probit P(target) for symmetric case (1 target vs K-1 equal competitors)
probit_target_prob <- function(v_t, beta, K) {
  integrand <- function(z) dnorm(z) * pnorm(v_t / beta + z)^(K - 1)
  integrate(integrand, -10, 10, rel.tol = 1e-10)$value
}

# Recover logit beta from observed P(target)
recover_logit_beta <- function(p_target, v_t, K) {
  sigma_G <- pi / sqrt(6)
  if (p_target <= 1/K || p_target >= 1) return(NA_real_)
  a <- log(p_target * (K - 1) / (1 - p_target))
  if (a <= 0) return(NA_real_)
  v_t * sigma_G / a
}

# Recover probit beta from observed P(target) via root-finding
recover_probit_beta <- function(p_target, v_t, K) {
  if (p_target <= 1/K || p_target >= 1) return(NA_real_)
  f <- function(log_beta) probit_target_prob(v_t, exp(log_beta), K) - p_target
  tryCatch({
    root <- uniroot(f, interval = c(log(0.01), log(50)), tol = 1e-8)
    exp(root$root)
  }, error = function(e) NA_real_)
}
