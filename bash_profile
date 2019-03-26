# load ~/.profile if it exists
test -f ~/.profile && source ~/.profile

# Load ~/.bashrc if it exists (we test for interactivity there)
test -f ~/.bashrc && source ~/.bashrc
