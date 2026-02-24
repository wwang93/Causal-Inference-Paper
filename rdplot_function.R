# the following r code refers to Suk (2024)Regression discontinuity designs in education: a practitioner’s guide. Asia Pacific Educ. Rev. 25, 629–645. https://doi.org/10.1007/s12564-024-09956-3


library("scales")


plot.RD <- function(frml, treat, data, kdens = 'triangular', h = NULL, SE=TRUE, linecol="red", ...)
{
  # Convert tibble to data.frame to ensure proper column extraction
  data <- as.data.frame(data)
  
  var.nam <- all.vars(frml)   # get names of variables in formula
  
  # determine plotting range left and right to cutoff (0)
  cav0 <- seq(min(data[, var.nam[2]]), 0, length = 100)
  cav1 <- seq(0, max(data[, var.nam[2]]), length = 100)
  
  # flip treatment indicator if treatment is left to the cutoff
  mean_check <- diff(tapply(data[, var.nam[2]], data[, treat], mean))
  if(!is.na(mean_check) && mean_check < 0) {
    data[, treat] <- ifelse(data[, treat] == 1, 0, 1)
  }
  
  # transform a dichotomous outcome into dummy coding
  y <- data[, var.nam[1]]
  if(is.factor(y)) {
    print(levels(y))
    data[, var.nam[1]] <- as.numeric(y)
  }
  
  # scatterplot
  plot(data[, var.nam[2]], data[, var.nam[1]], col = alpha("black", 0.15), ...)
  abline(v = 0, lty = 2)
  
  # Set default bandwidth if not provided
  if(is.null(h)) {
    h <- diff(range(data[, var.nam[2]])) / 10
  }
  
  # add nonparametric regression paths
  pre0 <- loc.reg(frml, data = data[data[, treat] == 0, ], 
                  kdens = kdens, h = h, x.val = cav0)  
  pre1 <- loc.reg(frml, data = data[data[, treat] == 1, ],
                  kdens = kdens, h = h, x.val = cav1) 
  lines(cav0, pre0$fit, lwd = 2, col=linecol)
  lines(cav1, pre1$fit, lwd = 2, col=linecol)
  
  if (SE == TRUE) {
    # add 95% confidence envelopes
    lines(cav0, pre0$fit + 2*pre0$se.fit, lty = 2)
    lines(cav0, pre0$fit - 2*pre0$se.fit, lty = 2)
    lines(cav1, pre1$fit + 2*pre1$se.fit, lty = 2)
    lines(cav1, pre1$fit - 2*pre1$se.fit, lty = 2)
  }
}

loc.reg <- function(frml, data, kdens = 'normal', h = NULL, x.val = NULL)
{
  # Convert tibble to data.frame
  data <- as.data.frame(data)
  
  if(is.null(x.val)) {
    av <- all.vars(frml)[2]
    x.val <- seq(min(data[, av]), max(data[, av]), length = 200)
  }
  
  # Set default bandwidth if not provided
  if(is.null(h)) {
    av <- all.vars(frml)[2]
    h <- diff(range(data[, av])) / 10
  }
  
  y <- sapply(x.val, loc.regmean, frml = frml, data = data, 
              kdens = kdens, h = h)
  data.frame(x = x.val, fit = y[1, ], se.fit = y[2, ])
}

loc.regmean <- function(frml, loc, data, kdens = 'normal', h = NULL)
{
  # Convert tibble to data.frame
  data <- as.data.frame(data)
  
  # Set default bandwidth if not provided
  if(is.null(h)) {
    av <- all.vars(frml)[2]
    h <- diff(range(data[, av])) / 10
  }
  
  # define function for kernel density weights
  kern <- switch(kdens,
                 normal = function(x) dnorm(x),
                 epanechnikov = function(x) ifelse(abs(x) < 1, 3/4 * (1 - x^2), 0),
                 rectangular = function(x) ifelse(abs(x) < 1, 1, 0),
                 triangular = function(x) ifelse(abs(x) < 1, 1 - abs(x), 0),
                 tricube = function(x) ifelse(abs(x) < 1, (1 - abs(x)^3)^3, 0))
  
  av <- all.vars(frml)[2]                 # name of AV
  data[, av] <- av.c <- data[, av] - loc  # center AV at location loc
  data$kern.wt <- kern(av.c / h)          # weights
  out.lm <- lm(frml, data = data, weights = kern.wt)  
  summary(out.lm)$coef[1, 1:2]            # return intercept & s.e.
}