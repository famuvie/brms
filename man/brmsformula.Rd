% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/brmsformula.R
\name{brmsformula}
\alias{brmsformula}
\alias{bf}
\title{Set up a model formula for use in \pkg{brms}}
\usage{
brmsformula(formula, ..., flist = NULL, family = NULL, autocor = NULL,
  nl = NULL)
}
\arguments{
\item{formula}{An object of class \code{formula} 
(or one that can be coerced to that class): 
a symbolic description of the model to be fitted. 
The details of model specification are given in 'Details'.}

\item{...}{Additional \code{formula} objects to specify 
predictors of non-linear and distributional parameters. 
Formulas can either be named directly or contain
names on their left-hand side. 
The following are distributional parameters of specific families
(all other parameters are treated as non-linear parameters):
\code{sigma} (residual standard deviation or scale of
the \code{gaussian}, \code{student}, \code{skew_normal}, 
\code{lognormal} \code{exgaussian}, and \code{asym_laplace} families);
\code{shape} (shape parameter of the \code{Gamma},
\code{weibull}, \code{negbinomial}, and related
zero-inflated / hurdle families); \code{nu} (degrees of freedom 
parameter of the \code{student} and \code{frechet} families);
\code{phi} (precision parameter of the \code{beta} 
and \code{zero_inflated_beta} families);
\code{kappa} (precision parameter of the \code{von_mises} family);
\code{beta} (mean parameter of the exponential componenent
of the \code{exgaussian} family);
\code{quantile} (quantile parameter of the \code{asym_laplace} family);
\code{zi} (zero-inflation probability); 
\code{hu} (hurdle probability);
\code{zoi} (zero-one-inflation probability);
\code{coi} (conditional one-inflation probability);
\code{disc} (discrimination) for ordinal models;
\code{bs}, \code{ndt}, and \code{bias} (boundary separation,
non-decision time, and initial bias of the \code{wiener}
diffusion model).
By default, distributional parameters are modeled 
on the log scale if they can be positive only or on the 
logit scale if the can only be within the unit interval.
See 'Details' for more explanation.}

\item{flist}{Optional list of formulas, which are treated in the 
same way as formulas passed via the \code{...} argument.}

\item{family}{Same argument as in \code{\link{brm}}.
If \code{family} is specified in \code{brmsformula}, it will 
overwrite the value specified in \code{\link{brm}}.}

\item{autocor}{Same argument as in \code{\link{brm}}.
If \code{autocor} is specified in \code{brmsformula}, it will 
overwrite the value specified in \code{\link{brm}}.}

\item{nl}{Logical; Indicates whether \code{formula} should be
treated as specifying a non-linear model. By default, \code{formula} 
is treated as an ordinary linear model formula.}
}
\value{
An object of class \code{brmsformula}, which
  is essentially a \code{list} containing all model
  formulas as well as some additional information.
}
\description{
Set up a model formula for use in the \pkg{brms} package
allowing to define (potentially non-linear) additive multilevel 
models for all parameters of the assumed response distribution.
}
\details{
\bold{General formula structure}
  
  The \code{formula} argument accepts formulas of the following syntax:
  
  \code{response | aterms ~ pterms + (gterms | group)} 
  
  The \code{pterms} part contains effects that are assumed to be the 
  same across obervations. We call them 'population-level' effects
  or (adopting frequentist vocabulary) 'fixed' effects. The optional
  \code{gterms} part may contain effects that are assumed to vary
  accross grouping variables specified in \code{group}. We
  call them 'group-level' effects or (adopting frequentist 
  vocabulary) 'random' effects, although the latter name is misleading
  in a Bayesian context.
  For more details type \code{vignette("brms_overview")} and
  \code{vignette("brms_multilevel")}. 
  
  \bold{Group-level terms}
  
  Multiple grouping factors each with multiple group-level effects 
  are possible. (Of course we can also run models without any
  group-level effects.) 
  Instead of \code{|} you may use \code{||} in grouping terms
  to prevent correlations from being modeled. 
  Alternatively, it is possible to model different group-level terms of 
  the same grouping factor as correlated (even across different formulae,
  e.g., in non-linear models) by using \code{|<ID>|} instead of \code{|}.
  All group-level terms sharing the same ID will be modeled as correlated.
  If, for instance, one specifies the terms \code{(1+x|2|g)} and 
  \code{(1+z|2|g)} somewhere in the formulae passed to \code{brmsformula},
  correlations between the corresponding group-level effects 
  will be estimated. 
  
  You can specify multi-membership terms
  using the \code{\link[brms:mm]{mm}} function. For instance, 
  a multi-membership term with two members could be
  \code{(1|mm(g1, g2))}, where \code{g1} and \code{g2} specify
  the first and second member, respectively.
  
  \bold{Special predictor terms}
  
  Smoothing terms can modeled using the \code{\link[brms:s]{s}}
  and \code{\link[brms:t2]{t2}} functions in the \code{pterms} part 
  of the model formula. This allows to fit generalized additive mixed
  models (GAMMs) with \pkg{brms}. The implementation is similar to that 
  used in the \pkg{gamm4} package. For more details on this model class 
  see \code{\link[mgcv:gam]{gam}} and \code{\link[mgcv:gamm]{gamm}}.
  
  Gaussian process terms can be fitted using the \code{\link[brms:gp]{gp}}
  function in the \code{pterms} part of the model formula. Similar to
  smooth terms, Gaussian processes can be used to model complex non-linear
  relationsships, for instance temporal or spatial autocorrelation. 
  However, they are computationally demanding and are thus not recommended 
  for very large datasets.
  
  The \code{pterms} and \code{gterms} parts may contain three non-standard
  effect types namely monotonic, measurement error, and category specific effects,
  which can be specified using terms of the form \code{mo(predictor)},
  \code{me(predictor, sd_predictor)}, and \code{cs(<predictors>)}, 
  respectively. Category specific effects can only be estimated in
  ordinal models and are explained in more detail in the package's 
  main vignette (type \code{vignette("brms_overview")}). 
  The other two effect types are explained in the following.
  
  A monotonic predictor must either be integer valued or an ordered factor, 
  which is the first difference to an ordinary continuous predictor. 
  More importantly, predictor categories (or integers) are not assumend to be 
  equidistant with respect to their effect on the response variable. 
  Instead, the distance between adjacent predictor categories (or integers) 
  is estimated from the data and may vary across categories. 
  This is realized by parameterizing as follows: 
  One parameter takes care of the direction and size of the effect similar 
  to an ordinary regression parameter, while an additional parameter vector 
  estimates the normalized distances between consecutive predictor categories.     
  A main application of monotonic effects are ordinal predictors that
  can this way be modeled without (falsely) treating them as continuous
  or as unordered categorical predictors. For more details and examples
  see \code{vignette("brms_monotonic")}.
  
  Quite often, predictors are measured and as such naturally contain 
  measurement error. Although most reseachers are well aware of this problem,
  measurement error in predictors is ignored in most
  regression analyses, possibly because only few packages allow
  for modelling it. Notably, measurement error can be handled in 
  structural equation models, but many more general regression models
  (such as those featured by \pkg{brms}) cannot be transferred 
  to the SEM framework. In \pkg{brms}, effects of noise-free predictors 
  can be modeled using the \code{me} (for 'measurement error') function.
  If, say, \code{y} is the response variable and 
  \code{x} is a measured predictor with known measurement error
  \code{sdx}, we can simply include it on the right-hand side of the
  model formula via \code{y ~ me(x, sdx)}. 
  This can easily be extended to more general formulae. 
  If \code{x2} is another measured predictor with corresponding error
  \code{sdx2} and \code{z} is a predictor without error
  (e.g., an experimental setting), we can model all main effects 
  and interactions of the three predictors in the well known manner: 
  \code{y ~ me(x, sdx) * me(x2, sdx2) * z}. In future version of \pkg{brms},
  a vignette will be added to explain more details about these
  so called 'error-in-variables' models and provide real world examples.
  
  \bold{Additional response information}
  
  Another speciality of the \pkg{brms} formula syntax is the optional 
  \code{aterms} part, which may contain multiple terms of the form 
  \code{fun(<variable>)} seperated by \code{+} each providing special 
  information on the response variable. \code{fun} can be replaced with 
  either \code{se}, \code{weights}, \code{cens}, \code{trunc}, 
  \code{trials}, \code{cat}, or \code{dec}. Their meanings are explained below.
  (see also \code{\link[brms:addition-terms]{addition-terms}}). 
  
  For families \code{gaussian}, \code{student} and \code{skew_normal}, it is 
  possible to specify standard errors of the observations, thus allowing 
  to perform meta-analysis. Suppose that the variable \code{yi} contains 
  the effect sizes from the studies and \code{sei} the corresponding 
  standard errors. Then, fixed and random effects meta-analyses can 
  be conducted using the formulae \code{yi | se(sei) ~ 1} and 
  \code{yi | se(sei) ~ 1 + (1|study)}, respectively, where 
  \code{study} is a variable uniquely identifying every study.
  If desired, meta-regression can be performed via 
  \code{yi | se(sei) ~ 1 + mod1 + mod2 + (1|study)} 
  or \cr \code{yi | se(sei) ~ 1 + mod1 + mod2 + (1 + mod1 + mod2|study)}, 
  where \code{mod1} and \code{mod2} represent moderator variables. 
  By default, the standard errors replace the paramter \code{sigma}.
  To model \code{sigma} in addition to the known standard errors,
  set argument \code{sigma} in function \code{se} to \code{TRUE}, 
  for instance, \code{yi | se(sei, sigma = TRUE) ~ 1}.
  
  For all families, weighted regression may be performed using
  \code{weights} in the \code{aterms} part. Internally, this is 
  implemented by multiplying the log-posterior values of each 
  observation by their corresponding weights.
  Suppose that variable \code{wei} contains the weights 
  and that \code{yi} is the response variable. 
  Then, formula \code{yi | weights(wei) ~ predictors} 
  implements a weighted regression. 
  
  With the exception of categorical, ordinal, and mixture families, 
  left, right, and interval censoring can be modeled through 
  \code{y | cens(censored) ~ predictors}. The censoring variable 
  (named \code{censored} in this example) should contain the values 
  \code{'left'}, \code{'none'}, \code{'right'}, and \code{'interval'} 
  (or equivalenty \code{-1}, \code{0}, \code{1}, and \code{2}) to indicate that 
  the corresponding observation is left censored, not censored, right censored,
  or interval censored. For interval censored data, a second variable
  (let's call it \code{y2}) has to be passed to \code{cens}. In this case, 
  the formula has the structure \code{y | cens(censored, y2) ~ predictors}. 
  While the lower bounds are given in \code{y}, the upper bounds are given 
  in \code{y2} for interval censored data. Intervals are assumed to be open 
  on the left and closed on the right: \code{(y, y2]}.
  
  With the exception of categorical, ordinal, and mixture families, 
  the response distribution can be truncated using the \code{trunc} 
  function in the addition part. If the response variable is truncated 
  between, say, 0 and 100, we can specify this via
  \code{yi | trunc(lb = 0, ub = 100) ~ predictors}. 
  Instead of numbers, variables in the data set can also be passed allowing 
  for varying truncation points across observations. Defining only one of 
  the two arguments in \code{trunc} leads to one-sided truncation.
  
  For families \code{binomial} and \code{zero_inflated_binomial}, 
  addition should contain a variable indicating the number of trials 
  underlying each observation. In \code{lme4} syntax, we may write for instance 
  \code{cbind(success, n - success)}, which is equivalent
  to \code{success | trials(n)} in \pkg{brms} syntax. If the number of trials
  is constant across all observations, say \code{10}, 
  we may also write \code{success | trials(10)}. 
  
  For all ordinal families, \code{aterms} may contain a term 
  \code{cat(number)} to specify the number categories (e.g, \code{cat(7)}). 
  If not given, the number of categories is calculated from the data.
  
  In Wiener diffusion models (family \code{wiener}) the addition term
  \code{dec} is mandatory to specify the (vector of) binary decisions 
  corresponding to the reaction times. Non-zero values will be treated
  as a response on the upper boundary of the diffusion process and zeros
  will be treated as a response on the lower boundary. Alternatively,
  the variable passed to \code{dec} might also be a character vector 
  consisting of \code{'lower'} and \code{'upper'}.

  Mutiple addition terms may be specified at the same time using 
  the \code{+} operator, for instance \cr
  \code{formula = yi | se(sei) + cens(censored) ~ 1} 
  for a censored meta-analytic model. 
  
  The addition argument \code{disp} (short for dispersion) 
  has been removed in version 2.0. You may instead use the 
  distributional regression approach by specifying
  \code{sigma ~ 1 + offset(log(xdisp))} or
  \code{shape ~ 1 + offset(log(xdisp))}, where \code{xdisp} is
  the variable being previously passed to \code{disp}.
  
  \bold{Parameterization of the population-level intercept}
  
  The population-level intercept (if incorporated) is estimated separately 
  and not as part of population-level parameter vector \code{b}. 
  As a result, priors on the intercept also have to be specified separately.
  Furthermore, to increase sampling efficiency, the population-level 
  design matrix \code{X} is centered around its column means 
  \code{X_means} if the intercept is incorporated. 
  This leads to a temporary bias in the intercept equal to 
  \code{<X_means, b>}, where \code{<,>} is the scalar product. 
  The bias is corrected after fitting the model, but be aware 
  that you are effectively defining a prior on the intercept 
  of the centered design matrix not on the real intercept.
  For more details on setting priors on population-level intercepts,
  see \code{\link[brms:set_prior]{set_prior}}.
  
  This behavior can be avoided by using the reserved 
  (and internally generated) variable \code{intercept}. 
  Instead of \code{y ~ x}, you may write
  \code{y ~ 0 + intercept + x}. This way, priors can be
  defined on the real intercept, directly. In addition,
  the intercept is just treated as an ordinary population-level effect
  and thus priors defined on \code{b} will also apply to it. 
  Note that this parameterization may be less efficient
  than the default parameterization discussed above.  
  
  \bold{Formula syntax for non-linear models}
  
  In \pkg{brms}, it is possible to specify non-linear models 
  of arbitrary complexity.
  The non-linear model can just be specified within the \code{formula}
  argument. Suppose, that we want to predict the response \code{y}
  through the predictor \code{x}, where \code{x} is linked to \code{y}
  through \code{y = alpha - beta * lambda^x}, with parameters
  \code{alpha}, \code{beta}, and \code{lambda}. This is certainly a
  non-linear model being defined via
  \code{formula = y ~ alpha - beta * lambda^x} (addition arguments 
  can be added in the same way as for ordinary formulas).
  To tell \code{brms} that this is a non-linear model, 
  we set argument \code{nl} to \code{TRUE}.
  Now we have to specfiy a model for each of the non-linear parameters. 
  Let's say we just want to estimate those three parameters
  with no further covariates or random effects. Then we can pass
  \code{alpha + beta + lambda ~ 1} or equivalently
  (and more flexible) \code{alpha ~ 1, beta ~ 1, lambda ~ 1} 
  to the \code{...} argument.
  This can, of course, be extended. If we have another predictor \code{z} and 
  observations nested within the grouping factor \code{g}, we may write for 
  instance \code{alpha ~ 1, beta ~ 1 + z + (1|g), lambda ~ 1}.
  The formula syntax described above applies here as well.
  In this example, we are using \code{z} and \code{g} only for the 
  prediction of \code{beta}, but we might also use them for the other
  non-linear parameters (provided that the resulting model is still 
  scientifically reasonable). 
  
  Non-linear models may not be uniquely identified and / or show bad convergence.
  For this reason it is mandatory to specify priors on the non-linear parameters.
  For instructions on how to do that, see \code{\link[brms:set_prior]{set_prior}}.
  For some examples of non-linear models, see \code{vignette("brms_nonlinear")}.
  
  \bold{Formula syntax for predicting distributional parameters}
  
  It is also possible to predict parameters of the response
  distribution such as the residual standard deviation \code{sigma} 
  in gaussian models or the hurdle probability \code{hu} in hurdle models. 
  The syntax closely resembles that of a non-linear 
  parameter, for instance \code{sigma ~ x + s(z) + (1+x|g)}. 
  For some examples of distributional models, see \code{vignette("brms_distreg")}.
  
  Alternatively, one may fix distributional parameters to certain values.
  However, this is mainly useful when models become too 
  complicated and otherwise have convergence issues. 
  We thus suggest to be generally careful when making use of this option. 
  The \code{quantile} parameter of the \code{asym_laplace} distribution
  is a good example where it is useful. By fixing \code{quantile}, 
  one can perform quantile regression for the specified quantile. 
  For instance, \code{quantile = 0.25} allows predicting the 25\%-quantile.
  Furthermore, the \code{bias} parameter in drift-diffusion models, 
  is assumed to be \code{0.5} (i.e. no bias) in many applications. 
  To achieve this, simply write \code{bias = 0.5}. 
  Other possible applications are the Cauchy distribution as a 
  special case of the Student-t distribution with 
  \code{nu = 1}, or the geometric distribution as a special case of
  the negative binomial distribution with \code{shape = 1}.
  Furthermore, the parameter \code{disc} ('discrimination') in ordinal 
  models is fixed to \code{1} by default and not estimated,
  but may be modeled as any other distributional parameter if desired
  (see examples). For reasons of identification, \code{'disc'}
  can only be positive, which is achieved by applying the log-link.
  
  In categorical models, distributional parameters do not have
  fixed names. Instead, they are named after the response categories 
  (excluding the first one, which serves as the reference category),
  with the prefix \code{'mu'}. If, for instance, catgories are named 
  \code{cat1}, \code{cat2}, and \code{cat3}, the distributional parameters
  will be named \code{mucat2} and \code{mucat3}.
  
  Some distributional parameters currently supported by \code{brmsformula}
  have to be positive (a negative standard deviation or precision parameter 
  doesn't make any sense) or are bounded between 0 and 1 (for zero-inflated / 
  hurdle proabilities, quantiles, or the intial bias parameter of 
  drift-diffusion models). 
  However, linear predictors can be positive or negative, and thus the log link 
  (for positive parameters) or logit link (for probability parameters) are used 
  by default to ensure that distributional parameters are within their valid intervals.
  This implies that, by default, effects for such distributional parameters are 
  estimated on the log / logit scale and one has to apply the inverse link 
  function to get to the effects on the original scale.
  Alternatively, it is possible to use the identity link to predict parameters
  on their original scale, directly. However, this is much more likely to lead 
  to problems in the model fitting, if the parameter actually has a restrcited range.
  
  See also \code{\link[brms:brmsfamily]{brmsfamily}} for an overview of 
  valid link functions.
  
  \bold{Formula syntax for mixture models}
  
  The specification of mixture models closely resembles that 
  of non-mixture models. If not specified otherwise (see below), 
  all mean parameters of the mixture components are predicted
  using the right-hand side of \code{formula}. All types of predictor
  terms allowed in non-mixture models are allowed in mixture models
  as well.
  
  distributional parameters of mixture distributions have the same 
  name as those of the corresponding ordinary distributions, but with 
  a number at the end to indicate the mixture component. For instance, if
  you use family \code{mixture(gaussian, gaussian)}, the distributional
  parameters are \code{sigma1} and \code{sigma2}.
  distributional parameters of the same class can be fixed to the same value. 
  For the above example, we could write \code{sigma2 = "sigma1"} to make
  sure that both components have the same residual standard deviation,
  which is in turn estimated from the data.
  
  In addition, there are two types of special distributional parameters.
  The first are named \code{mu<ID>}, that allow for modeling different 
  predictors for the mean parameters of different mixture components. 
  For instance, if you want to predict the mean of the first component 
  using predictor \code{x} and the mean of the second component using 
  predictor \code{z}, you can write \code{mu1 ~ x} as well as \code{mu2 ~ z}. 
  The second are named \code{theta<ID>}, which constitute the mixing 
  proportions. If the mixing proportions are fixed to certain values, 
  they are internally normalized to form a probability vector.
  If one seeks to predict the mixing proportions, all but 
  one of the them has to be predicted, while the remaining one is used
  as the reference category to identify the model. The \code{softmax} 
  function is applied on the linear predictor terms to form a 
  probability vector.
  
  For more information on mixture models, see
  the documentation of \code{\link[brms:mixture]{mixture}}.
  
  \bold{Formula syntax for multivariate models}
  
  Multivariate models may be specified using \code{cbind} notation
  or with help of the \code{\link{mvbf}} function.
  Suppose that \code{y1} and \code{y2} are response variables 
  and \code{x} is a predictor. Then \code{cbind(y1, y2) ~ x} 
  specifies a multivariate model,
  The effects of all terms specified at the RHS of the formula 
  are assumed to vary across response variables. 
  For instance, two parameters will be estimated for \code{x}, 
  one for the effect on \code{y1} and another for the effect on \code{y2}.
  This is also true for group-level effects. When writing, for instance,
  \code{cbind(y1, y2) ~ x + (1+x|g)}, group-level effects will be
  estimated separately for each response. To model these effects
  as correlated across responses, use the ID syntax (see above).
  For the present example, this would look as follows:
  \code{cbind(y1, y2) ~ x + (1+x|2|g)}. Of course, you could also use
  any value other than \code{2} as ID.
  
  It is also possible to specify different formulas for different responses.
  If, for instance, \code{y1} should be predicted by \code{x} and \code{y2}
  should be predicted by \code{z}, we could write \code{mvbf(y1 ~ x, y2 ~ z)}.
  Alternatively, multiple \code{brmsformula} objects can be added to
  specify a joint multivariate model (see 'Examples').
}
\examples{
# multilevel model with smoothing terms
brmsformula(y ~ x1*x2 + s(z) + (1+x1|1) + (1|g2))

# additionally predict 'sigma'
brmsformula(y ~ x1*x2 + s(z) + (1+x1|1) + (1|g2), 
            sigma ~ x1 + (1|g2))
            
# use the shorter alias 'bf'
(formula1 <- brmsformula(y ~ x + (x|g)))
(formula2 <- bf(y ~ x + (x|g)))
# will be TRUE
identical(formula1, formula2)

# incorporate censoring
bf(y | cens(censor_variable) ~ predictors)

# define a simple non-linear model
bf(y ~ a1 - a2^x, a1 + a2 ~ 1, nl = TRUE)

# predict a1 and a2 differently
bf(y ~ a1 - a2^x, a1 ~ 1, a2 ~ x + (x|g), nl = TRUE)

# correlated group-level effects across parameters
bf(y ~ a1 - a2^x, a1 ~ 1 + (1|2|g), a2 ~ x + (x|2|g), nl = TRUE)

# define a multivariate model
bf(cbind(y1, y2) ~ x * z + (1|g))

# define a zero-inflated model 
# also predicting the zero-inflation part
bf(y ~ x * z + (1+x|ID1|g), zi ~ x + (1|ID1|g))

# specify a predictor as monotonic
bf(y ~ mo(x) + more_predictors)

# for ordinal models only
# specify a predictor as category specific
bf(y ~ cs(x) + more_predictors)
# add a category specific group-level intercept
bf(y ~ cs(x) + (cs(1)|g))
# specify parameter 'disc'
bf(y ~ person + item, disc ~ item)

# specify variables containing measurement error
bf(y ~ me(x, sdx))

# specify predictors on all parameters of the wiener diffusion model
# the main formula models the drift rate 'delta'
bf(rt | dec(decision) ~ x, bs ~ x, ndt ~ x, bias ~ x)

# fix the bias parameter to 0.5
bf(rt | dec(decision) ~ x, bias = 0.5)

# specify different predictors for different mixture components
mix <- mixture(gaussian, gaussian)
bf(y ~ 1, mu1 ~ x, mu2 ~ z, family = mix)

# fix both residual standard deviations to the same value
bf(y ~ x, sigma2 = "sigma1", family = mix)

# use the '+' operator to specify models
bf(y ~ 1) + 
  nlf(sigma ~ a * exp(b * x), a ~ x) + 
  lf(b ~ z + (1|g), dpar = "sigma") +
  gaussian()
  
# specify a multivariate model using the '+' operator
bf(y1 ~ x + (1|g)) + 
  gaussian() + cor_ar(~1|g) +
  bf(y2 ~ z) + poisson()

}
\seealso{
\code{\link{mvbrmsformula}}, \code{\link{brmsformula-helpers}}
}
