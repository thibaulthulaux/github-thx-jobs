#!/usr/bin/env bash

pandocToHtml () {
  local filename="${1##*/}"
  echo $filename
  local filenamenoext="${filename%.*}"
  echo $filenamenoext
  local author="Thibault HULAUX"
  echo $author
  local lang="${folder#*-}"
  echo $lang
  local title="${author} - ${filenamenoext}-${folder}"
  echo $title
  local date="$(date "+%Y-%m-%d")"
  echo $date
  local css="pandoc/css/${filenamenoext}.css"
  echo $css
  local template="pandoc/templates/${filenamenoext}.html"
  echo $template
  local source="jobs/${folder}/${filenamenoext}.md"
  echo $source
  local output="${filenamenoext}-${folder}.html"
  echo $output

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
    if [[ -d jobs/${folder} ]]; then
      for file in $(find jobs/${folder} -type f -name *.md); do 
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