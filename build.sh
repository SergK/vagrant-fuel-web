#!/bin/bash

# Scirpt for running make on the vagrant host

run_in_vagrant(){
  # Run command in vagrant
  cmd=$1

  vagrant ssh -c  "cd ./fuel-web/docs && ${cmd}"
}


if [[ -z $1 ]]; then
  echo "Usage: ${0} { help | html | singlehtml | pdf | latextpdf | epub }"
  exit 1
fi

VAGRANT_SSH="vagrant ssh -c"

case "${1}" in
	html)
    run_in_vagrant "make html"
	;;

  singlehtml)
    run_in_vagrant "make singlehtml"
	;;

  pdf)
    run_in_vagrant "make pdf"
  ;;

  latexpdf)
    run_in_vagrant "make latexpdf"
  ;;
  
  epub)
    run_in_vagrant "make epub"
  ;;
  
  *)
    # try to make some custom target from user
    # no problem if we will pass error to user
    run_in_vagrant "make ${1}"
  ;;
esac
