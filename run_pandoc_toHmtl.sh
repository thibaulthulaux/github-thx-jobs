#!/usr/bin/env bash

pandocToHtml () {
  local filename="${1##*/}"
  # echo "filename="$filename
  local filenamenoext="${filename%.*}"
  # echo "filenamenoext="$filenamenoext
  local author="Thibault HULAUX"
  # echo "author="$author
  local lang="${folder#*-}"
  # echo "lang="$lang
  local title="${author} - ${filenamenoext}-${folder}"
  # echo "title="$title
  local date="$(date "+%Y-%m-%d")"
  # echo "date="$date
  local css="pandoc/css/${filenamenoext}.css"
  # echo "css="$css
  local template="pandoc/templates/${filenamenoext}.html"
  # echo "template="$template
  local source="jobs/${folder}/${filenamenoext}.md"
  # echo "source="$source
  local output="${filenamenoext}-${folder}.html"
  # echo "output="$output

  local params=(
#    --verbose
    --standalone
    --template="${template}"
    --metadata="date:${date}"
    --metadata="title:${title}"
    --metadata="author:${author}"
    --metadata="lang:${lang}"
    --css="${css}"
    -o "${output}"
    "${source}" 
  )

  pandoc "${params[@]}"
  echo "[Succes] $(pwd)/${output} processed." 
}

main () {
  if [[ -n ${@} ]]; then
    local folder=${1}
    # echo "folder="$folder
    if [[ -d jobs/${folder} ]]; then
        # echo "jobs/${folder} exists"
      for file in $(find jobs/${folder} -type f -name '*.md'); do 
        # echo "file="$file
        pandocToHtml ${file}
      done
      echo "[End] ${folder} complete."
    else
      echo "[Error] ${folder} doesnt exist." 
      exit 1
    fi
  else
  echo "[Help] Usage: $(basename ${0}) [folder] ['job title']"
  echo "List:"
  echo "$(ls jobs)"
  exit 1
  fi
}

main ${@}
exit 0