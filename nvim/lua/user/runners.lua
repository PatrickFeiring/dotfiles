vim.cmd([[
    function! s:execute_line() abort
        if &ft == 'lua'
            call execute(printf(':lua %s', getline('.')))
        elseif &ft == 'vim'
            exe getline('.')
        endif
    endfunction

    function! s:save_and_execute_file() abort
        if &ft == 'lua'
            :silent! write
            :luafile %
        elseif &ft == 'vim'
            :silent! write
            :source %
        endif
    endfunction

    nnoremap <leader>x :call <SID>execute_line()<CR>
    vnoremap <leader>x :<C-w>exe join(get("'<", "'>"), '<Bar>')<CR>
    nnoremap <leader><leader>x :call <SID>save_and_execute_file()<CR>
]])
