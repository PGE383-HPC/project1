FROM mcr.microsoft.com/devcontainers/miniconda:0-3

# Copy environment.yml (if found) to a temp location so we update the environment. Also
# copy "noop.txt" so the COPY instruction does not fail if no environment.yml exists.
COPY environment.yml*  .devcontainer/noop.txt .devcontainer/conda_init.txt /tmp/conda-tmp/
RUN apt-get update; \
    apt-get -yq install vim
RUN conda install mamba -c conda-forge -y; \
    mamba install jupyterlab jupyterlab-git -c conda-forge -y; \
    if [ -f "/tmp/conda-tmp/environment.yml" ]; then umask 0002 && mamba env update -n base -f /tmp/conda-tmp/environment.yml; fi \
    && cat /tmp/conda-tmp/conda_init.txt >> /home/vscode/.bashrc; \
    rm -rf /tmp/conda-tmp

COPY Project.toml Manifest.toml .
USER vscode

# Install Julia and Julia kernel
RUN curl -fsSL https://install.julialang.org | sh -s -- -y;
RUN /home/vscode/.juliaup/bin/julia -e "using Pkg; Pkg.add(\"IJulia\"); Pkg.add(\"LanguageServer\"); Pkg.add(\"Revise\"); Pkg.activate(\".\"); Pkg.instantiate()"; \ 
    mkdir -p $HOME/.julia/config && echo "using Revise;" >> $HOME/.julia/config/startup.jl

USER root
RUN rm Project.toml Manifest.toml

