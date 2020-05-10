#!/bin/bash
#
#muhammad@muntaza.id
#
#Singkronkan penambahan data baru saja tanpa menghapus hasil build
rsync -avz muntaza.github.io/ deploy_jekyll
