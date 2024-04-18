define-command visit-git-remote-url %{
  nop %sh{
    git_url_cmd=$kak_opt_plug_install_dir/gitvisit.kak/git-remote-url.sh
    if [[ $kak_selection_length == 1 ]]; then
      url=$($git_url_cmd $kak_buffile)
    else
      start_line=${kak_selection_desc%%.*}
      end_line=$(echo $kak_selection_desc | awk -F '[,.]' '{ print $3 }')
      if [[ $start_line == $end_line ]]; then
        url=$($git_url_cmd $kak_buffile $start_line)
      else
        url=$($git_url_cmd $kak_buffile $start_line $end_line)
      fi
    fi
    xdg-open $url
  }
}
