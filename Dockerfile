FROM us.gcr.io/anvil-gcr-public/anvil-rstudio-bioconductor:0.0.6

RUN mkdir /home/book
COPY . /home/book

RUN apt-get update \
  && apt-get install --no-install-recommends -y libglpk-dev \
  && rm -rf /var/lib/apt/lists/*

RUN R --quiet -e "x12='https://storage.googleapis.com/anvil-rstudio-bioconductor/0.99/3.12'; BiocManager::install(version='3.12', site_repository=x12, ask=FALSE, update=TRUE)" \
  && R --quiet -e "options(warn=2); BiocManager::install(c('LTLA/bluster', 'LTLA/celldex', 'LTLA/scuttle'))" \
  && R --quiet -e "x12='https://storage.googleapis.com/anvil-rstudio-bioconductor/0.99/3.12'; options(warn=2); BiocManager::install(setdiff(strsplit(read.dcf('/home/book/DESCRIPTION')[,'Imports'], ',\n')[[1]], 'rebook'), site_repository=x12, ask=FALSE)" \
  && R --quiet -e "options(warn=2); BiocManager::install('bookdown')" \
  && R --quiet -e "options(warn=2); BiocManager::install('LTLA/rebook')"

RUN mkdir /home/cache
ENV EXPERIMENT_HUB_CACHE /home/cache/ExperimentHub
ENV EXPERIMENT_HUB_ASK FALSE
ENV ANNOTATION_HUB_CACHE /home/cache/AnnotationHub
ENV XDG_CACHE_HOME /home/cache
