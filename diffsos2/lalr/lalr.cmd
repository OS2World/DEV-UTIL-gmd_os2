/* lalr.cmd */

'@echo off'

infile = ''
lalr_args = ''
use_bnf  = 0
keep_bnf = 0
bnf_args = ''
bnf_file = 'lalr$$'
verbose = 0

parse arg arg1 rest
do while \ (arg1 = '')
  select
    when Left(arg1, 3) = '-cs' then
      lalr_args = lalr_args arg1
    when Left(arg1, 1) = '-' then
      do i = 2 to Length(arg1)
        c = Substr(arg1, i, 1)
        select
          when c = 'b' then
            use_bnf = 1
          when c = 'k' then
            keep_bnf = 1
          when c = 'c' then do
            lalr_args = lalr_args '-c'
            bnf_args = bnf_args '-c'
            end
          when c = 'm' then do
            lalr_args = lalr_args '-m'
            bnf_args = bnf_args '-m'
            end
          when c = 'g' then do
            lalr_args = lalr_args '-g'
            bnf_args = bnf_args '-g'
            end
          when c = 'h' then do
            lalr_args = lalr_args '-h'
            bnf_args = bnf_args '-h'
            end
          when c = 'l' then do
            lalr_args = lalr_args '-l'
            bnf_args = bnf_args '-l'
            end
          when c = 'v' then do
            lalr_args = lalr_args '-v'
            verbose = 1
            end
          otherwise
            lalr_args = lalr_args '-'c
        end  /* Select */
      end i
    when DataType( arg1, Whole number ) = 1 then
      lalr_args = lalr_args arg1
    when arg1 = '-NoAction' then
      bnf_args = bnf_args arg1
    otherwise
      infile = arg1
  end  /* Select */
  parse var rest arg1 rest
end

/*
say 'Infile   = ' infile
say 'BNF  Args = ' bnf_args
say 'LALR Args = ' lalr_args
 */

if keep_bnf = 1 then
do
  i = Pos('.', infile)
  if i = 0 then
     bnf_file = infile'.bnf'
  else
     bnf_file = Left(infile,i)'bnf'
end


if use_bnf = 1 then
  do
    if verbose = 1 then
      say 'Calling BNF' bnf_args infile '>' bnf_file
    '%GMDLIB%\lalr\bnf' bnf_args infile '>' bnf_file
    if RC = 0 then
    do
      if verbose = 1 then
        say 'Calling LALR' lalr_args bnf_file
      '%GMDLIB%\lalr\lalr' lalr_args bnf_file
    end
    if keep_bnf = 0 then
      'rm -f' bnf_file
  end
else
  do
    if verbose = 1 then
      say 'Calling LALR' lalr_args infile
    '%GMDLIB%\lalr\lalr' lalr_args infile
  end

exit RC
