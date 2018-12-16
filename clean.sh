#!/bin/bash
find . -name *~
find . -name *~ -exec rm -f {} +
find . -name *.pyc
find . -name *.pyc -exec rm -f {} +

find . -name *.core
find . -name *.core -exec rm -f {} +

find . -name *.autosave
find . -name *.autosave -exec rm -f {} +

find . -name *.swp
find . -name *.swp -exec rm -f {} +
